fn usage() -> String {
    format!("USAGE: {} <OUTPUT_FILE>", std::env::args().next().unwrap())
}

fn main() {
    let output_filename = std::env::args_os()
        .nth(1)
        .unwrap_or_else(|| panic!("{}", usage()));
    let mut file = std::fs::File::create(output_filename).unwrap();

    types::build_lib::build_vhdl_codegen(
        types::build_lib::PACKETDEFS,
        &mut file,
    )
    .unwrap();
}
