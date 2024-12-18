use color_eyre::Result;
use std::{rc::Rc, str::FromStr};

const PUZZLE_INPUT: &str = include_str!("../input.txt");

const ADV: u8 = 0;
const BXL: u8 = 1;
const BST: u8 = 2;
const JNZ: u8 = 3;
const BXC: u8 = 4;
const OUT: u8 = 5;
const BDV: u8 = 6;
const CDV: u8 = 7;

#[derive(Clone)]
struct DataType {
    reg_a: i64,
    reg_b: i64,
    reg_c: i64,
    program: Vec<u8>,
    program_str: Rc<str>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        fn read_reg(reg: &str) -> i64 {
            reg.split(": ").nth(1).unwrap().parse().unwrap()
        }
        let mut lines = inp.lines();
        let reg_a = read_reg(lines.next().unwrap());
        let reg_b = read_reg(lines.next().unwrap());
        let reg_c = read_reg(lines.next().unwrap());

        assert!(lines.next().unwrap().is_empty());
        let program_str =
            lines.next().unwrap().strip_prefix("Program: ").unwrap();
        let program = program_str
            .split(',')
            .map(str::parse)
            .collect::<Result<Vec<u8>, _>>()
            .unwrap();

        Ok(Self {
            reg_a,
            reg_b,
            reg_c,
            program,
            program_str: program_str.to_string().into(),
        })
    }
}

impl std::fmt::Display for DataType {
    fn fmt(&self, fmt: &mut std::fmt::Formatter) -> std::fmt::Result {
        writeln!(
            fmt,
            "A: {}\nB: {}\nC:{}",
            self.reg_a, self.reg_b, self.reg_c
        )
    }
}

fn combo_operand(operand: i64, state: &DataType) -> i64 {
    match operand {
        0..=3 => operand,
        4 => state.reg_a,
        5 => state.reg_b,
        6 => state.reg_c,
        7 => unreachable!(),
        other => panic!("Bad combo operand: {other}"),
    }
}

fn part_one(state: &mut DataType) -> String {
    let mut pc = 0;
    let mut output = Vec::<String>::new();

    while pc < state.program.len() {
        // println!("pc={pc}\noutput={output:?}\n{state}");
        let instr = state.program[pc];
        let operand = i64::from(state.program[pc + 1]);
        pc += 2;

        match instr {
            ADV => {
                state.reg_a >>= combo_operand(operand, state);
            }
            BXL => {
                state.reg_b ^= operand;
            }
            BST => {
                state.reg_b = combo_operand(operand, state) & 0x07;
            }
            JNZ => {
                if state.reg_a != 0 {
                    pc = operand.try_into().unwrap();
                }
            }
            BXC => {
                state.reg_b ^= state.reg_c;
            }
            OUT => {
                output.push((combo_operand(operand, state) & 0x07).to_string());
            }
            BDV => {
                state.reg_b = state.reg_a >> combo_operand(operand, state);
            }
            CDV => {
                state.reg_c = state.reg_a >> combo_operand(operand, state);
            }
            other => panic!("Unexpected instruction `{other}`"),
        }
    }

    output.join(",")
}

// Program: 2,4,1,1,7,5,4,6,1,4,0,3,5,5,3,0
//
// 2,4, BST reg_b = reg_a & 0x07
// 1,1, BXL reg_b ^= 1
// 7,5, CDV reg_c = reg_a / (2 ** reg_b)  => reg_a >> 1
// 4,6, BXC reg_b ^= reg_c => b = (a >> 1) ^ 1
// 1,4, BXL reg_b ^= 0x04
// 0,3, ADV reg_a /= 2** 3  => reg_a >> 3
// 5,5, OUT out(reg_b & 0x07)
// 3,0, JNZ if A!=0
//
// For output = 2
// b = xxxxxx010
// b = xxxxxx010
// a >> 1 = xxxxxx011
fn part_two(inp: &DataType) -> i64 {
    let bits = inp.program.len() * 3;
    let start = 1 << (bits - 1);
    for candidate in start..start * 8 {
        let mut state = inp.clone();
        state.reg_a = candidate;
        let output = part_one(&mut state);
        println!("{candidate}: {output}");
        if *output == *inp.program_str {
            return candidate;
        }
    }
    panic!("no findy");
}

fn main() -> Result<()> {
    color_eyre::install()?;

    let data = PUZZLE_INPUT.parse::<DataType>()?;
    let ans = part_one(&mut data.clone());
    println!("part one: {}", ans);
    let ans = part_two(&data);
    println!("part two: {}", ans);
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0";

    #[test]
    fn test_part_1() {
        let mut inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&mut inp);
        assert_eq!(ans, "4,6,3,5,6,3,5,2,1,0");
    }

    #[test]
    fn test_part_1_real() {
        let mut inp = PUZZLE_INPUT.parse().unwrap();
        let ans = part_one(&mut inp);
        assert_eq!(ans, "4,6,1,4,2,1,3,1,6");
    }

    #[test]
    fn other_test_data_1() {
        let mut state = DataType {
            reg_a: 0,
            reg_b: 0,
            reg_c: 9,
            program: vec![2, 6],
            program_str: Default::default(),
        };
        part_one(&mut state);
    }

    const TEST_DATA_2: &str = "Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0";

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 117440);
    }

    #[test]
    fn try_some_values() {
        let data = PUZZLE_INPUT.parse::<DataType>().unwrap();
        for value in [
            0, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000,
            1000000000,
        ] {
            let mut state = data.clone();
            state.reg_a = value;
            let output = part_one(&mut state);
            println!("{value}: {output}");
        }
        // panic!();
    }
}
