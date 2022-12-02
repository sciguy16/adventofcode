use color_eyre::eyre::eyre;
use color_eyre::Result;
use std::str::FromStr;

#[derive(Copy, Clone, Eq, PartialEq)]
enum Move {
    Rock,
    Paper,
    Scissors,
}

impl Move {
    pub const fn score(self) -> u64 {
        match self {
            Move::Rock => 1,
            Move::Paper => 2,
            Move::Scissors => 3,
        }
    }

    pub const fn move_to_get_outcome(self, outcome: RoundOutcome) -> Self {
        use Move::*;
        use RoundOutcome::*;
        match (self, outcome) {
            (m, Draw) => m,
            (Rock, Lose) => Scissors,
            (Rock, Win) => Paper,
            (Paper, Lose) => Rock,
            (Paper, Win) => Scissors,
            (Scissors, Lose) => Paper,
            (Scissors, Win) => Rock,
        }
    }

    pub const fn fight(&self, other: Self) -> RoundOutcome {
        use Move::*;
        use RoundOutcome::*;
        match (self, other) {
            (Rock, Paper) => Lose,
            (Rock, Scissors) => Win,
            (Paper, Scissors) => Lose,
            (Paper, Rock) => Win,
            (Scissors, Rock) => Lose,
            (Scissors, Paper) => Win,
            _ => Draw,
        }
    }
}

impl TryFrom<char> for Move {
    type Error = color_eyre::Report;

    fn try_from(inp: char) -> std::result::Result<Self, Self::Error> {
        Ok(match inp {
            'A' | 'X' => Move::Rock,
            'B' | 'Y' => Move::Paper,
            'C' | 'Z' => Move::Scissors,
            other => Err(eyre!("Unexpected character `{}`", other))?,
        })
    }
}

#[derive(Copy, Clone, Eq, PartialEq)]
enum RoundOutcome {
    Lose,
    Draw,
    Win,
}

impl RoundOutcome {
    pub const fn score(self) -> u64 {
        use RoundOutcome::*;
        match self {
            Lose => 0,
            Draw => 3,
            Win => 6,
        }
    }
}

impl TryFrom<char> for RoundOutcome {
    type Error = color_eyre::Report;

    fn try_from(inp: char) -> std::result::Result<Self, Self::Error> {
        Ok(match inp {
            'X' => RoundOutcome::Lose,
            'Y' => RoundOutcome::Draw,
            'Z' => RoundOutcome::Win,
            other => Err(eyre!("Unexpected character `{}`", other))?,
        })
    }
}

struct DataType {
    inner: Vec<(Move, Move, RoundOutcome)>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let inner = inp
            .lines()
            .map(|line| {
                let [them, _, me]: [char; 3] =
                    line.chars().collect::<Vec<_>>().try_into().map_err(
                        |e| eyre!("Failed to squash vec into array `{:?}`", e),
                    )?;
                let a = them.try_into()?;
                let b = me.try_into()?;
                let c = me.try_into()?;
                Ok::<(Move, Move, RoundOutcome), Self::Err>((a, b, c))
            })
            .collect::<Result<Vec<_>, _>>()?;
        Ok(Self { inner })
    }
}

fn part_one(inp: &DataType) -> u64 {
    inp.inner
        .iter()
        .map(|(them, me, _)| {
            // Get result and then add score for result to score for my move
            me.fight(*them).score() + me.score()
        })
        .sum()
}

fn part_two(inp: &DataType) -> u64 {
    inp.inner
        .iter()
        .map(|(them, _, outcome)| {
            // score from result + work out what my move was and add its score
            outcome.score() + them.move_to_get_outcome(*outcome).score()
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

    const TEST_DATA: &str = r#"A Y
B X
C Z
"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 15);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 12);
    }

    #[test]
    fn test_move_cmp() {
        use Move::*;
        use RoundOutcome::*;

        assert!(Rock.fight(Scissors) == Win);
        assert!(Scissors.fight(Paper) == Win);
        assert!(Paper.fight(Rock) == Win);
        assert!(Paper == Paper);
    }
}
