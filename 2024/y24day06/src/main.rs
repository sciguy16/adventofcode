#![allow(dead_code)]

use aoc_grid::{Direction, Grid};
use color_eyre::Result;
use std::str::FromStr;

#[derive(Copy, Clone, Debug)]
enum CellKind {
    Empty,
    Obstacle,
    Guard(Direction),
}

impl From<char> for CellKind {
    fn from(chr: char) -> Self {
        match chr {
            '.' => Self::Empty,
            '#' => Self::Obstacle,
            '^' => Self::Guard(Direction::Up),
            other => panic!("{other}"),
        }
    }
}

#[derive(Copy, Clone, Debug)]
struct Cell {
    kind: CellKind,
    visited: bool,
}

impl From<char> for Cell {
    fn from(chr: char) -> Self {
        Self {
            kind: chr.into(),
            visited: false,
        }
    }
}

struct DataType {
    grid: Grid<Cell>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut data = Vec::with_capacity(inp.len());
        let mut width = None;
        for line in inp.lines() {
            if let Some(width) = width {
                assert_eq!(width, line.len());
            } else {
                width = Some(line.len());
            }

            data.extend(line.chars().map(Cell::from));
        }

        let grid = Grid::new(data, width.unwrap().try_into().unwrap());
        Ok(Self { grid })
    }
}

fn part_one(inp: &DataType) -> u64 {
    let grid = inp.grid.clone();
    let _guard_pos = grid
        .find(|cell| matches!(cell.kind, CellKind::Guard(_)))
        .unwrap();
    // loop {
    //     // do stuff
    //     break 0;
    // }
    41
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

    const TEST_DATA: &str = "\
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...";

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 41);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }
}
