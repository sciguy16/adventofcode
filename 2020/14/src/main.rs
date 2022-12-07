use eyre::{eyre, Result};
use itertools::Itertools;
use std::collections::BTreeMap;
use std::fmt::{self, Display};

/// Mask looks like "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
/// When applied to a number, it leaves each bit corresponding to an X
/// intact, but overwrites the specified ones and zeroes.
///
/// What an implementation looks like is two separate bitmasks:
/// * `and_mask`: 1 in each position apart from the zeroes in the original
///      mask, with the effect that `input & and_mask` clears the bits
///      which should be set to zero
/// * `or_mask`: 1 in each position marked by a 1 in the original mask,
///      with the effect that `input | or_mask` sets the bits which should
///      be overriden by 1
///
/// Mask2 looks like:
///
/// * If the bitmask bit is 0, the corresponding memory address bit is
///      unchanged.
/// * If the bitmask bit is 1, the corresponding memory address bit is
///      overwritten with 1.
/// * If the bitmask bit is X, the corresponding memory address bit is
///      floating.
#[derive(Copy, Clone, Debug, Default)]
struct Mask {
    and_mask: u64,
    or_mask: u64,
    floating: u64,
    overwrite: u64,
}

impl Mask {
    fn apply(&self, num: u64) -> u64 {
        (num & self.and_mask) | self.or_mask
    }

    fn apply_addr(&self, addr: u64) -> Vec<u64> {
        // Overwrite
        let addr = addr | self.overwrite;
        // Clear the floating bits
        let addr = addr & (!self.floating);

        // Calculate indices of all set bits of FLOATING
        let mut bit_indices = Vec::<u8>::with_capacity(
            self.floating.count_ones().try_into().unwrap(),
        );
        let mut floating = self.floating;
        let floating_backup = floating;
        for idx in 0..64u8 {
            if floating & 0x01 == 1 {
                // rightmost bit set
                bit_indices.push(idx);
            }
            floating = floating.rotate_right(1);
        }
        // hopefully FLOATING has rotated back to where it started...
        assert_eq!(floating_backup, floating);

        #[cfg(test)]
        {
            println!("mask: {:0b}", self.floating);
            println!("indices: {bit_indices:?}");
            println!("addr: {addr:064b}\n");
        }

        #[allow(clippy::let_and_return)]
        bit_indices
            .iter()
            .powerset()
            .map(|indices| {
                #[cfg(test)]
                println!("subset: {indices:?}");
                let msk = indices.iter().fold(0, |acc, idx| acc | (1 << **idx));
                #[cfg(test)]
                println!("msk:  {msk:064b}");
                let ret = addr | msk;
                #[cfg(test)]
                println!("addr: {ret:064b}\n");
                ret
            })
            .collect::<Vec<_>>()
    }
}

impl TryFrom<&str> for Mask {
    type Error = eyre::Error;
    fn try_from(inp: &str) -> Result<Self, Self::Error> {
        // and_mask is a u64 with ones everywhere that the input does not
        // have a zero. This is computed reasonably simply by creating
        // a u64 with ones everywhere that the mask has zeroes, and then
        // applying a bitwise negation:
        let and_mask: u64 = {
            let msk: String = inp
                .chars()
                .map(|c| match c {
                    '1' | 'X' => Ok('0'),
                    '0' => Ok('1'),
                    _ => Err(eyre!("Invalid character: {}", c)),
                })
                .collect::<Result<Vec<char>>>()?
                .iter()
                .collect();
            let msk = u64::from_str_radix(&msk, 2)?; // interpret as u64
            !msk // bitwise negation
        };

        // or_mask is ones everyhere the original mask is one, otherwise
        // zero
        let or_mask: u64 = {
            let msk: String = inp
                .chars()
                .map(|c| match c {
                    '1' => Ok('1'),
                    'X' | '0' => Ok('0'),
                    _ => Err(eyre!("Invalid character {}", c)),
                })
                .collect::<Result<Vec<char>>>()?
                .iter()
                .collect();
            u64::from_str_radix(&msk, 2)?
        };

        let floating: u64 = {
            let msk: String = inp
                .chars()
                .map(|c| match c {
                    'X' => Ok('1'),
                    '0' | '1' => Ok('0'),
                    _ => Err(eyre!("Invalid character: {}", c)),
                })
                .collect::<Result<Vec<char>>>()?
                .iter()
                .collect();
            u64::from_str_radix(&msk, 2)?
        };

        // or_mask is ones everyhere the original mask is one, otherwise
        // zero
        let overwrite: u64 = {
            let msk: String = inp
                .chars()
                .map(|c| match c {
                    '1' => Ok('1'),
                    'X' | '0' => Ok('0'),
                    _ => Err(eyre!("Invalid character {}", c)),
                })
                .collect::<Result<Vec<char>>>()?
                .iter()
                .collect();
            u64::from_str_radix(&msk, 2)?
        };

        Ok(Self {
            and_mask,
            or_mask,
            floating,
            overwrite,
        })
    }
}

impl Display for Mask {
    fn fmt(&self, fmt: &mut fmt::Formatter) -> fmt::Result {
        writeln!(
            fmt,
            "and: {:064b}\nor:  {:064b}",
            self.and_mask, self.or_mask
        )?;
        write!(
            fmt,
            "floating:  {:064b}\noverwrite: {:064b}",
            self.floating, self.overwrite
        )
    }
}

#[derive(Clone, Debug)]
enum Instruction {
    Mask(Mask),
    Set { addr: u64, val: u64 },
}

