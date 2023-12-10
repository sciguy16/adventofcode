#![feature(is_sorted)]

use color_eyre::Result;
use std::collections::HashSet;
use std::str::FromStr;

struct DataType {
    inner: Vec<Hand>,
}

struct Hand {
    cards: [Card; 5],
    bid: u64,
}

#[derive(Copy, Clone, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
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

#[derive(Copy, Clone, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum PartTwoCard {
    Joker,
    Number(u8),
    Queen,
    King,
    Ace,
}

impl From<Card> for PartTwoCard {
    fn from(card: Card) -> Self {
        match card {
            Card::Jack => Self::Joker,
            Card::Number(n) => Self::Number(n),
            Card::Queen => Self::Queen,
            Card::King => Self::King,
            Card::Ace => Self::Ace,
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

#[derive(Copy, Clone, Debug, PartialEq, Eq, PartialOrd, Ord)]
enum HandType {
    HighCard([Card; 5]),
    OnePair([Card; 5]),
    TwoPair([Card; 5]),
    ThreeOfKind([Card; 5]),
    FullHouse([Card; 5]),
    FourOfKind([Card; 5]),
    FiveOfKind([Card; 5]),
}

impl From<[Card; 5]> for HandType {
    #[allow(clippy::nonminimal_bool)]
    fn from(hand: [Card; 5]) -> Self {
        use HandType::*;
        let mut hand_sorted = hand;
        hand_sorted.sort_unstable();
        hand_sorted.reverse();
        let hash = hand.iter().collect::<HashSet<_>>();
        match hand_sorted {
            [c, tail @ ..] if tail.iter().all(|&ele| ele == c) => {
                FiveOfKind(hand)
            }
            [start, c, mid @ .., end]
                if mid.iter().all(|&ele| ele == c)
                    && ([start, end].contains(&c)) =>
            {
                FourOfKind(hand)
            }
            [a, b, c, d, e]
                if a == b && d == e && b != d && (b == c || c == d) =>
            {
                FullHouse(hand)
            }
            [a, b, c, d, e]
                if (a == b && b == c && c != d && d != e)
                    || (a != b && b == c && c == d && d != e)
                    || (a != b && b != c && c == d && d == e) =>
            {
                ThreeOfKind(hand)
            }
            [a, b, c, d, e]
                if a == b && b != c && c != e && (c == d || d == e)
                    || a != b && b == c && c != d && d == e =>
            {
                TwoPair(hand)
            }
            _ if hash.len() == 4 => OnePair(hand),
            _ if hash.len() == 5 => HighCard(hand),
            _ => panic!(),
        }
    }
}

fn part_one(inp: &DataType) -> u64 {
    let mut hands = inp
        .inner
        .iter()
        .map(|&Hand { cards, bid }| (HandType::from(cards), bid))
        .collect::<Vec<_>>();
    hands.sort_unstable();
    // hands.reverse();

    hands
        .iter()
        .enumerate()
        .map(|(idx, (hand, bid))| {
            let rank = idx as u64 + 1;
            println!("{rank}: {hand:?} ({bid})");
            rank * bid
        })
        .sum()
}

fn part_two(inp: &DataType) -> u64 {
    let transformed = inp
        .inner
        .iter()
        .map(|Hand { cards, bid }| (PartTwoCard::from(cards), bid));
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
        assert_eq!(ans, 6440);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }

    #[test]
    fn hand_parse_and_ordering() {
        use HandType::*;

        let inp = "AAAAA 1
AA8AA 1
23332 1
TTT98 1
23432 1
A23A4 1
23456 1";

        let inp = inp.parse::<DataType>().unwrap();
        let mut inp = inp
            .inner
            .into_iter()
            .map(|h| HandType::from(h.cards))
            .collect::<Vec<_>>();

        assert!(matches!(inp[0], FiveOfKind(_)));
        assert!(matches!(inp[1], FourOfKind(_)));
        assert!(matches!(inp[2], FullHouse(_)));
        assert!(matches!(inp[3], ThreeOfKind(_)));
        assert!(matches!(inp[4], TwoPair(_)));
        assert!(matches!(inp[5], OnePair(_)));
        assert!(matches!(inp[6], HighCard(_)));

        inp.reverse();
        assert!(inp.is_sorted());
    }
}
