use color_eyre::{eyre::eyre, Report, Result};
use std::collections::HashMap;
use std::fmt::{self, Debug, Formatter};
use std::str::FromStr;

const AAA: Node = Node([b'A'; 3]);
const ZZZ: Node = Node([b'Z'; 3]);

#[derive(Debug)]
struct DataType {
    instructions: Vec<Instruction>,
    network: HashMap<Node, (Node, Node)>,
}

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
enum Instruction {
    Left,
    Right,
}

impl TryFrom<char> for Instruction {
    type Error = Report;

    fn try_from(value: char) -> std::result::Result<Self, Self::Error> {
        match value {
            'L' => Ok(Self::Left),
            'R' => Ok(Self::Right),
            c => Err(eyre!("{c}")),
        }
    }
}

#[derive(Copy, Clone, Hash, PartialEq, Eq)]
struct Node([u8; 3]);

impl Debug for Node {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        write!(
            fmt,
            "{}{}{}",
            self.0[0] as char, self.0[1] as char, self.0[2] as char,
        )
    }
}

impl From<&[u8]> for Node {
    fn from(n: &[u8]) -> Self {
        Self(n.try_into().unwrap())
    }
}

impl Node {
    const fn ends(&self, ch: u8) -> bool {
        self.0[2] == ch
    }

    const fn end_a(&self) -> bool {
        self.ends(b'A')
    }

    const fn end_z(&self) -> bool {
        self.ends(b'Z')
    }
}

impl FromStr for DataType {
    type Err = Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut lines = inp.lines();
        let instructions = lines
            .next()
            .unwrap()
            .chars()
            .map(Instruction::try_from)
            .collect::<Result<Vec<_>, _>>()?;

        lines.next().unwrap();

        let network = lines
            .map(|line| {
                let line = line.as_bytes();
                let n = Node::from(&line[..3]);
                let l = Node::from(&line[7..10]);
                let r = Node::from(&line[12..15]);
                (n, (l, r))
            })
            .collect();

        Ok(Self {
            instructions,
            network,
        })
    }
}

fn part_one(inp: &DataType) -> u64 {
    let mut current = AAA;
    for (idx, instr) in inp.instructions.iter().cycle().enumerate() {
        #[cfg(test)]
        dbg!(current);

        if current == ZZZ {
            return idx.try_into().unwrap();
        }

        let target = inp.network.get(&current).unwrap();
        current = match instr {
            Instruction::Left => target.0,
            Instruction::Right => target.1,
        };
    }
    unreachable!()
}

fn part_two(inp: &DataType) -> u64 {
    let mut current = inp
        .network
        .keys()
        .copied()
        .filter(Node::end_a)
        .collect::<Vec<_>>();
    let mut cycle_lengths = vec![0; current.len()];

    for (idx, instr) in inp.instructions.iter().cycle().enumerate() {
        #[cfg(test)]
        dbg!(&current);

        if cycle_lengths.iter().all(|&l| l > 0) {
            break;
        }

        for (cur, cyc) in current.iter().zip(cycle_lengths.iter_mut()) {
            if cur.end_z() && *cyc == 0 {
                *cyc = idx;
            }
        }

        for cur in current.iter_mut() {
            let target = inp.network.get(cur).unwrap();
            *cur = match instr {
                Instruction::Left => target.0,
                Instruction::Right => target.1,
            };
        }
    }
    dbg!(&cycle_lengths);
    cycle_lengths
        .iter()
        .copied()
        .map(|e| e as u64)
        .reduce(num_integer::lcm)
        .unwrap()
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data = input.parse()?;
    let ans = part_one(&data);
    println!("part one: {}", ans);
    let ans = part_two(&data);
    println!("part two: {}", ans);
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &[(&str, u64)] = &[
        (
            r#"RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)"#,
            2,
        ),
        (
            "LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)",
            6,
        ),
    ];

    const TEST_DATA_FOR_PART_2: &str = "LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)";

    #[test]
    fn test_part_1() {
        for (case, expected) in TEST_DATA {
            let inp = case.parse().unwrap();
            let ans = part_one(&inp);
            assert_eq!(ans, *expected);
        }
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA_FOR_PART_2.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 6);
    }
}
