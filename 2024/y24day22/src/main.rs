use color_eyre::Result;
use std::{str::FromStr, time::Instant};

const PUZZLE_INPUT: &str = include_str!("../input.txt");

struct DataType {
    seeds: Vec<u64>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let seeds =
            inp.lines().map(str::parse).collect::<Result<Vec<_>, _>>()?;
        Ok(Self { seeds })
    }
}

struct SecretNumber {
    current: u64,
}

impl SecretNumber {
    fn new(initial: u64) -> Self {
        Self { current: initial }
    }
}

impl Iterator for SecretNumber {
    type Item = u64;
    fn next(&mut self) -> Option<Self::Item> {
        self.current ^= self.current << 6;
        self.current &= 0xff_ffff;
        self.current ^= self.current >> 5;
        self.current &= 0xff_ffff;
        self.current ^= self.current << 11;
        self.current &= 0xff_ffff;

        Some(self.current)
    }
}

struct DeltaWrapper {
    secret: SecretNumber,
    prev: i8,
}

impl DeltaWrapper {
    fn new(initial: u64) -> Self {
        let secret = SecretNumber::new(initial);
        Self {
            secret,
            prev: initial.try_into().unwrap(),
        }
    }
}

impl Iterator for DeltaWrapper {
    type Item = i8;
    fn next(&mut self) -> Option<Self::Item> {
        None
    }
}

fn get_2000th(seed: u64) -> u64 {
    SecretNumber::new(seed).nth(2000 - 1).unwrap()
}

fn part_one(inp: &DataType) -> u64 {
    inp.seeds.iter().copied().map(get_2000th).sum()
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

    const TEST_DATA: &str = "1
10
100
2024";

    #[test]
    fn secret() {
        let mut secret = SecretNumber::new(123);
        let expected = [
            15887950, 16495136, 527345, 704524, 1553684, 12683156, 11100544,
            12249484, 7753432, 5908254,
        ];
        for expected in expected {
            assert_eq!(secret.next().unwrap(), expected);
        }
    }

    #[test]
    fn prune() {
        assert_eq!(100000000 & 0xff_ffff, 16113920);
    }

    #[test]
    fn test_2000th() {
        for (seed, expected) in [
            (1, 8685429),
            (10, 4700978),
            (100, 15273692),
            (2024, 8667524),
        ] {
            assert_eq!(get_2000th(seed), expected, "{seed}");
        }
    }

    #[test]
    fn deltas() {
        let mut deltas = DeltaWrapper::new(123);
        let expected = [-3, 6, -1, -1, 0, 2, -2, 0, -2];
        for expected in expected {
            assert_eq!(deltas.next().unwrap(), expected);
        }
    }

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 37327623);
    }

    #[test]
    fn test_part_1_b() {
        let inp = PUZZLE_INPUT.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 16953639210);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }

    #[test]
    #[ignore]
    fn test_part_2_b() {
        let inp = PUZZLE_INPUT.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }
}
