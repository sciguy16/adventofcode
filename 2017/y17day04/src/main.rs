use color_eyre::Result;
use std::{collections::HashSet, str::FromStr, time::Instant};

const PUZZLE_INPUT: &str = include_str!("../input.txt");

struct DataType {
    passphrases: Vec<Passphrase>,
}

struct Passphrase {
    inner: Vec<String>,
}

impl Passphrase {
    fn is_valid(&self) -> bool {
        let hashset_version = self.inner.iter().collect::<HashSet<_>>();
        self.inner.len() == hashset_version.len()
    }

    fn is_valid_2(&self) -> bool {
        let hashset_version = self
            .inner
            .iter()
            .map(|phrase| {
                let mut v = phrase.chars().collect::<Vec<_>>();
                v.sort();
                v.into_iter().collect::<String>()
            })
            .collect::<HashSet<_>>();
        self.inner.len() == hashset_version.len()
    }
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let passphrases = inp
            .lines()
            .map(|line| Passphrase {
                inner: line.split_whitespace().map(String::from).collect(),
            })
            .collect();
        Ok(Self { passphrases })
    }
}

fn part_one(inp: &DataType) -> u64 {
    inp.passphrases
        .iter()
        .filter(|arg0| Passphrase::is_valid(arg0))
        .count() as u64
}

fn part_two(inp: &DataType) -> u64 {
    inp.passphrases
        .iter()
        .filter(|arg0| Passphrase::is_valid_2(arg0))
        .count() as u64
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

    const TEST_DATA: &str = "aa bb cc dd ee
aa bb cc dd aa
aa bb cc dd aaa";

    const TEST_DATA_2: &str = "abcde fghij
abcde xyz ecdab
a ab abc abd abf abj
iiii oiii ooii oooi oooo
oiii ioii iioi iiio";

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 2);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 3);
    }
}
