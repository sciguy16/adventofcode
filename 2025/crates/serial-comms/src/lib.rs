use color_eyre::{Result, eyre::eyre};
use mio_serial::{SerialPort, SerialPortType, UsbPortInfo};
use rand::Rng;
use std::{
    fmt::{Display, Write},
    io::Read,
    sync::mpsc,
    time::Duration,
};
use types::{
    Header, SerDe,
    codegen::top::{RunDayAck, Types},
};

#[allow(unused)]
use tracing::{debug, error, info, trace, warn};

const BAUD: u32 = 115200;
const RECV_TIMEOUT: Duration = Duration::from_secs(10);

const BRAM_WRITE_LEN_BYTES: usize = 128;
const WORD_SIZE_BYTES: usize = 4;
const BRAM_WRITE_LEN_WORDS: usize = BRAM_WRITE_LEN_BYTES / WORD_SIZE_BYTES;

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

#[track_caller]
fn check_eq_hex(
    (left, left_label): (impl AsRef<[u8]>, &'static str),
    (right, right_label): (impl AsRef<[u8]>, &'static str),
    msg: impl Display,
) -> Result<()> {
    fn inner(
        (left, left_label): (&[u8], &'static str),
        (right, right_label): (&[u8], &'static str),
        msg: String,
    ) -> Result<()> {
        if left == right {
            Ok(())
        } else {
            Err(eyre!(
                "Data mismatch - {msg}:\n\
                    {left_label}:\t{left_hex}\n\
                    {right_label}:\t{right_hex}",
                left_hex = hex_string_as_words(left),
                right_hex = hex_string_as_words(right),
            ))
        }
    }

    let left = left.as_ref();
    let right = right.as_ref();
    let msg = msg.to_string();
    inner((left, left_label), (right, right_label), msg)
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
        debug!("To send: {packet:02x?}");
        let mut buf = [0; 1024];
        let len = packet.serialise(&mut buf)?;
        let to_send = &buf[..len];
        trace!("Sending: {}", hex_string_as_words(to_send));
        self.port.write_all(to_send)?;

        let response = self.read_rx.recv_timeout(RECV_TIMEOUT)?;
        debug!("Received response: {response:02x?}");

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
                offset,
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

        let read_ram = Types::from(ReadRam { offset });
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

    pub fn run_day(
        &mut self,
        day: u8,
        data_len_bytes: u16,
    ) -> Result<RunDayAck> {
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
            Ok(response)
        } else {
            Err(eyre!("RunDay response mismatch"))
        }
    }

    pub fn self_test(&mut self) -> Result<()> {
        info!("1. Ping/pong exchange");
        self.ping_pong()?;

        info!("2. BRAM page write/read back");
        let mut rng = rand::rng();
        let data = rng.random();
        self.write_ram(0x00, data)?;
        let read_back = self.read_ram(0x00)?;
        check_eq_hex(
            (data, "data"),
            (read_back, "read_back"),
            "BRAM data readback",
        )?;

        info!("3. BRAM page boundary write/read back");
        self.test_bram_access_boundary()?;

        info!("4. Day zero (short)");
        let mut test_data = [0_u16; 10];
        rng.fill(&mut test_data);
        let sum = test_data.iter().copied().map(u32::from).sum::<u32>();
        debug!("Test data: {test_data:?}, sum={sum}");

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

            check_eq_hex(
                (chunk, "chunk"),
                (read_back, "read_back"),
                "BRAM data readback",
            )?;
        }

        let result = self.run_day(0, to_send.len().try_into().unwrap())?;
        let expected = sum.to_string();
        debug!("Test data: {test_data:?}, sum={sum}");
        debug!("Day result: {result:?}, expected {expected}");

        if result.part1 != sum || result.part2 != sum {
            return Err(eyre!("Incorrect result: {result:?} != {expected}"));
        }

        info!("5. Day zero (long)");

        info!("Self-test PASS");
        Ok(())
    }

    /// Test BRAM access by writing two consecutive "pages" and then reading
    /// back across the boundary to ensure consistency and correct operation
    fn test_bram_access_boundary(&mut self) -> Result<()> {
        let two_pages =
            std::array::from_fn::<_, { 2 * BRAM_WRITE_LEN_BYTES }, _>(|idx| {
                idx as u8
            });

        let mut buf = [0; BRAM_WRITE_LEN_BYTES];
        buf.copy_from_slice(&two_pages[..BRAM_WRITE_LEN_BYTES]);
        self.write_ram(0, buf)?;
        buf.copy_from_slice(&two_pages[BRAM_WRITE_LEN_BYTES..]);
        self.write_ram(BRAM_WRITE_LEN_WORDS.try_into()?, buf)?;
        let read_back =
            self.read_ram((BRAM_WRITE_LEN_WORDS / 2).try_into()?)?;
        let expected_page =
            std::array::from_fn::<_, BRAM_WRITE_LEN_BYTES, _>(|idx| {
                (idx + BRAM_WRITE_LEN_BYTES / 2) as u8
            });
        let res = check_eq_hex(
            (read_back, "read_back"),
            (expected_page, "expected_page"),
            "BRAM write boundary readback",
        );

        if res.is_err() {
            debug!("");
        }
        res?;

        Ok(())
    }

    pub fn run_day_from_reader<R: Read>(
        &mut self,
        day: u8,
        mut reader: R,
    ) -> Result<RunDayAck> {
        let mut buf = [0; 128];
        let mut offset = 0;
        let mut total_len = 0;
        while let Ok(len) = reader.read(&mut buf)
            && len > 0
        {
            self.write_ram(offset, buf)?;
            offset += 128 / 4;
            total_len += len;
        }

        self.run_day(day, total_len.try_into()?)
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
            trace!("Read 4 bytes: {:02x?}", &buf);

            receive_buf.extend_from_slice(&buf);
            state = match state {
                RxState::Header => {
                    header = Header::from(buf);
                    RxState::Payload
                }
                RxState::Payload => {
                    if receive_buf.len() == usize::from(header.len) + 4 {
                        debug!(
                            "Received packet: {}",
                            hex_string_as_words(&receive_buf),
                        );
                        match Types::deserialise(&receive_buf) {
                            Ok(parsed) => tx.send(parsed).unwrap(),
                            Err(err) => {
                                error!("Deserialisation failed: {err}")
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

pub fn init_tracing() {
    use tracing_subscriber::{EnvFilter, filter::LevelFilter};

    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::builder()
                .with_default_directive(LevelFilter::DEBUG.into())
                .from_env_lossy(),
        )
        .with_line_number(true)
        .init();
}
