#![feature(array_windows)]

use color_eyre::Result;
use rustc_hash::{FxHashMap, FxHashSet};
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
    prev_digit: i8,
}

impl DeltaWrapper {
    fn new(initial: u64) -> Self {
        let secret = SecretNumber::new(initial);
        Self {
            secret,
            prev_digit: (initial % 10).try_into().unwrap(),
        }
    }
}

impl Iterator for DeltaWrapper {
    type Item = (i8, i8);
    fn next(&mut self) -> Option<Self::Item> {
        let next_digit: i8 = (self.secret.next()? % 10).try_into().unwrap();
        let delta = next_digit - self.prev_digit;
        self.prev_digit = next_digit;
        Some((next_digit, delta))
    }
}

fn get_2000th(seed: u64) -> u64 {
    SecretNumber::new(seed).nth(2000 - 1).unwrap()
}

fn part_one(inp: &DataType) -> u64 {
    inp.seeds.iter().copied().map(get_2000th).sum()
}

fn print_packed_window(window: u32) {
    let [a, b, c, d] = window.to_be_bytes();
    println!("{}, {}, {}, {}", a as i8, b as i8, c as i8, d as i8);
}

fn part_two(inp: &DataType, limit: usize) -> u64 {
    // transform the vendors into their delta sequences
    let mut vendor_deltas = Vec::with_capacity(inp.seeds.len());
    for &vendor_seed in &inp.seeds {
        let delta = DeltaWrapper::new(vendor_seed)
            .take(limit - 1)
            .collect::<Vec<_>>();
        vendor_deltas.push(delta);
    }

    // transform again into their packed windows
    let mut vendor_packed_windows = Vec::with_capacity(inp.seeds.len());
    for vendor in &vendor_deltas {
        let packed_windows = vendor
            .array_windows()
            .rev()
            .map(|&[(_, a), (_, b), (_, c), (price, d)]| {
                (
                    u32::from_be_bytes([a as u8, b as u8, c as u8, d as u8]),
                    price,
                )
            })
            .collect::<FxHashMap<_, _>>();
        vendor_packed_windows.push(packed_windows);
    }
    let seen_windows = vendor_packed_windows
        .iter()
        .flatten()
        // .inspect(|&(price, window)| {
        //     print_packed_window(*window);
        //     println!("{price}\n");
        // })
        .map(|(window, _price)| window)
        .collect::<FxHashSet<_>>();

    let mut running_max = 0;
    let mut best = 0;

    // get the price each vendor offers for each window and add them up,
    // tracking the largest
    for &window in seen_windows {
        // print_packed_window(best);

        let sum: u64 = vendor_packed_windows
            // .par_iter()
            .iter()
            .map(|vendor| *vendor.get(&window).unwrap_or(&0) as u64)
            // .inspect(|price| {
            //     println!("price: {price}");
            //     print_packed_window(window);
            // })
            .sum();
        if sum > running_max {
            // print_packed_window(window);
            // dbg!(sum);

            running_max = sum;
            best = window;
        }
    }

    print_packed_window(best);

    running_max
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let data = PUZZLE_INPUT.parse()?;

    let start = Instant::now();
    let ans = part_one(&data);
    let elapsed = start.elapsed();
    println!("part one: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    let start = Instant::now();
    let ans = part_two(&data, 2000);
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

    const TEST_DATA_2: &str = "1
2
3
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
        let expected = [
            (0, -3),
            (6, 6),
            (5, -1),
            (4, -1),
            (4, 0),
            (6, 2),
            (4, -2),
            (4, 0),
            (2, -2),
        ];
        for expected in expected {
            assert_eq!(deltas.next().unwrap(), expected);
        }
    }

    #[test]
    fn signed_cast() {
        assert_eq!((-124_i8) as u8, u8::from_be_bytes((-124_i8).to_be_bytes()));
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
    fn part_2_with_the_mini_test() {
        let inp = DataType { seeds: vec![123] };
        let ans = part_two(&inp, 10);
        assert_eq!(ans, 6);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_two(&inp, 2000);
        assert_eq!(ans, 23);
    }

    #[test]
    #[ignore]
    fn test_part_2_b() {
        let inp = PUZZLE_INPUT.parse().unwrap();
        let ans = part_two(&inp, 2000);
        assert_eq!(ans, 1863);
    }
}
