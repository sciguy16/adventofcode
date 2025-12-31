use color_eyre::{Result, eyre::eyre};
use mio_serial::{SerialPort, SerialPortType, UsbPortInfo};
use rand::Rng;
use std::{fmt::Write, sync::mpsc, time::Duration};
use types::{Header, SerDe, codegen::top::Types};

const BAUD: u32 = 115200;
const RECV_TIMEOUT: Duration = Duration::from_secs(10);

pub struct PortInfo {
    pub name: String,
    pub info: UsbPortInfo,
}

pub fn list_ports() -> Result<Vec<PortInfo>> {
    let available_ports = mio_serial::available_ports()?;

    Ok(available_ports
        .into_iter()
        .filter_map(|port| {
            if let SerialPortType::UsbPort(info) = port.port_type {
                Some(PortInfo {
                    name: port.port_name,
                    info,
                })
            } else {
                None
            }
        })
        .collect())
}

pub struct SerialHandler {
    port: Box<dyn SerialPort>,
    read_rx: mpsc::Receiver<Types>,
}

impl SerialHandler {
    pub fn open(port: &str) -> Result<Self> {
        let port = mio_serial::new(port, BAUD).open()?;
        let read_port = port.try_clone()?;
        let (read_tx, read_rx) = mpsc::channel();
        read_thread(read_port, read_tx);

        Ok(Self { port, read_rx })
    }

    pub fn send(&mut self, packet: Types) -> Result<Types> {
        let mut buf = [0; 1024];
        let len = packet.serialise(&mut buf)?;
        let to_send = &buf[..len];
        println!("Sending: {}", hex_string_as_words(to_send));
        self.port.write_all(to_send)?;

        let response = self.read_rx.recv_timeout(RECV_TIMEOUT)?;
        println!("Received response: {response:02x?}");

        Ok(response)
    }

    pub fn ping_pong(&mut self) -> Result<()> {
        use types::codegen::top::{Ping, Pong};

        let data = rand::random();
        let ping = Ping { data };
        let response = self.send(ping.into())?;

        if response == (Pong { data }) {
            Ok(())
        } else {
            Err(eyre!("Ping response mismatch"))
        }
    }

    pub fn write_ram(&mut self, offset: u32, data: [u8; 128]) -> Result<()> {
        use types::codegen::top::{Types, WriteRam, WriteRamAck};

        let write_ram = Types::from(WriteRam { offset, data });
        let response = self.send(write_ram)?;
        if response
            == (WriteRamAck {
                offset: 0x0000_0000,
                ok: 0x0100_0000,
            })
        {
            Ok(())
        } else {
            Err(eyre!("WriteRam response mismatch"))
        }
    }

    pub fn read_ram(&mut self, offset: u32) -> Result<[u8; 128]> {
        use types::codegen::top::{ReadRam, Types};

        let read_ram = Types::from(ReadRam {
            offset: 0x0000_0000,
        });
        let response = self.send(read_ram)?;
        if let Types::ReadRamAck(response) = response
            && response.offset == offset
            && response.ok == 0x0100_0000
        {
            Ok(response.data)
        } else {
            Err(eyre!("ReadRam response mismatch"))
        }
    }

    pub fn run_day(&mut self, day: u8, data_len_bytes: u16) -> Result<()> {
        use types::codegen::top::{RunDay, Types};

        let run_day = Types::from(RunDay {
            day,
            data_len_bytes,
            padding: 0,
        });
        let response = self.send(run_day)?;
        if let Types::RunDayAck(response) = response
            && response.day == day
            && response.ok == 0x01
        {
            Ok(())
        } else {
            Err(eyre!("RunDay response mismatch"))
        }
    }

    pub fn self_test(&mut self) -> Result<()> {
        self.ping_pong()?;

        let mut rng = rand::rng();
        let data = rng.random();
        self.write_ram(0x00, data)?;
        let read_back = self.read_ram(0x00)?;
        if data != read_back {
            return Err(eyre!(
                "Data readback mismatch!\nSent: {}\nRead: {}",
                hex_string_as_words(&data),
                hex_string_as_words(&read_back),
            ));
        }

        let mut test_data = [0_u16; 10];
        rng.fill(&mut test_data);
        let sum = test_data.iter().copied().map(u32::from).sum::<u32>();
        println!("Test data: {test_data:?}, sum={sum}");

        let mut to_send = String::new();
        for line in test_data {
            let _ = writeln!(&mut to_send, "{line}");
        }

        let to_send = to_send.as_bytes();
        let (chunks, rest) = to_send.as_chunks::<128>();
        let rest = (!rest.is_empty()).then(|| {
            let mut out = [0; 128];
            out[..rest.len()].copy_from_slice(rest);
            out
        });
        for (idx, chunk) in chunks.iter().chain(rest.iter()).enumerate() {
            let offset = u32::try_from(idx).unwrap() * 32;
            self.write_ram(offset, *chunk)?;
        }
        for (idx, chunk) in chunks.iter().chain(rest.iter()).enumerate() {
            let offset = u32::try_from(idx).unwrap() * 32;
            let read_back = self.read_ram(offset)?;
            if *chunk != read_back {
                return Err(eyre!(
                    "Data readback mismatch!\nSent: {}\nRead: {}",
                    hex_string_as_words(chunk),
                    hex_string_as_words(&read_back),
                ));
            }
        }

        self.run_day(0, to_send.len().try_into().unwrap())
    }
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
                            hex_string_as_words(&receive_buf),
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

fn hex_string_as_words(data: &[u8]) -> String {
    data.chunks(4)
        .map(hex::encode)
        .reduce(|mut acc, item| {
            acc.push(' ');
            acc.push_str(&item);
            acc
        })
        .unwrap()
}
