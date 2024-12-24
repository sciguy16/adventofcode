use color_eyre::Result;
use std::{
    collections::{BTreeMap, BTreeSet},
    str::FromStr,
    time::Instant,
};

type Signal = [u8; 3];

const PUZZLE_INPUT: &str = include_str!("../input.txt");

#[allow(unused)]
fn sig_to_str(sig: Signal) -> String {
    sig.into_iter().map(char::from).collect()
}

#[derive(Clone)]
struct DataType {
    signals: BTreeMap<Signal, bool>,
    expressions: Vec<Expression>,
    output_signals: Vec<Signal>,
}

#[derive(Copy, Clone, Debug)]
struct Expression {
    left: Signal,
    right: Signal,
    op: Operation,
    output: Signal,
}

#[derive(Copy, Clone, Debug)]
enum Operation {
    And,
    Or,
    Xor,
}

impl FromStr for Operation {
    type Err = ();

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        Ok(match inp {
            "AND" => Self::And,
            "XOR" => Self::Xor,
            "OR" => Self::Or,
            _ => panic!("{inp}"),
        })
    }
}

impl Operation {
    fn apply(self, left: bool, right: bool) -> bool {
        match self {
            Self::And => left && right,
            Self::Xor => left ^ right,
            Self::Or => left || right,
        }
    }
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        enum ParseState {
            Signals,
            Operations,
        }

        let mut state = ParseState::Signals;
        let mut signals = BTreeMap::new();
        let mut expressions = Vec::new();

        for line in inp.lines() {
            match state {
                ParseState::Signals => {
                    if line.is_empty() {
                        state = ParseState::Operations;
                        continue;
                    }

                    let mut iter = line.split(": ");
                    let reg = iter.next().unwrap();
                    let value = iter.next().unwrap();

                    let reg: Signal = reg.as_bytes().try_into()?;
                    let value = match value {
                        "1" => true,
                        "0" => false,
                        _ => panic!(),
                    };
                    signals.insert(reg, value);
                }
                ParseState::Operations => {
                    let mut iter = line.split_whitespace();
                    let left = iter.next().unwrap().as_bytes().try_into()?;
                    let op = iter.next().unwrap().parse().unwrap();
                    let right = iter.next().unwrap().as_bytes().try_into()?;
                    let _arrow = iter.next().unwrap();
                    let output = iter.next().unwrap().as_bytes().try_into()?;

                    expressions.push(Expression {
                        left,
                        right,
                        op,
                        output,
                    });
                }
            }
        }

        let output_signals = expressions
            .iter()
            .flat_map(|expr| [expr.left, expr.right, expr.output])
            .filter(|sig| sig[0] == b'z')
            .collect::<BTreeSet<Signal>>()
            .into_iter()
            .collect::<Vec<Signal>>();

        Ok(Self {
            signals,
            expressions,
            output_signals,
        })
    }
}

fn part_one(inp: &DataType) -> u64 {
    let mut inp = inp.clone();
    loop {
        // check whether output signals have been resolved
        if inp
            .output_signals
            .iter()
            .all(|sig| inp.signals.contains_key(sig))
        {
            // println!("Output signals complete");
            break;
        }

        for expr in &inp.expressions {
            if let (None, Some(left), Some(right)) = (
                inp.signals.get(&expr.output),
                inp.signals.get(&expr.left),
                inp.signals.get(&expr.right),
            ) {
                let out = expr.op.apply(*left, *right);
                inp.signals.insert(expr.output, out);
            }
        }
    }

    // build up the ouptut number
    let mut answer = 0_u64;
    for sig in inp.output_signals.iter().rev() {
        answer <<= 1;
        answer |= u64::from(*inp.signals.get(sig).unwrap());
    }
    // println!("{answer:b}");
    answer
}

fn part_two(_inp: &DataType) -> u64 {
    0
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let data = PUZZLE_INPUT.parse()?;

    let start = Instant::now();
    let ans = part_one(&data);
    let elapsed = start.elapsed();
    println!("part one: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    let start = Instant::now();
    let ans = part_two(&data);
    let elapsed = start.elapsed();
    println!("part two: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02";

    const TEST_DATA_2: &str = "x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj";

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 4);
    }

    #[test]
    fn test_part_1_b() {
        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 2024);
    }

    #[test]
    fn test_part_1_c() {
        let inp = PUZZLE_INPUT.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 53258032898766);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }
}
