use color_eyre::Result;
use nom::{Finish, IResult};
use std::str::FromStr;

struct DataType(Vec<Inner>);

#[derive(Debug)]
struct Inner {
    id: u64,
    counts: Vec<Counts>,
}

#[derive(Copy, Clone, Debug, Default)]
struct Counts {
    red: u64,
    green: u64,
    blue: u64,
}

impl Counts {
    fn power(self) -> u64 {
        self.red * self.green * self.blue
    }
}

impl Inner {
    fn parse(i: &str) -> IResult<&str, Self> {
        use nom::{
            branch::alt,
            bytes::complete::tag,
            character::complete::{char, multispace1, u64},
        };

        // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        // Game
        let (i, _) = tag("Game")(i)?;
        let (i, _) = multispace1(i)?;
        let (i, id) = u64(i)?;
        let (i, _) = char(':')(i)?;
        let (mut i, _) = multispace1(i)?;

        let mut counts = Vec::new();

        let mut cur_count = Counts::default();
        loop {
            // number
            let n;
            (i, n) = u64(i)?;
            (i, _) = multispace1(i)?;

            // tag
            let t;
            (i, t) = alt((tag("red"), tag("green"), tag("blue")))(i)?;

            // assign the count to the correct field
            match t {
                "red" => cur_count.red = n,
                "green" => cur_count.green = n,
                "blue" => cur_count.blue = n,
                other => panic!("Can't: {other}"),
            }

            // semicolon or comma or EOL
            if i.is_empty() {
                // EOL
                counts.push(cur_count);
                break;
            }
            let c;
            (i, c) = alt((char(','), char(';')))(i)?;
            match c {
                ',' => {}
                ';' => {
                    counts.push(cur_count);
                    cur_count = Counts::default();
                }
                _ => unreachable!(),
            }
            (i, _) = multispace1(i)?;
        }

        IResult::Ok((i, Self { id, counts }))
    }
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut inner = Vec::new();
        for line in inp.lines() {
            let (_i, ret) = Inner::parse(line).finish().unwrap();
            inner.push(ret)
        }
        Ok(DataType(inner))
    }
}

fn part_one(inp: &DataType, bag: Counts) -> u64 {
    let mut total = 0;

    for game in &inp.0 {
        if game.counts.iter().all(|count| {
            count.red <= bag.red
                && count.green <= bag.green
                && count.blue <= bag.blue
        }) {
            total += game.id;
        }
    }

    total
}

fn part_two(inp: &DataType) -> u64 {
    let mut total = 0;

    for game in &inp.0 {
        let needed: Counts = game
            .counts
            .iter()
            .copied()
            .reduce(|acc, x| Counts {
                red: u64::max(acc.red, x.red),
                green: u64::max(acc.green, x.green),
                blue: u64::max(acc.blue, x.blue),
            })
            .unwrap();
        let power = needed.power();
        total += power;
    }

    total
}

fn main() -> Result<()> {
    color_eyre::install()?;

    let input = include_str!("../input.txt");
    let data = input.parse()?;
    let ans = part_one(
        &data,
        Counts {
            red: 12,
            green: 13,
            blue: 14,
        },
    );
    println!("part one: {}", ans);
    let ans = part_two(&data);
    println!("part two: {}", ans);
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(
            &inp,
            Counts {
                red: 12,
                green: 13,
                blue: 14,
            },
        );
        assert_eq!(ans, 8);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 2286);
    }
}
