use super::{Destination, Indent};
use std::io::Write;

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
    let indent = Indent::default().next();
    writeln!(codegen, "{indent}-- {description}")?;
    writeln!(
        codegen,
        "{indent}constant c_DESTINATION_{name}: \
            std_logic_vector(7 downto 0) := x\"{id:02x}\";",
    )
}
