#![feature(array_windows)]

use color_eyre::Result;
use std::str::FromStr;

struct DataType {
    inner: Vec<Vec<i64>>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let inner = inp
            .lines()
            .map(|line| {
                line.split_whitespace()
                    .map(str::parse)
                    .collect::<Result<Vec<_>, _>>()
                    .unwrap()
            })
            .collect();
        Ok(Self { inner })
    }
}

#[derive(Debug)]
struct Seq {
    differences: Vec<Vec<i64>>,
}

impl Seq {
    fn process(seq: &[i64]) -> Self {
        let mut differences = vec![seq.to_vec()];
        loop {
            let last = differences.last().unwrap();
            let next = last.array_windows().map(|[a, b]| b - a).collect();
            differences.push(next);
            if differences.last().unwrap().iter().all(|&n| n == 0) {
                break;
            }
        }

        Self { differences }
    }

    fn next(&self) -> i64 {
        let mut n = 0;
        for layer in self.differences.iter().rev() {
            n += layer.last().unwrap();
        }
        n
    }

    fn prev(&self) -> i64 {
        let mut n = 0;
        #[cfg(test)]
        println!("{self:?}");
        for layer in self.differences.iter().rev() {
            n = layer.first().unwrap() - n;
        }
        n
    }
}

fn part_one(inp: &DataType) -> i64 {
    let mut total = 0;
    for seq in &inp.inner {
        let seq = Seq::process(seq);
        total += seq.next();
    }
    total
}

fn part_two(inp: &DataType) -> i64 {
    let mut total = 0;
    for seq in &inp.inner {
        let seq = Seq::process(seq);
        total += seq.prev();
    }
    total
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

    const TEST_DATA: &str = r#"0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 114);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 2);
    }
}
