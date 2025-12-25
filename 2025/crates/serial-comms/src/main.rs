use clap::Parser;
use color_eyre::Result;
use mio_serial::{SerialPort, SerialPortType};
use std::sync::mpsc;
use types::{
    codegen::{
        top::{Ping, Pong, ReadRam, ReadRamAck, Types, WriteRam, WriteRamAck},
        Top,
    },
    Destination, Header, SerDe, Type,
};

const BAUD: u32 = 115200;

#[derive(Parser)]
struct Args {
    #[clap(help = "Serial port to open")]
    port: Option<String>,
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let args = Args::parse();

    if let Some(port) = args.port {
        do_run(&port)
    } else {
        print_ports()
    }
}

fn print_ports() -> Result<()> {
    let mut available_ports = mio_serial::available_ports()?;
    let available_ports_count = available_ports.len();
    available_ports
        .retain(|port| matches!(port.port_type, SerialPortType::UsbPort(..)));
    let usb_ports_count = available_ports.len();

    println!(
        "Discovered {usb_ports_count} USB serial ports \
    	({available_ports_count} overall)",
    );
    for port in available_ports {
        let SerialPortType::UsbPort(info) = port.port_type else {
            unreachable!()
        };

        println!(
            "{}: {} ({})",
            port.port_name,
            info.product.as_deref().unwrap_or("unknown"),
            info.manufacturer.as_deref().unwrap_or("unknown"),
        );
    }

    Ok(())
}

fn do_run(port: &str) -> Result<()> {
    let mut port = mio_serial::new(port, BAUD).open()?;
    let read_port = port.try_clone()?;
    let (tx, rx) = mpsc::channel();
    read_thread(read_port, tx);

    let mut buf = [0; 1024];

    let ping = Ping {
        data: rand::random(),
    };
    let header = Header {
        destination: Top::ID,
        ty: Ping::ID,
        len: 4,
    };
    buf[0..4].copy_from_slice(&<[u8; 4]>::from(header));
    let len = 4 + ping.serialise(&mut buf[4..])?;
    let to_send = &buf[..len];
    println!("Sending: {to_send:02x?}");
    port.write_all(to_send)?;

    let response = rx.recv().unwrap();
    println!("Received response: {response:02x?}");
    assert_eq!(response, Pong { data: ping.data }.into());

    let write_ram = Types::from(WriteRam {
        offset: 0x0000_0000,
        data: [0xaa; 128],
    });
    let len = write_ram.serialise(&mut buf)?;
    let to_send = &buf[..len];
    println!("Sending WriteRam: {}", hex::encode(to_send));
    port.write_all(to_send)?;
    let response = rx.recv().unwrap();
    println!("Received response: {response:02x?}");
    assert_eq!(
        response,
        WriteRamAck {
            offset: 0x0000_0000,
            ok: 0x0100_0000,
        }
        .into()
    );

    let read_ram = Types::from(ReadRam {
        offset: 0x0000_0000,
    });
    let len = read_ram.serialise(&mut buf)?;
    let to_send = &buf[..len];
    println!("Sending ReadRam: {}", hex::encode(to_send));
    port.write_all(to_send)?;
    let response = rx.recv().unwrap();
    println!("Received response: {response:02x?}");
    assert_eq!(
        response,
        ReadRamAck {
            offset: 0x0000_0000,
            ok: 0x0100_0000,
            data: [0xaa; 128],
        }
        .into()
    );

    Ok(())
}

fn read_thread(mut port: Box<dyn SerialPort>, tx: mpsc::Sender<Types>) {
    enum RxState {
        Header,
        Payload,
    }
    std::thread::spawn(move || {
        let mut state = RxState::Header;
        let mut header = Header {
            destination: 0,
            ty: 0,
            len: 0,
        };
        let mut buf = [0; 4];
        let mut receive_buf = Vec::new();
        loop {
            let Ok(()) = port.read_exact(&mut buf) else {
                continue;
            };
            println!("Read 4 bytes: {:02x?}", &buf);

            receive_buf.extend_from_slice(&buf);
            state = match state {
                RxState::Header => {
                    header = Header::from(buf);
                    RxState::Payload
                }
                RxState::Payload => {
                    if receive_buf.len() == usize::from(header.len) + 4 {
                        println!(
                            "Received packet: {}",
                            hex::encode(&receive_buf),
                        );
                        match Types::deserialise(&receive_buf) {
                            Ok(parsed) => tx.send(parsed).unwrap(),
                            Err(err) => {
                                eprintln!("Deserialisation failed: {err}")
                            }
                        }
                        receive_buf.clear();
                        RxState::Header
                    } else {
                        RxState::Payload
                    }
                }
            };
        }
    });
}
