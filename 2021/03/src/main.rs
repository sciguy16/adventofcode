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

fn main() {
    println!("Hello, world!");
    let input = include_str!("../input.txt");

    let report = input
        .lines()
        .map(|line| line.parse::<ReportEntry<12>>().unwrap())
        .collect::<Vec<_>>();

    let ans = part_one(&report);
    println!("Part one: {}", ans);

    //let ans = part_two(&report);
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
}
