use color_eyre::Result;
use std::str::FromStr;

struct ElfRange {
    start: u64,
    end: u64,
}

impl ElfRange {
    pub fn contains(&self, other: &Self) -> bool {
        self.start <= other.start && other.end <= self.end
    }

    // for each end of self, check to see whether it is inside other
    // also check for full containment
    pub fn overlaps(&self, other: &Self) -> bool {
        self.contains(other)
            || (other.start <= self.start && self.start <= other.end)
            || (other.start <= self.end && self.end <= other.end)
    }
}

impl FromStr for ElfRange {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut split = inp.split('-');
        let start = split.next().unwrap().parse()?;
        let end = split.next().unwrap().parse()?;
        assert!(start <= end);
        Ok(Self { start, end })
    }
}

struct DataType {
    inner: Vec<[ElfRange; 2]>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        Ok(Self {
            inner: inp
                .lines()
                .map(str::trim)
                .map(|line| {
                    let mut split = line.split(',');

                    let left = split.next().unwrap();
                    let right = split.next().unwrap();

                    [left.parse().unwrap(), right.parse().unwrap()]
                })
                .collect(),
        })
    }
}

fn part_one(inp: &DataType) -> u64 {
    inp.inner
        .iter()
        .filter(|[left, right]| left.contains(right) || right.contains(left))
        .count()
        .try_into()
        .unwrap()
}

fn part_two(inp: &DataType) -> u64 {
    inp.inner
        .iter()
        .filter(|[left, right]| left.overlaps(right))
        .count()
        .try_into()
        .unwrap()
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

    const TEST_DATA: &str = r#"2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"#;

    #[test]
    fn test_range_contains() {
        let a = "35-45".parse::<ElfRange>().unwrap();
        let b = "36-45".parse::<ElfRange>().unwrap();
        assert!(a.contains(&b));
        assert!(!b.contains(&a));
    }

    #[test]
    fn test_range_overlaps() {
        let a = "10-30".parse::<ElfRange>().unwrap();
        let b = "20-40".parse::<ElfRange>().unwrap();
        let c = "20-30".parse::<ElfRange>().unwrap();
        assert!(!a.contains(&b));
        assert!(a.overlaps(&b));
        assert!(b.overlaps(&a));
        assert!(c.overlaps(&a));
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
