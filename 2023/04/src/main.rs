use color_eyre::Result;
use std::collections::HashSet;
use std::str::FromStr;

struct DataType(Vec<Inner>);

#[derive(Debug)]
struct Inner {
    count: u64,
    winning: HashSet<u64>,
    mine: HashSet<u64>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let inner = inp
            .lines()
            .map(|line| {
                let mut spliterator = line.split([':', '|']);
                spliterator.next().unwrap(); // Card number
                let winning = spliterator
                    .next()
                    .unwrap()
                    .split_whitespace()
                    .map(|n| n.parse::<u64>().unwrap())
                    .collect();
                let mine = spliterator
                    .next()
                    .unwrap()
                    .split_whitespace()
                    .map(|n| n.parse::<u64>().unwrap())
                    .collect();
                Inner {
                    count: 1,
                    winning,
                    mine,
                }
            })
            .collect();
        Ok(Self(inner))
    }
}

fn score(card: &Inner) -> u64 {
    let matches = card.winning.intersection(&card.mine).count();
    if matches > 0 {
        2_u64.pow((matches - 1).try_into().unwrap())
    } else {
        0
    }
}

fn part_one(inp: &DataType) -> u64 {
    inp.0.iter().map(score).sum()
}

fn part_two(DataType(mut inp): DataType) -> u64 {
    for idx in 0..inp.len() {
        let points = inp[idx].winning.intersection(&inp[idx].mine).count();
        // won some more cards - record some additional copies of them
        let cur_count = inp[idx].count;
        for next in inp.iter_mut().skip(idx + 1).take(points) {
            next.count += cur_count;
        }
    }

    inp.iter().map(|card| card.count).sum()
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data = input.parse()?;
    let ans = part_one(&data);
    println!("part one: {}", ans);
    let ans = part_two(data);
    println!("part two: {}", ans);
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 13);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(inp);
        assert_eq!(ans, 30);
    }
}
