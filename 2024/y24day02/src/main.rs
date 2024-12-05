#![feature(array_windows)]

use color_eyre::Result;
use std::{cmp::Ordering, str::FromStr};

struct DataType {
    reports: Vec<Vec<i32>>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut reports = Vec::new();

        for line in inp.lines() {
            let report = line
                .split_whitespace()
                .map(str::parse)
                .collect::<Result<Vec<i32>, _>>()?;
            reports.push(report);
        }

        Ok(Self { reports })
    }
}

/// Report is safe if both of the following are true:
/// *   The levels are either all increasing or all decreasing.
/// *   Any two adjacent levels differ by at least one and at most three.
fn is_safe(report: &[i32]) -> bool {
    let mut is_increasing = true;
    let mut is_decreasing = true;

    for [a, b] in report.array_windows() {
        match b.cmp(a) {
            Ordering::Less => {
                is_increasing = false;
            }
            Ordering::Greater => {
                is_decreasing = false;
            }
            Ordering::Equal => {
                return false;
            }
        }

        if !(is_increasing || is_decreasing) {
            return false;
        }

        let diff = (a.checked_sub(*b).unwrap()).abs();
        if diff > 3 {
            return false;
        }
    }
    true
}

/// Report is safe if both of the following are true:
/// *   The levels are either all increasing or all decreasing.
/// *   Any two adjacent levels differ by at least one and at most three.
fn is_safe_with_dampener(report: &[i32]) -> bool {
    if is_safe(report) || is_safe(&report[1..]) {
        return true;
    }

    for removal in 0..report.len() {
        let mut report = report.to_vec();
        report.remove(removal);
        if is_safe(&report) {
            return true;
        }
    }
    return false;

    #[expect(
        unreachable_code,
        reason = "clever solution should have worked :("
    )]
    let mut is_increasing = true;
    let mut is_decreasing = true;
    let mut has_dampened = false;

    let mut iter = report.iter();
    let mut prev = iter.next().unwrap();
    for next in iter {
        let mut try_dampen = false;

        match next.cmp(prev) {
            Ordering::Less => {
                if is_decreasing {
                    is_increasing = false;
                } else {
                    try_dampen = true;
                }
            }
            Ordering::Greater => {
                if is_increasing {
                    is_decreasing = false;
                } else {
                    try_dampen = true;
                }
            }
            Ordering::Equal => {
                try_dampen = true;
                // return false;
            }
        }

        if !(is_increasing || is_decreasing) {
            try_dampen = true;
            // return false;
        }

        let diff = (prev.checked_sub(*next).unwrap()).abs();
        if diff > 3 {
            try_dampen = true;
            // return false;
        }

        if try_dampen {
            if has_dampened {
                return false;
            }
            has_dampened = true;
        } else {
            prev = next;
        }
    }
    true
}

fn part_one(inp: &DataType) -> u64 {
    inp.reports.iter().filter(|report| is_safe(report)).count() as u64
}

fn part_two(inp: &DataType) -> u64 {
    inp.reports
        .iter()
        .filter(|report| is_safe_with_dampener(report))
        .count() as u64
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

    const TEST_DATA: &str = "\
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9\
";

    #[test]
    fn some_reports() {
        assert!(is_safe(&[1, 2, 3]));
        assert!(!is_safe(&[1, 2, 1]));
        assert!(is_safe_with_dampener(&[1, 4, 0, 7, 9]));
        assert!(is_safe_with_dampener(&[1, 3, 6, 7, 9, 4]));
        assert!(!is_safe_with_dampener(&[5, 4, 3, 5, 6, 7]));
        assert!(is_safe_with_dampener(&[5, 4, 3]));
        assert!(is_safe_with_dampener(&[5, 4, 3, 4]));
        assert!(is_safe_with_dampener(&[5, 4, 3, 4, 2]));
        assert!(!is_safe_with_dampener(&[5, 4, 3, 4, 4]));
        assert!(!is_safe_with_dampener(&[5, 4, 3, 4, 3]));
        assert!(is_safe_with_dampener(&[5, 4, 3, 4, 0]));
        assert!(!is_safe_with_dampener(&[5, 4, 3, 4, -1]));
        assert!(is_safe_with_dampener(&[42, 41, 38, 35, 33, 31, 28, 26]));
        assert!(!is_safe_with_dampener(&[57, 53, 52, 49, 48, 47, 43, 39]));
        assert!(!is_safe_with_dampener(&[88, 88, 87, 87, 85, 83, 80, 77]));
        assert!(is_safe_with_dampener(&[4, 5, 4, 3, 2]));
    }

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 2);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 4);
    }
}
