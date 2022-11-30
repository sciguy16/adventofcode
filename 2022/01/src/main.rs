use color_eyre::Result;
use std::str::FromStr;

struct DataType;

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(_inp: &str) -> std::result::Result<Self, Self::Err> {
        Ok(Self)
    }
}

fn part_one(_inp: &DataType) -> usize {
    0
}

fn part_two(_inp: &DataType) -> usize {
    0
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

    const TEST_DATA: &str = r#""#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 4);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 4);
    }
}
