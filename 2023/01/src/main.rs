use color_eyre::Result;
use std::str::FromStr;

struct DataType(Vec<String>);

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let ret = inp.lines().map(String::from).collect();
        Ok(Self(ret))
    }
}

fn part_one(inp: &DataType) -> u32 {
    let mut values = Vec::new();
    for line in &inp.0 {
        // find first digit
        let first_digit = line.chars().find(char::is_ascii_digit).unwrap();
        let last_digit = line.chars().rev().find(char::is_ascii_digit).unwrap();
        let conf = 10 * ((first_digit as u32) - ('0' as u32))
            + ((last_digit as u32) - ('0' as u32));
        values.push(conf);
    }
    values.iter().sum()
}

fn part_two(_inp: &DataType) -> u64 {
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

    const TEST_DATA: &str = r#"1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 142);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }
}
