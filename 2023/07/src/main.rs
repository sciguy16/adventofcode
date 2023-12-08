use color_eyre::Result;
use std::str::FromStr;

struct DataType {
    inner: Vec<Hand>,
}

struct Hand {
    cards: [Card; 5],
    bid: u64,
}

#[derive(Debug)]
enum Card {
    Number(u8),
    Jack,
    Queen,
    King,
    Ace,
}

impl From<char> for Card {
    fn from(c: char) -> Self {
        use Card::*;
        match c {
            n if ('2'..='9').contains(&n) => Number(n as u8 - b'0'),
            'T' => Number(10),
            'J' => Jack,
            'Q' => Queen,
            'K' => King,
            'A' => Ace,
            other => panic!("unknown: `{other}`"),
        }
    }
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let inner = inp
            .lines()
            .map(|line| {
                let cards = line[..5]
                    .chars()
                    .map(Card::from)
                    .collect::<Vec<_>>()
                    .try_into()
                    .unwrap();
                let bid = line[6..].parse().unwrap();
                Hand { cards, bid }
            })
            .collect();
        Ok(Self { inner })
    }
}

fn part_one(_inp: &DataType) -> u64 {
    0
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

    const TEST_DATA: &str = r#"32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 0);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }
}
