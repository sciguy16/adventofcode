use color_eyre::Result;
use std::str::FromStr;

struct DataType {
    races: Vec<Race>,
}

struct Race {
    time: u64,
    best_distance: u64,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut lines = inp.lines();
        let races = lines
            .next()
            .unwrap()
            .strip_prefix("Time:      ")
            .unwrap()
            .split_whitespace()
            .map(str::parse)
            .zip(
                lines
                    .next()
                    .unwrap()
                    .strip_prefix("Distance:  ")
                    .unwrap()
                    .split_whitespace()
                    .map(str::parse),
            )
            .map(|(time, distance)| Race {
                time: time.unwrap(),
                best_distance: distance.unwrap(),
            })
            .collect();
        Ok(Self { races })
    }
}

fn run_race(button_time: u64, time: u64) -> u64 {
    if button_time > time {
        return 0;
    }

    let move_time = time - button_time;

    // button time = velocity, so distance = velocity * time
    button_time * move_time
}

fn part_one(inp: &DataType) -> u64 {
    inp.races
        .iter()
        .map(
            |&Race {
                 time,
                 best_distance,
             }| {
                let mut win_count = 0;
                for button_time in 0..time {
                    let dist = run_race(button_time, time);
                    if dist > best_distance {
                        win_count += 1;
                    }
                }
                println!("Race for {time} ms; win {win_count} times");
                win_count
            },
        )
        .product()
}

fn part_two(inp: &DataType) -> u64 {
    // be bad and yolo it via strings
    let (long_time, long_distance) = inp
        .races
        .iter()
        .map(
            |Race {
                 time,
                 best_distance,
             }| (time.to_string(), best_distance.to_string()),
        )
        .fold((String::new(), String::new()), |acc, race| {
            (acc.0 + &race.0, acc.1 + &race.1)
        });
    let race = Race {
        time: long_time.parse().unwrap(),
        best_distance: long_distance.parse().unwrap(),
    };

    part_one(&DataType { races: vec![race] })
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

    const TEST_DATA: &str = r#"Time:      7  15   30
Distance:  9  40  200"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 288);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 71503);
    }
}
