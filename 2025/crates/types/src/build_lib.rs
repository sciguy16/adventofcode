use serde::Deserialize;
use std::{fmt::Display, io::Write};

pub const PACKETDEFS: &str = include_str!("../../../packetdefs.yaml");
const DERIVES: &str = "#[derive(Clone, Debug, PartialEq, Eq)]";

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
        write_destination(codegen, &dest)?;
        write_destination_mod(codegen, &dest)?;
    }

    Ok(())
}

fn fmt_struct_name(name: &str) -> String {
    let mut chars = name.chars();
    chars
        .next()
        .as_ref()
        .map(char::to_ascii_uppercase)
        .into_iter()
        .chain(chars)
        .collect()
}

fn write_destination<W>(
    codegen: &mut W,
    Destination {
        id,
        name,
        description,
        types: _,
    }: &Destination,
) -> std::io::Result<()>
where
    W: Write,
{
    let struct_name = fmt_struct_name(name);
    writeln!(
        codegen,
        "\
#[doc = \"{description}\"]
{DERIVES}
pub struct {struct_name} {{}}
impl crate::Destination for {struct_name} {{
    const ID: u8 = {id};
    const NAME: &'static str = \"{name}\";
    type Types = {name}::Types;
}}",
    )
}

fn write_destination_mod<W>(
    codegen: &mut W,
    Destination {
        id: _,
        name,
        description: _,
        types,
    }: &Destination,
) -> std::io::Result<()>
where
    W: Write,
{
    writeln!(codegen, "pub mod {name} {{")?;

    let indent = Indent::default().next();
    for ty in types {
        write_type(codegen, ty, indent)?;
        write_serde_impl(codegen, ty, indent)?;
    }

    writeln!(codegen, "{indent}pub enum Types {{")?;
    for ty in types {
        let indent = indent.next();
        let struct_name = fmt_struct_name(&ty.name);
        writeln!(codegen, "{indent}{struct_name}({struct_name}),")?;
    }
    writeln!(
        codegen,
        "\
{indent}}}
}}",
    )
}

fn write_type<W>(
    codegen: &mut W,
    Type {
        id,
        name,
        payload,
        reply_to,
    }: &Type,
    indent: Indent,
) -> std::io::Result<()>
where
    W: Write,
{
    let struct_name = fmt_struct_name(name);
    writeln!(codegen, "{indent}{DERIVES}")?;
    writeln!(codegen, "{indent}pub struct {struct_name} {{")?;

    for PayloadField { name, width } in payload {
        write!(codegen, "        pub {name}: u{width},")?;
    }

    writeln!(
        codegen,
        "
    }}

    impl crate::Type for {struct_name} {{
        const ID: u8 = {id};
        const NAME: &str = \"{name}\";
        const REPLY_TO: Option<&str> = {reply_to:?};
    }}
",
    )
}

fn write_serde_impl<W>(
    codegen: &mut W,
    ty: &Type,
    indent: Indent,
) -> std::io::Result<()>
where
    W: Write,
{
    let name = fmt_struct_name(&ty.name);
    writeln!(codegen, "{indent}impl crate::SerDe for {name} {{")?;
    write_serialise_fn(codegen, ty, indent.next())?;
    write_deserialise_fn(codegen, ty, indent.next())?;
    writeln!(
        codegen,
        "{indent}}}
"
    )
}

fn write_serialise_fn<W>(
    codegen: &mut W,
    Type {
        id: _,
        name: _,
        payload,
        reply_to: _,
    }: &Type,
    indent: Indent,
) -> std::io::Result<()>
where
    W: Write,
{
    let indent_next = indent.next();
    writeln!(
        codegen,
        "\
{indent}fn serialise(&self, buf: &mut [u8]) -> crate::Result<usize> {{
{indent_next}use std::io::Write;
{indent_next}let mut cur = std::io::Cursor::new(buf);",
    )?;

    for PayloadField { name, width: _ } in payload {
        let indent = indent_next;
        writeln!(
            codegen,
            "{indent}cur.write_all(&self.{name}.to_be_bytes())?;",
        )?;
    }

    writeln!(
        codegen,
        "
{indent_next}Ok(cur.position().try_into()?)
{indent}}}
"
    )
}

fn write_deserialise_fn<W>(
    codegen: &mut W,
    Type {
        id: _,
        name: _,
        payload,
        reply_to: _,
    }: &Type,
    indent: Indent,
) -> std::io::Result<()>
where
    W: Write,
{
    let indent_next = indent.next();
    writeln!(
        codegen,
        "\
{indent}fn deserialise(buf: &[u8]) -> crate::Result<Self> {{
{indent_next}use std::io::Read;
{indent_next}let mut cur = std::io::Cursor::new(buf);",
    )?;

    for PayloadField { name, width } in payload {
        let indent = indent_next;
        writeln!(
            codegen,
            "\
{indent}let mut {name} = 0_u{width}.to_be_bytes();
{indent}cur.read_exact(&mut {name})?;
{indent}let {name} = u{width}::from_be_bytes({name});",
        )?;
    }

    if let [PayloadField { name, .. }] = &payload[..] {
        writeln!(codegen, "{indent_next}Ok(Self {{ {name} }})")?;
    } else {
        writeln!(codegen, "{indent_next}Ok(Self {{")?;
        for PayloadField { name, width: _ } in payload {
            let indent = indent_next.next();
            writeln!(codegen, "{indent}{name},")?;
        }
        writeln!(codegen, "{indent_next}}})")?;
    }
    writeln!(codegen, "{indent}}}")
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
        const EXPECTED: &str = include_str!("build_lib_rs_expected_codegen.rs");
        do_test(YAML, EXPECTED);
    }
}
