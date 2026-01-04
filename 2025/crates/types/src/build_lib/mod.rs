use askama::Template;
use serde::Deserialize;
use std::{
    fmt::{Display, Write as _},
    io::Write,
};

mod vhdl_codegen;

mod filters {
    pub fn struct_name(
        name: &str,
        _: &dyn askama::Values,
    ) -> askama::Result<String> {
        let mut out = String::new();
        let mut next_upcase = true;
        for chr in name.chars() {
            if next_upcase {
                out.push(chr.to_ascii_uppercase());
                next_upcase = false;
            } else if chr == '_' {
                next_upcase = true;
            } else {
                out.push(chr);
            }
        }
        Ok(out)
    }
}

pub const PACKETDEFS: &str = include_str!("../../../../packetdefs.yaml");

pub type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct PacketDefs {
    pub destinations: Vec<Destination>,
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct Destination {
    pub id: u8,
    pub name: String,
    pub description: String,
    pub types: Vec<Type>,
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct Type {
    pub id: u8,
    pub name: String,
    pub reply_to: Option<String>,
    pub payload: Vec<PayloadField>,
}

impl Type {
    pub fn reply_to(&self) -> String {
        // if let Some(reply_to) = &self.reply_to
        format!("{:?}", self.reply_to)
    }
}

#[derive(Debug, Deserialize)]
pub struct PayloadField {
    pub name: String,
    pub width_bytes: u8,
}

impl PayloadField {
    pub fn ty(&self) -> &'static str {
        match self.width_bytes {
            1 => "u8",
            2 => "u16",
            4 => "u32",
            128 => "[u8; 128]",
            other => panic!("Bad width `{other}`"),
        }
    }

    pub fn serialise_fn(&self, base: &str) -> String {
        let field = &self.name;
        match self.width_bytes {
            1 | 2 | 4 => format!("&{base}.{field}.to_be_bytes()"),
            128 => format!("&{base}.{field}"),
            other => panic!("Bad width `{other}`"),
        }
    }

    pub fn is_slice(&self) -> bool {
        self.width_bytes > 4
    }

    pub fn deserialise_fn(&self, base: &str, indent: usize) -> String {
        let indent = Indent { depth: indent };

        let Self { name, width_bytes } = &self;
        let mut out = String::new();
        writeln!(&mut out, "let mut {name} = [0; {width_bytes}];").unwrap();
        writeln!(&mut out, "{indent}{base}.read_exact(&mut {name})?;").unwrap();
        if matches!(self.width_bytes, 1 | 2 | 4) {
            let ty = self.ty();
            writeln!(
                &mut out,
                "{indent}let {name} = {ty}::from_be_bytes({name});"
            )
            .unwrap();
        }

        out
    }
}

#[derive(Template)]
#[template(path = "rust_codegen_template.rs", escape = "none")]
struct CodegenTemplate<'defs> {
    defs: &'defs PacketDefs,
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

    let templ = CodegenTemplate { defs: &defs };
    templ.write_into(codegen).map_err(Into::into)
}

pub fn build_vhdl_codegen<W>(packetdefs: &str, codegen: &mut W) -> Result<()>
where
    W: Write,
{
    let defs = serde_norway::from_str::<PacketDefs>(packetdefs)?;
    vhdl_codegen::write_header(codegen)?;
    write!(codegen, "PACKAGE packet_types_pkg_hdr is")?;
    let indent = Indent::default().next();
    writeln!(codegen, "{}", vhdl_codegen::MAIN_TYPES)?;
    writeln!(
        codegen,
        "{indent}constant C_NUM_DESTINATIONS: natural := {};\n",
        defs.destinations.len(),
    )?;
    for dest in defs.destinations {
        vhdl_codegen::write_destination(codegen, &dest, indent)?;
        vhdl_codegen::write_types(codegen, &dest, indent)?;
    }
    writeln!(codegen, "END PACKAGE packet_types_pkg_hdr;")?;
    Ok(())
}

pub fn hex_string_as_words(data: &[u8]) -> String {
    data.chunks(4)
        .map(hex::encode)
        .reduce(|mut acc, item| {
            acc.push(' ');
            acc.push_str(&item);
            acc
        })
        .unwrap()
}

#[cfg(test)]
mod test {
    use super::*;
    use pretty_assertions::assert_eq;

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
      width_bytes: 4
";

    #[track_caller]
    fn do_test<F>(yaml: &str, func: F) -> Result<String>
    where
        F: FnOnce(&str, &mut Vec<u8>) -> Result<()>,
    {
        let mut out = Vec::new();
        func(yaml, &mut out).unwrap();
        Ok(String::from_utf8(out).unwrap())
    }

    #[test]
    fn basic_rust_codegen() {
        let out = do_test(YAML, build_rust_codegen).unwrap();
        insta::assert_snapshot!(out);
    }

    #[test]
    fn basic_vhdl_codegen() {
        const EXPECTED: &str = include_str!("expected_vhdl_codegen.vhd");
        let out = do_test(YAML, build_vhdl_codegen).unwrap();
        assert_eq!(out, EXPECTED);
    }
}
