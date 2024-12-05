use color_eyre::Result;
use std::{collections::HashMap, str::FromStr};

#[derive(Clone)]
struct DataType {
    first: Vec<i32>,
    second: Vec<i32>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let nlines = inp.lines().count();
        let mut first = Vec::with_capacity(nlines);
        let mut second = Vec::with_capacity(nlines);

        for line in inp.lines() {
            let [a, b] = line
                .split_whitespace()
                .map(str::parse)
                .collect::<Result<Vec<i32>, _>>()?
                .try_into()
                .unwrap();
            first.push(a);
            second.push(b);
        }

        Ok(Self { first, second })
    }
}

fn part_one(inp: &mut DataType) -> i32 {
    assert_eq!(inp.first.len(), inp.second.len());
    inp.first.sort_unstable();
    inp.second.sort_unstable();

    inp.first
        .iter()
        .zip(&inp.second)
        .map(|(a, b)| (a - b).abs())
        .sum()
}

fn part_two(inp: &DataType) -> i32 {
    let mut right_counts: std::collections::HashMap<i32, i32> = HashMap::new();

    for ele in &inp.second {
        *right_counts.entry(*ele).or_default() += 1;
    }

    inp.first
        .iter()
        .map(|number| {
            number
                .checked_mul(
                    right_counts.get(number).copied().unwrap_or_default(),
                )
                .unwrap()
        })
        .sum()
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let mut data = input.parse()?;
    let ans = part_one(&mut data);
    println!("part one: {}", ans);
    let ans = part_two(&data);
    println!("part two: {}", ans);
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "\
3   4
4   3
2   5
1   3
3   9
3   3\
";

    #[test]
    fn test_part_1() {
        let mut inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&mut inp);
        assert_eq!(ans, 11);
    }

    #[test]
    fn test_part_2() {
        let mut inp = TEST_DATA.parse().unwrap();
        // sorts the lists
        part_one(&mut inp);
        let ans = part_two(&inp);
        assert_eq!(ans, 31);
    }
}
