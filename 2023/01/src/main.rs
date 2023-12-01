use color_eyre::Result;
use std::collections::HashMap;
use std::str::FromStr;

const DIGITS: [(&str, u32); 10] = [
    ("zero", 0),
    ("one", 1),
    ("two", 2),
    ("three", 3),
    ("four", 4),
    ("five", 5),
    ("six", 6),
    ("seven", 7),
    ("eight", 8),
    ("nine", 9),
];

struct DataType(Vec<String>);

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let ret = inp.lines().map(String::from).collect();
        Ok(Self(ret))
    }
}

fn part_one(inp: &DataType) -> u32 {
    inp.0
        .iter()
        .map(|line| {
            let first_digit = line.chars().find(char::is_ascii_digit).unwrap();
            let last_digit =
                line.chars().rev().find(char::is_ascii_digit).unwrap();

            10 * ((first_digit as u32) - ('0' as u32))
                + ((last_digit as u32) - ('0' as u32))
        })
        .sum()
}

fn part_two(inp: &DataType) -> u32 {
    let valid_tokens = (0..=9)
        .map(|digit| (format!("{digit}"), digit))
        .chain(DIGITS.iter().map(|(s, d)| (s.to_string(), *d)))
        .collect::<HashMap<_, _>>();

    let mut total = 0;

    for line in &inp.0 {
        // search for the leftmost pattern
        let first = valid_tokens
            .iter()
            .filter_map(|(pat, val)| line.find(pat).map(|pos| (pos, val)))
            .min_by_key(|(pos, _val)| *pos)
            .unwrap()
            .1;

        // search for rightmost pattern
        let last = valid_tokens
            .iter()
            .filter_map(|(pat, val)| line.rfind(pat).map(|pos| (pos, val)))
            .max_by_key(|(pos, _val)| *pos)
            .unwrap()
            .1;
        total += first * 10 + last;
    }

    total
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

    const TEST_DATA_2: &str = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen";

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 142);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 281);
    }
}
