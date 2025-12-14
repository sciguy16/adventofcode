use clap::Parser;
use color_eyre::Result;
use mio_serial::{SerialPort, SerialPortType};
use std::time::Duration;

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
    use types::{
        codegen::{top::Ping, Top},
        Destination, Header, SerDe, Type,
    };

    let mut port = mio_serial::new(port, BAUD).open()?;
    let read_port = port.try_clone()?;
    read_thread(read_port);

    let mut buf = [0; 1024];

    let packet = Ping { data: 0xabcd1234 };
    let header = Header {
        destination: Top::ID,
        ty: Ping::ID,
        len: 4,
    };
    buf[0..4].copy_from_slice(&<[u8; 4]>::from(header));
    let len = 4 + packet.serialise(&mut buf[4..])?;
    let to_send = &buf[..len];
    println!("Sending: {to_send:02x?}");

    port.write_all(to_send)?;

    loop {
        std::thread::sleep(Duration::from_secs(1));
    }
    // Ok(())
}

fn read_thread(mut port: Box<dyn SerialPort>) {
    std::thread::spawn(move || {
        let mut buf = [0; 1024];
        while let Ok(len) = port.read(&mut buf) {
            println!("Read {len} bytes: {:02x?}", &buf[..len]);
        }
    });
}
