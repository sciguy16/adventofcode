use serde::Deserialize;
use std::{fmt::Display, io::Write};

pub mod rust_codegen;
pub mod vhdl_codegen;

pub const PACKETDEFS: &str = include_str!("../../../../packetdefs.yaml");

pub type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

#[derive(Debug, Deserialize)]
pub struct PacketDefs {
    pub destinations: Vec<Destination>,
}

#[derive(Debug, Deserialize)]
pub struct Destination {
    pub id: u8,
    pub name: String,
    pub description: String,
    pub types: Vec<Type>,
}

#[derive(Debug, Deserialize)]
pub struct Type {
    pub id: u8,
    pub name: String,
    pub reply_to: Option<String>,
    pub payload: Vec<PayloadField>,
}

#[derive(Debug, Deserialize)]
pub struct PayloadField {
    pub name: String,
    pub width: u8,
}

#[derive(Copy, Clone, Default)]
struct Indent {
    depth: usize,
}

impl Display for Indent {
    fn fmt(&self, fmt: &mut std::fmt::Formatter) -> std::fmt::Result {
        let level = self.depth * 4;
        write!(fmt, "{:level$}", "")
    }
}

impl Indent {
    fn next(self) -> Self {
        Self {
            depth: self.depth + 1,
        }
    }
}

pub fn build_rust_codegen<W>(packetdefs: &str, codegen: &mut W) -> Result<()>
where
    W: Write,
{
    let defs = serde_norway::from_str::<PacketDefs>(packetdefs)?;
    for dest in defs.destinations {
        rust_codegen::write_destination(codegen, &dest)?;
        rust_codegen::write_destination_mod(codegen, &dest)?;
    }

    Ok(())
}

pub fn build_vhdl_codegen<W>(packetdefs: &str, codegen: &mut W) -> Result<()>
where
    W: Write,
{
    let defs = serde_norway::from_str::<PacketDefs>(packetdefs)?;
    writeln!(
        codegen,
        "library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

PACKAGE packet_types_pkg_hdr is"
    )?;
    for dest in defs.destinations {
        vhdl_codegen::write_destination(codegen, &dest)?;
    }
    writeln!(codegen, "END PACKAGE packet_types_pkg_hdr;")?;
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;
    use pretty_assertions::assert_eq;

    #[track_caller]
    fn do_test(yaml: &str, expected: &str) {
        let mut out = Vec::new();
        build_rust_codegen(yaml, &mut out).unwrap();
        let out = String::from_utf8(out).unwrap();
        assert_eq!(out, expected);
    }

    #[test]
    fn basic_destination_codegen() {
        const YAML: &str = "
destinations:
- id: 0
  name: top
  description: Top-level packets, e.g. ping/pong
  types:
  - id: 0
    name: ping
    payload:
    - name: data
      width: 32
";
        const EXPECTED: &str = include_str!("expected_rust_codegen.rs");
        do_test(YAML, EXPECTED);
    }
}
