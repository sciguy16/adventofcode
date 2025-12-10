use std::{fs::File, path::Path};

#[path = "src/build_lib/mod.rs"]
mod build_lib;

use build_lib::{build_rust_codegen, Result, PACKETDEFS};

fn main() -> Result<()> {
    println!("cargo::rerun-if-changed=../../packetdefs.yaml");

    let out_dir = std::env::var_os("OUT_DIR").unwrap();
    let out_dir = Path::new(&out_dir);
    let mut codegen = File::create(out_dir.join("codegen.rs")).unwrap();

    build_rust_codegen(PACKETDEFS, &mut codegen)
}
