use color_eyre::Result;
use grid::Grid;
use std::str::FromStr;

#[repr(u8)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
enum Cell {
    Pipe(Direction, Direction),
    Start,
    Empty,
}

impl From<char> for Cell {
    fn from(ch: char) -> Self {
        use Direction::*;

        match ch {
            '|' => Self::Pipe(Up, Down),
            '-' => Self::Pipe(Left, Right),
            'L' => Self::Pipe(Up, Right),
            'J' => Self::Pipe(Up, Left),
            '7' => Self::Pipe(Left, Down),
            'F' => Self::Pipe(Right, Down),
            '.' => Self::Empty,
            'S' => Self::Start,
            other => panic!("{other}"),
        }
    }
}

#[derive(Debug)]
struct DataType {
    map: Grid<Cell>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let width = inp.find('\n').unwrap();
        let map = inp
            .chars()
            .filter(|&ch| ch != '\n')
            .map(Cell::from)
            .collect::<Vec<_>>();
        let map = Grid::from_vec(map, width);
        Ok(Self { map })
    }
}

fn part_one(inp: &DataType) -> u64 {
    dbg!(&inp);

    // find start
    let start = inp
        .map
        .indexed_iter()
        .find(|(_, &cell)| cell == Cell::Start)
        .map(|(coords, _)| coords)
        .unwrap();
    println!("Start is at {start:?}");
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

    const TEST_DATA: &str = r".....
.S-7.
.|.|.
.L-J.
.....";

    const TEST_DATA_2: &str = "..F7.
.FJ|.
SJ.L7
|F--J
LJ...";

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 4);

        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 8);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }
}