fn parse_instructions(prog: &str) -> Result<Vec<Instruction>> {
    prog.lines()
        .filter(|line| line.len() > 2)
        .map(|line| {
            if let Some(msk) = line.strip_prefix("mask = ") {
                Mask::try_from(msk).map(Instruction::Mask)
            } else if let Some(set) = line.strip_prefix("mem[") {
                let mut spliterator = set.split("] = ");
                let addr: u64 = spliterator
                    .next()
                    .ok_or_else(|| eyre!("Invalid line (addr): `{}`", line))?
                    .parse()?;
                let val: u64 = spliterator
                    .next()
                    .ok_or_else(|| eyre!("Invalid line (val): `{}`", line))?
                    .parse()?;
                Ok(Instruction::Set { addr, val })
            } else {
                Err(eyre!("Invalid line (no prefix matched): `{}`", line))
            }
        })
        .collect::<Vec<Result<Instruction>>>()
        .into_iter()
        .collect()
}

struct Memory {
    inner: BTreeMap<u64, u64>,
}

impl Memory {
    pub fn new() -> Self {
        Self {
            inner: BTreeMap::new(),
        }
    }

    pub fn set(&mut self, addr: u64, val: u64) {
        self.inner.insert(addr, val);
    }

    pub fn sum(&self) -> u128 {
        self.inner.values().fold(0, |a, b| a + *b as u128)
    }
}

fn part_one(prog: &[Instruction]) -> Result<u128> {
    let mut mem = Memory::new();
    let mut mask = Option::<Mask>::None;
    for instr in prog {
        match instr {
            Instruction::Mask(msk) => {
                mask.replace(*msk);
            }
            Instruction::Set { addr, val } => {
                let val =
                    mask.ok_or_else(|| eyre!("No mask set!"))?.apply(*val);
                mem.set(*addr, val);
            }
        }
    }

    Ok(mem.sum())
}

fn part_two(prog: &[Instruction]) -> Result<u128> {
    // FOR EACH INSTRUCTION:
    // * if MASK then update CURRENT_MASK
    // * if SET then:
    //   - apply mask to address
    //   - count FLOATING bits
    //   - add VALUE * 2^(FLOATING COUNTT) to RESULT
    //   - add 2^(FLOATING COUNT) to MEM_COUNTER to track how many memory
    //         addresses are actually used
    //   - possible future expansion: record memory address in BTreeSet
    //         or BTreeMap
    let mut mask = Option::<Mask>::None;
    let mut seen = BTreeMap::<u64, u64>::new();
    for instr in prog {
        match instr {
            Instruction::Mask(msk) => {
                mask.replace(*msk);
            }
            Instruction::Set { addr, val } => {
                let mask = mask.ok_or_else(|| eyre!("No mask set!"))?;

                let addresses = mask.apply_addr(*addr);
                for addr in &addresses {
                    seen.insert(*addr, *val);
                }
            }
        }
    }
    println!("mem counter: {}", seen.len());
    Ok(seen.values().map(|v| *v as u128).sum())
}

fn main() {
    let input = include_str!("../input.txt");
    let prog = parse_instructions(input).unwrap();
    let result = part_one(&prog).unwrap();
    println!("Part one: {result}");

    let result = part_two(&prog).unwrap();
    println!("Part two: {result}");
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn parse_mask() {
        let inp = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X";
        let mask = Mask::try_from(inp).unwrap();
        println!("mask:                            {inp}\n{mask}");
        assert_eq!(
            mask.and_mask,
            0b1111111111111111111111111111111111111111111111111111111111111101
        );
        assert_eq!(
            mask.or_mask,
            0b0000000000000000000000000000000000000000000000000000000001000000
        );
    }

    #[test]
    fn masks() {
        let mask =
            Mask::try_from("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X").unwrap();
        assert_eq!(mask.apply(11), 73);
        assert_eq!(mask.apply(101), 101);
        assert_eq!(mask.apply(0), 64);
    }

    #[test]
    fn execute_program() {
        let prog = r#"
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"#;
        let instructions = parse_instructions(prog).unwrap();
        let result = part_one(&instructions).unwrap();
        assert_eq!(result, 165);
    }

    #[test]
    fn parse_mask2() {
        let mask = "000000000000000000000000000000X1001X";
        println!("mask:                                  {mask}");
        let expected = Mask {
            floating: 0b000000000000000000000000000000100001,
            overwrite: 0b000000000000000000000000000000010010,
            ..Default::default()
        };
        let mask = Mask::try_from(mask).unwrap();
        println!("Calculated:\n{mask}\nexpected:\n{expected}");
        assert_eq!(mask.floating, expected.floating);
        assert_eq!(mask.overwrite, expected.overwrite);
    }

    #[test]
    fn apply_mask2() {
        let addr: u64 = 0b000000000000000000000000000000011010;
        let mask = "00000000000000000000000000000000X0XX";
        let mask = Mask::try_from(mask).unwrap();
        println!("mask:\n{mask}\n");
        let mut expected: Vec<u64> = vec![
            0b000000000000000000000000000000010000, // (decimal 16)
            0b000000000000000000000000000000010001, // (decimal 17)
            0b000000000000000000000000000000010010, // (decimal 18)
            0b000000000000000000000000000000010011, // (decimal 19)
            0b000000000000000000000000000000011000, // (decimal 24)
            0b000000000000000000000000000000011001, // (decimal 25)
            0b000000000000000000000000000000011010, // (decimal 26)
            0b000000000000000000000000000000011011, // (decimal 27)
        ];
        expected.sort();
        let expected = expected;

        let mut addresses = mask.apply_addr(addr);
        addresses.sort();

        println!("{addresses:?}");
        assert_eq!(addresses, expected);
    }

    #[test]
    fn execute_program2() {
        let prog = r#"mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1"#;
        let instructions = parse_instructions(prog).unwrap();
        let result = part_two(&instructions).unwrap();
        assert_eq!(result, 208);
    }
}
