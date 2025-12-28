use clap::Parser;
use color_eyre::Result;
use serial_comms::{PortInfo, SerialHandler};

#[derive(Parser)]
struct Args {
    #[clap(help = "Serial port to open")]
    port: Option<String>,
}

fn main() -> Result<()> {
    color_eyre::install()?;
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

    println!("Discovered {usb_ports_count} USB serial ports");
    for port in available_ports {
        println!(
            "{}: {} ({})",
            port.name,
            port.info.product.as_deref().unwrap_or("unknown"),
            port.info.manufacturer.as_deref().unwrap_or("unknown"),
        );
    }

    Ok(())
}

fn do_run(port: &str) -> Result<()> {
    let mut port = SerialHandler::open(port)?;

    port.self_test()?;

    Ok(())
}
