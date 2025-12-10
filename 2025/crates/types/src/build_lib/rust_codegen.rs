use super::{Destination, Indent, PayloadField, Type};
use std::io::Write;

const DERIVES: &str = "#[derive(Clone, Debug, PartialEq, Eq)]";

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

pub fn write_destination<W>(
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

pub fn write_destination_mod<W>(
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
