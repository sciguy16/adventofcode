use color_eyre::Result;
use regex::Regex;
use std::str::FromStr;

struct DataType {
    inner: String,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        Ok(Self {
            inner: inp.lines().collect(),
        })
    }
}

fn part_one(inp: &DataType) -> i32 {
    let re = Regex::new(r"mul\((\d+),(\d+)\)").unwrap();
    re.captures_iter(&inp.inner)
        .map(|cap| {
            let a = &cap[1].parse::<i32>().unwrap();
            let b = &cap[2].parse::<i32>().unwrap();

            a.checked_mul(*b).unwrap()
        })
        .sum()
}

fn part_two(inp: &DataType) -> i32 {
    let re = Regex::new(r"(do\(\))|(don't\(\))|mul\((\d+),(\d+)\)").unwrap();
    let mut enabled = true;
    re.captures_iter(&inp.inner)
        .map(|cap| {
            let do_ = cap.get(1);
            let dont = cap.get(2);
            if do_.is_some() {
                enabled = true;
            }
            if dont.is_some() {
                enabled = false;
            }

            if let (Some(a), Some(b)) = (cap.get(3), cap.get(4)) {
                let a = a.as_str().parse::<i32>().unwrap();
                let b = b.as_str().parse::<i32>().unwrap();
                if enabled {
                    return a.checked_mul(b).unwrap();
                }
            }
            0
        })
        .sum()
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
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+\
    mul(32,64]then(mul(11,8)mul(8,5))";

    const TEST_DATA_2: &str = "\
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 161);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 48);
    }
}
