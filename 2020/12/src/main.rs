use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Clone, Debug, PartialEq)]
enum Orientation {
    North,
    South,
    East,
    West,
}

impl Orientation {
    pub fn rotate_right(&self) -> Self {
        use Orientation::*;
        match self {
            North => East,
            East => South,
            South => West,
            West => North,
        }
    }

    pub fn rotate_left(&self) -> Self {
        use Orientation::*;
        match self {
            North => West,
            West => South,
            South => East,
            East => North,
        }
    }
}

enum RotationDirection {
    Left,
    Right,
}

impl Default for Orientation {
    fn default() -> Self {
        Orientation::East
    }
}

#[derive(Debug, Default)]
struct Ship {
    orientation: Orientation,
    position: (isize, isize),
}

impl Ship {
    pub fn manhatten(&self) -> isize {
        self.position.0.abs() + self.position.1.abs()
    }

    fn rotate(&mut self, direction: &RotationDirection) {
        use RotationDirection::*;
        match direction {
            Right => self.orientation = self.orientation.rotate_right(),
            Left => self.orientation = self.orientation.rotate_left(),
        }
    }

    pub fn r#move(&mut self, instruction: &Instruction) {
        use Instruction::*;
        use Orientation::*;

        match instruction {
            Move(North, distance) => self.position.1 += distance,
            Move(South, distance) => self.position.1 -= distance,
            Move(East, distance) => self.position.0 += distance,
            Move(West, distance) => self.position.0 -= distance,
            Forward(distance) => match self.orientation {
                North => self.position.1 += distance,
                South => self.position.1 -= distance,
                East => self.position.0 += distance,
                West => self.position.0 -= distance,
            },
            Rotate(direction, angle) => {
                for _ in 0..(angle / 90) {
                    self.rotate(direction);
                }
            }
        }
    }
}

#[derive(Debug)]
struct ShipWithWaypoint {
    position: (isize, isize),
    waypoint: (isize, isize),
}

impl Default for ShipWithWaypoint {
    fn default() -> Self {
        Self {
            position: Default::default(),
            waypoint: (10, 1),
        }
    }
}

impl ShipWithWaypoint {
    pub fn manhatten(&self) -> isize {
        self.position.0.abs() + self.position.1.abs()
    }

    fn rotate(&mut self, direction: &RotationDirection) {
        use RotationDirection::*;
        match direction {
            Right => {
                // (x, y) -> (y, -x)
                // (1, 2) -> (2, -1)
                self.waypoint = (self.waypoint.1, -self.waypoint.0);
            }
            Left => {
                // (x, y) -> (y, -x)
                // (1, 2) -> (-2, 1)
                self.waypoint = (-self.waypoint.1, self.waypoint.0);
            }
        }
    }

    pub fn r#move(&mut self, instruction: &Instruction) {
        use Instruction::*;
        use Orientation::*;

        match instruction {
            Move(North, distance) => self.waypoint.1 += distance,
            Move(South, distance) => self.waypoint.1 -= distance,
            Move(East, distance) => self.waypoint.0 += distance,
            Move(West, distance) => self.waypoint.0 -= distance,
            Forward(distance) => {
                // Move forward to the waypoint this many times (waypoint
                // is relative to ship)
                self.position.0 += self.waypoint.0 * distance;
                self.position.1 += self.waypoint.1 * distance;
            }
            Rotate(direction, angle) => {
                for _ in 0..(angle / 90) {
                    self.rotate(direction);
                }
            }
        }
    }
}

enum Instruction {
    /// Move in direction by distance
    Move(Orientation, isize),
    /// Move forward by distance
    Forward(isize),
    /// Rotate in direction by angle
    Rotate(RotationDirection, isize),
}

impl From<&str> for Instruction {
    fn from(inp: &str) -> Self {
        use Instruction::*;
        use Orientation::*;
        use RotationDirection::*;

        // Instructions look like "letter" + "some numbers"
        let (letter, numbers) = inp.split_at(1);
        let numbers = numbers.parse::<isize>().expect("Invalid number");

        println!("letter: {},num: {}", letter, numbers);

        // Action N means to move north by the given value.
        // Action S means to move south by the given value.
        // Action E means to move east by the given value.
        // Action W means to move west by the given value.
        // Action L means to turn left the given number of degrees.
        // Action R means to turn right the given number of degrees.
        // Action F means to move forward by the given value in the direction
        //   the ship is currently facing.

        match letter {
            "N" => Move(North, numbers),
            "S" => Move(South, numbers),
            "E" => Move(East, numbers),
            "W" => Move(West, numbers),
            "L" => Rotate(Left, numbers),
            "R" => Rotate(Right, numbers),
            "F" => Forward(numbers),
            e => panic!("Unexpected letter: `{}`", e),
        }
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<Instruction> = BufReader::new(file)
        .lines()
        .map(|x| Instruction::from(x.unwrap().as_str()))
        .collect();

    let res = part_one(&data);
    println!("Part one: {}", res);

    let res = part_two(&data);
    println!("Part two: {}", res);

    Ok(())
}

/// Returns the manhatten distance from the start
fn part_one(route: &[Instruction]) -> isize {
    let mut ship: Ship = Default::default();

    for instruction in route {
        ship.r#move(instruction);
    }

    ship.manhatten()
}

/// Returns the manhatten distance from the start
fn part_two(route: &[Instruction]) -> isize {
    let mut ship: ShipWithWaypoint = Default::default();

    for instruction in route {
        ship.r#move(instruction);
    }

    println!("Ship is: {:?}", ship);

    ship.manhatten()
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part_one() {
        let test_data =
            ["F10", "N3", "F7", "R90", "F11"].map(Instruction::from);

        let res = part_one(&test_data);
        assert_eq!(res, 25);
    }

    #[test]
    fn test_part_two() {
        let test_data =
            ["F10", "N3", "F7", "R90", "F11"].map(Instruction::from);

        let res = part_two(&test_data);
        assert_eq!(res, 286);
    }

    #[test]
    fn test_part_two_moves() {
        // * F10 moves the ship to the waypoint 10 times (a total of 100 units
        //     east and 10 units north), leaving the ship at east 100, north 10.
        //     The waypoint stays 10 units east and 1 unit north of the ship.
        // * N3 moves the waypoint 3 units north to 10 units east and 4 units
        //     north of the ship. The ship remains at east 100, north 10.
        // * F7 moves the ship to the waypoint 7 times (a total of 70 units
        //     east and 28 units north), leaving the ship at east 170, north 38.
        //    The waypoint stays 10 units east and 4 units north of the ship.
        // * R90 rotates the waypoint around the ship clockwise 90 degrees,
        //     moving it to 4 units east and 10 units south of the ship. The
        //     ship remains at east 170, north 38.
        // * F11 moves the ship to the waypoint 11 times (a total of 44 units
        //     east and 110 units south), leaving the ship at east 214, south
        //     72. The waypoint stays 4 units east and 10 units south of the ship.

        let test_data =
            ["F10", "N3", "F7", "R90", "F11"].map(Instruction::from);

        let mut ship: ShipWithWaypoint = Default::default();

        ship.r#move(&test_data[0]);
        assert_eq!(ship.position, (100, 10));
    }
}
