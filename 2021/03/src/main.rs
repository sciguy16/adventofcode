use std::cmp::Ordering;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

#[derive(Debug)]
struct ReportEntry<const N: usize>([bool; N]);

impl<const N: usize> FromStr for ReportEntry<N> {
    type Err = Box<dyn std::error::Error>;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let inner = s
            .chars()
            .map_while(|chr| match chr {
                '0' => Some(false),
                '1' => Some(true),
                _ => None,
            })
            .collect::<Vec<bool>>()
            .try_into()
            .unwrap();
        Ok(ReportEntry(inner))
    }
}

fn part_one<const N: usize>(report: &[ReportEntry<N>]) -> usize {
    let mut counts = [0_isize; N];
    for entry in report {
        for (cnt, bit) in counts.iter_mut().zip(entry.0.iter()) {
            *cnt += if *bit { 1 } else { -1 };
        }
    }

    println!("counts: {:?}", counts);
    let gamma: usize = {
        let mut num: usize = 0;
        for bit in counts {
            num <<= 1;
            if bit > 0 {
                num |= 1;
            }
        }
        num
    };

    let mask: usize = {
        let mut mask = 0;
        for _ in counts {
            mask <<= 1;
            mask |= 1;
        }
        mask
    };

    let epsilon = !gamma & mask;

    println!("gamma: {}, epsilon: {}", gamma, epsilon);

    gamma * epsilon
}

struct Row(Vec<bool>);

impl FromStr for Row {
    type Err = Box<dyn std::error::Error>;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let inner = s
            .chars()
            .map_while(|chr| match chr {
                '0' => Some(false),
                '1' => Some(true),
                _ => None,
            })
            .collect::<Vec<bool>>();
        Ok(Row(inner))
    }
}

#[derive(Debug)]
struct ReportTransposed {
    cols: Vec<Vec<bool>>,
}

impl FromStr for ReportTransposed {
    type Err = Box<dyn std::error::Error>;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut cols = Vec::new();
        let mut first = true;
        for lines in s.lines() {
            let row: Row = lines.parse()?;
            if first {
                // fill the cols with enough empty Vecs
                for _ in &row.0 {
                    cols.push(Vec::new());
                }
                first = false;
            }
            for (col, entry) in cols.iter_mut().zip(row.0.iter()) {
                col.push(*entry)
            }
        }

        Ok(Self { cols })
    }
}

impl Display for ReportTransposed {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        for col in &self.cols {
            for row in col {
                write!(fmt, "{}", *row as usize)?;
            }
            writeln!(fmt)?;
        }
        Ok(())
    }
}

fn part_one_transposed(report: &ReportTransposed) -> usize {
    let gamma = report
        .cols
        .iter()
        .map(|col| {
            col.iter()
                .fold(0isize, |acc, bit| if *bit { acc + 1 } else { acc - 1 })
        })
        .collect::<Vec<isize>>();

    let gamma: usize = {
        let mut num: usize = 0;
        for bit in gamma {
            num <<= 1;
            if bit > 0 {
                num |= 1;
            }
        }
        num
    };

    let mask: usize = {
        let mut mask = 0;
        for _ in &report.cols {
            mask <<= 1;
            mask |= 1;
        }
        mask
    };

    let epsilon = !gamma & mask;

    gamma * epsilon
}

fn part_two(report: &[u16], mask_len: usize) -> usize {
    let mut oxygen_numbers = report.to_vec();
    let mut co2_numbers = report.to_vec();

    let mut mask: u16 = 1 << (mask_len - 1);
    loop {
        // Find most common bit in mask'th column in each vec
        let oxygen_set_bits =
            oxygen_numbers.iter().filter(|ele| *ele & mask != 0).count();
        let oxygen_bit: bool = match oxygen_set_bits
            .cmp(&(oxygen_numbers.len() - oxygen_set_bits))
        {
            Ordering::Less => false,
            Ordering::Equal => true,
            Ordering::Greater => true,
        };

        let co2_set_bits =
            co2_numbers.iter().filter(|ele| *ele & mask != 0).count();
        let co2_bit: bool =
            match co2_set_bits.cmp(&(co2_numbers.len() - co2_set_bits)) {
                Ordering::Less => true,
                Ordering::Equal => false,
                Ordering::Greater => false,
            };

        // Keep only the numbers with the discovered bit in the mask'th position
        if oxygen_numbers.len() > 1 {
            oxygen_numbers.retain(|ele| (*ele & mask != 0) ^ !oxygen_bit);
        }
        if co2_numbers.len() > 1 {
            co2_numbers.retain(|ele| (*ele & mask != 0) ^ !co2_bit);
        }

        mask >>= 1;
        if mask == 0 {
            break;
        }
    }

    let ox = oxygen_numbers[0];
    let co = co2_numbers[0];

    ox as usize * co as usize
}

fn main() {
    println!("Hello, world!");
    let input = include_str!("../input.txt");

    let report = input
        .lines()
        .map(|line| line.parse::<ReportEntry<12>>().unwrap())
        .collect::<Vec<_>>();

    let ans = part_one(&report);
    println!("Part one: {}", ans);

    let report: ReportTransposed = input.parse().unwrap();
    let ans = part_one_transposed(&report);
    println!("Part one transposed: {}", ans);

    let report = input
        .lines()
        .map(|line| u16::from_str_radix(line, 2).unwrap())
        .collect::<Vec<_>>();

    let ans = part_two(&report, 12);
    println!("Part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"#;

    #[test]
    fn test_part_one() {
        let report = TEST_DATA
            .lines()
            .map(|line| line.parse::<ReportEntry<5>>().unwrap())
            .collect::<Vec<_>>();

        println!("{:?}", report);

        let ans = part_one(&report);
        assert_eq!(ans, 198);
    }

    #[test]
    fn test_part_one_transposed() {
        let report: ReportTransposed = TEST_DATA.parse().unwrap();
        println!("Report: \n{}", report);
        let ans = part_one_transposed(&report);
        assert_eq!(ans, 198);
    }

    #[test]
    fn test_part_two() {
        let report = TEST_DATA
            .lines()
            .map(|line| u16::from_str_radix(line, 2).unwrap())
            .collect::<Vec<_>>();

        println!("{:?}", report);

        let ans = part_two(&report, 5);
        assert_eq!(ans, 230);
    }
}
