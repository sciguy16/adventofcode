use color_eyre::Result;
use std::{str::FromStr, time::Instant};

const PUZZLE_INPUT: &str = include_str!("../input.txt");

struct DataType {
    inner: Vec<u64>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let inner = inp
            .trim()
            .chars()
            .map(|chr| chr.to_digit(10).unwrap().into())
            .collect();
        Ok(Self { inner })
    }
}

fn part_one(inp: &DataType) -> u64 {
    inp.inner
        .windows(2)
        .chain(std::iter::once(
            &[*inp.inner.first().unwrap(), *inp.inner.last().unwrap()][..],
        ))
        .filter_map(|window| (window[0] == window[1]).then_some(window[0]))
        .sum()
}

fn part_two(inp: &DataType) -> u64 {
    let mut sum = 0;
    for idx in 0..inp.inner.len() {
        if inp.inner[idx]
            == inp.inner[(idx + inp.inner.len() / 2) % inp.inner.len()]
        {
            sum += inp.inner[idx];
        }
    }
    sum
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

    #[test]
    fn test_part_1() {
        for (input, expected) in &[
            ("1122", 3_u64),
            ("1111", 4),
            ("1234", 0),
            ("91212129", 9),
            (PUZZLE_INPUT, 1177),
        ] {
            dbg!(input);
            let inp = input.parse().unwrap();
            let ans = part_one(&inp);
            assert_eq!(ans, *expected);
        }
    }

    #[test]
    fn test_part_2() {
        for (input, expected) in &[
            ("1212", 6_u64),
            ("1221", 0),
            ("123425", 4),
            ("123123", 12),
            ("12131415", 4),
            (PUZZLE_INPUT, 1060),
        ] {
            dbg!(input);
            let inp = input.parse().unwrap();
            let ans = part_two(&inp);
            assert_eq!(ans, *expected);
        }
    }
}
