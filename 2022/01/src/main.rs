use color_eyre::Result;
use std::str::FromStr;

struct DataType {
    inner: Vec<Vec<u64>>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut inner = Vec::new();

        let mut temp = Vec::new();
        for line in inp.lines().map(str::trim) {
            if line.is_empty() {
                inner.push(temp.clone());
                temp.clear();
            } else {
                temp.push(line.parse()?);
            }
        }
        if !temp.is_empty() {
            inner.push(temp);
        }

        Ok(Self { inner })
    }
}

fn part_one(inp: &DataType) -> u64 {
    // find max sum
    inp.inner
        .iter()
        .map(|elf| elf.iter().sum())
        .max()
        .unwrap_or_default()
}

fn part_two(inp: &DataType) -> u64 {
    // find sum of top 3
    let mut food = inp
        .inner
        .iter()
        .map(|elf| elf.iter().sum())
        .collect::<Vec<_>>();
    food.sort_unstable();
    food.iter().rev().take(3).sum()
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

    const TEST_DATA: &str = r#"1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 24000);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 45000);
    }
}
