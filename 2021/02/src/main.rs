use std::str::FromStr;

enum Movement {
    Up(isize),
    Down(isize),
    Forward(isize),
}

impl FromStr for Movement {
    type Err = Box<dyn std::error::Error>;
    fn from_str(inp: &str) -> Result<Self, Self::Err> {
        let mut spliterator = inp.split(' ');
        let first = spliterator.next().unwrap();
        let second = spliterator.next().unwrap().parse::<isize>()?;

        Ok(match first {
            "up" => Movement::Up(second),
            "down" => Movement::Down(second),
            "forward" => Movement::Forward(second),
            o => panic!("Invalid direction {}", o),
        })
    }
}

#[derive(Debug, Default)]
struct Coords {
    x: isize,
    y: isize,
}

impl Coords {
    pub fn prod(&self) -> isize {
        self.x * self.y
    }
}

fn part_one(movements: &[Movement]) -> isize {
    let mut coords = Coords::default();

    for movement in movements {
        match movement {
            Movement::Up(d) => coords.y -= d,
            Movement::Down(d) => coords.y += d,
            Movement::Forward(d) => coords.x += d,
        }
    }
    println!("Coords: {:?}", coords);
    coords.prod()
}

fn part_two(movements: &[Movement]) -> isize {
    let mut coords = Coords::default();
    let mut aim: isize = 0;

    for movement in movements {
        match movement {
            Movement::Up(d) => aim -= d,
            Movement::Down(d) => aim += d,
            Movement::Forward(d) => {
                coords.x += d;
                coords.y += aim * d;
            }
        }
    }

    coords.prod()
}

fn main() {
    println!("Hello, world!");
    let input = include_str!("../input.txt");

    let movements = input
        .lines()
        .map(|line| line.parse::<Movement>().unwrap())
        .collect::<Vec<_>>();

    let ans = part_one(&movements);
    println!("Part one: {}", ans);

    let ans = part_two(&movements);
    println!("Part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"forward 5
down 5
forward 8
up 3
down 8
forward 2"#;

    #[test]
    fn test_part_1() {
        let movements = TEST_DATA
            .lines()
            .map(|line| line.parse::<Movement>().unwrap())
            .collect::<Vec<_>>();

        let ans = part_one(&movements);
        assert_eq!(ans, 150);
    }

    #[test]
    fn test_part_2() {
        let movements = TEST_DATA
            .lines()
            .map(|line| line.parse::<Movement>().unwrap())
            .collect::<Vec<_>>();

        let ans = part_two(&movements);
        assert_eq!(ans, 900);
    }
}
