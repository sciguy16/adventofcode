use clap::Parser;
use color_eyre::{Help, Result, SectionExt, eyre::eyre};
use serial_comms::{PortInfo, SerialHandler};
use std::{
    fmt::{Debug, Display},
    fs::File,
    path::{Path, PathBuf},
};

#[allow(unused)]
use tracing::{debug, error, info, trace, warn};

#[derive(Parser)]
struct Args {
    #[clap(help = "Serial port to open")]
    port: Option<String>,
}

fn main() -> Result<()> {
    color_eyre::install()?;
    serial_comms::init_tracing();
    let args = Args::parse();

    if let Some(port) = args.port {
        do_run(&port)?;
    } else {
        let ports = serial_comms::list_ports()?;
        print_ports(&ports)?;
        if ports.len() == 1 {
            do_run(&ports[0].name)?;
        }
    }
    Ok(())
}

fn print_ports(available_ports: &[PortInfo]) -> Result<()> {
    let usb_ports_count = available_ports.len();

    info!("Discovered {usb_ports_count} USB serial ports");
    for port in available_ports {
        info!(
            "{}: {} ({})",
            port.name,
            port.info.product.as_deref().unwrap_or("unknown"),
            port.info.manufacturer.as_deref().unwrap_or("unknown"),
        );
    }

    Ok(())
}

fn check_eq<Left, Right>(
    left: Left,
    right: Right,
    msg: impl Display,
) -> Result<()>
where
    Left: PartialEq<Right>,
    Left: Debug,
    Right: Debug,
{
    if left == right {
        Ok(())
    } else {
        Err(eyre!(
            "Result mismatch: {msg}\nLeft:  {left:?}\nRight: {right:?}"
        ))
    }
}

fn do_run(port: &str) -> Result<()> {
    let mut port = SerialHandler::open(port)?;

    port.self_test()?;

    //TODO move this bit into separate binary
    let hdl_dir = find_hdl_dir()?;

    let result = run_day_from_file(&mut port, &hdl_dir, 1, InputOrTest::Test)?;
    check_eq(result, "3", "Day 1 test")?;
    let result = run_day_from_file(&mut port, &hdl_dir, 1, InputOrTest::Input)?;
    check_eq(result, "995", "Day 1 test")?;

    Ok(())
}

#[derive(Copy, Clone, Debug)]
enum InputOrTest {
    Input,
    Test,
}

impl InputOrTest {
    fn filename(&self) -> &'static str {
        match self {
            Self::Input => "input.txt",
            Self::Test => "test.txt",
        }
    }
}

fn run_day_from_file(
    port: &mut SerialHandler,
    hdl_dir: &Path,
    day: u8,
    input_or_test: InputOrTest,
) -> Result<String> {
    let day_str = format!("day{day}");
    let input_path = hdl_dir
        .join("days")
        .join(day_str)
        .join(input_or_test.filename());
    let file = File::open(&input_path).map_err(|err| {
        eyre!("{err}").with_section(|| {
            input_path.display().to_string().header("Input file path: ")
        })
    })?;
    let result = port.run_day_from_reader(day, file)?;
    info!("Got day {day} {input_or_test:?} result: {result}");
    Ok(result)
}

fn find_hdl_dir() -> Result<PathBuf> {
    let dir = std::env::current_dir()?;
    let mut dir = dir.as_path();

    loop {
        let maybe_hdl_dir = dir.join("hdl");
        if maybe_hdl_dir.exists() && maybe_hdl_dir.is_dir() {
            break Ok(maybe_hdl_dir);
        }

        if let Some(parent) = dir.parent() {
            dir = parent;
        } else {
            break Err(eyre!("Failed to find hdl dir"));
        }
    }
}
