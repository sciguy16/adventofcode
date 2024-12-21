use color_eyre::Result;
use std::{str::FromStr, time::Instant};

const PUZZLE_INPUT: &str = include_str!("../input.txt");

struct DataType {
    rows: Vec<Vec<u64>>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let rows = inp
            .lines()
            .map(|row| {
                row.split_whitespace()
                    .map(str::parse)
                    .collect::<Result<Vec<_>, _>>()
                    .unwrap()
            })
            .collect();
        Ok(Self { rows })
    }
}

fn part_one(inp: &DataType) -> u64 {
    inp.rows
        .iter()
        .map(|row| row.iter().max().unwrap() - row.iter().min().unwrap())
        .sum()
}

fn part_two(inp: &DataType) -> u64 {
    inp.rows
        .iter()
        .map(|row| {
            row.iter()
                .find_map(|value| {
                    for candidate in row {
                        if value != candidate && value % candidate == 0 {
                            return Some(value / candidate);
                        }
                    }
                    None
                })
                .unwrap()
        })
        .sum()
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

    const TEST_DATA: &str = "5 1 9 5
7 5 3
2 4 6 8";

    const TEST_DATA_2: &str = "5 9 2 8
9 4 7 3
3 8 6 5";

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 18);

        let inp = PUZZLE_INPUT.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 37923);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 9);

        let inp = PUZZLE_INPUT.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 263);
    }
}
