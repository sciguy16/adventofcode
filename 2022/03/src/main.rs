use color_eyre::Result;
use std::collections::HashSet;
use std::str::FromStr;

trait Priority {
    fn priority(&self) -> u64;
}

impl Priority for char {
    #[inline]
    fn priority(&self) -> u64 {
        match self {
            'a'..='z' => (*self as u64) - ('a' as u64) + 1,
            'A'..='Z' => (*self as u64) - ('A' as u64) + 27,
            _ => panic!(),
        }
    }
}

type Set = HashSet<char>;

struct DataType {
    inner: Vec<(Set, Set, Set)>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        Ok(Self {
            inner: inp
                .lines()
                .map(str::trim)
                .map(|s| {
                    // assert!(s.len() % 2 == 0);
                    let ch = s.chars();
                    (
                        ch.clone().take(s.len() / 2).collect(),
                        ch.clone().skip(s.len() / 2).collect(),
                        ch.collect(),
                    )
                })
                .collect(),
        })
    }
}

#[inline]
fn part_one(inp: &DataType) -> u64 {
    inp.inner
        .iter()
        .filter_map(|(left, right, _)| {
            let mut intersection = left.intersection(right);
            intersection.next().map(Priority::priority)
        })
        .sum()
}

#[inline]
fn part_two(inp: &DataType) -> u64 {
    inp.inner
        .chunks_exact(3)
        .filter_map(|chunk| {
            let [(_,_,a), (_,_,b), (_,_,c)] = chunk else {unreachable!()};
            a.intersection(b)
                .find(|ch| c.contains(ch))
                .map(Priority::priority)
        })
        .sum()
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data = input.parse()?;
    let ans = part_one(&data);
    println!("part one: {ans}");
    let ans = part_two(&data);
    println!("part two: {ans}");
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"#;

    #[test]
    fn test_char_prio() {
        assert_eq!('a'.priority(), 1);
        assert_eq!('z'.priority(), 26);
        assert_eq!('A'.priority(), 27);
        assert_eq!('Z'.priority(), 52);
    }

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 157);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 70);
    }
}
