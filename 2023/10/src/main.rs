use color_eyre::Result;
use grid::Grid;
use std::collections::HashSet;
use std::str::FromStr;

#[repr(u8)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

impl Direction {
    fn move_(&self, (x, y): (usize, usize)) -> (usize, usize) {
        match self {
            Self::Up => (x - 1, y),
            Self::Down => (x + 1, y),
            Self::Left => (x, y - 1),
            Self::Right => (x, y + 1),
        }
    }
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

impl Cell {
    fn move_(&self, pos: (usize, usize)) -> ((usize, usize), (usize, usize)) {
        let Cell::Pipe(dir0, dir1) = self else {
            panic!()
        };

        let move0 = dir0.move_(pos);
        let move1 = dir1.move_(pos);

        (move0, move1)
    }

    fn has(&self, dir: Direction) -> bool {
        let &Self::Pipe(dir0, dir1) = self else {
            return false;
        };

        [dir0, dir1].contains(&dir)
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

fn iter_surrounding(
    g: &Grid<Cell>,
    (x, y): (usize, usize),
) -> impl Iterator<Item = (usize, usize)> + '_ {
    // x is row, y is column

    [
        // row above
        // (x.checked_sub(1), y.checked_sub(1), ),
        (x.checked_sub(1), Some(y), Direction::Up),
        // (x.checked_sub(1), y.checked_add(1)),
        // current row
        (Some(x), y.checked_sub(1), Direction::Left),
        (Some(x), y.checked_add(1), Direction::Right),
        // row below
        // (x.checked_add(1), y.checked_sub(1)),
        (x.checked_add(1), Some(y), Direction::Down),
        // (x.checked_add(1), y.checked_add(1)),
    ]
    .into_iter()
    .filter_map(|(x, y, dir)| Some((x?, y?, dir)))
    .filter(|&(x, y, dir)| {
        g.get(x, y).map(|cell| cell.has(dir)).unwrap_or_default()
    })
    .map(|(x, y, _dir)| (x, y))
}

fn part_one(inp: &DataType) -> usize {
    dbg!(&inp);
    let g = &inp.map;

    // find start
    let start = g
        .indexed_iter()
        .find(|(_, &cell)| cell == Cell::Start)
        .map(|(coords, _)| coords)
        .unwrap();
    println!("Start is at {start:?}");

    let mut seen = HashSet::new();
    let mut path1 = Vec::new();
    let mut path2 = Vec::new();

    // find first outward movement
    seen.insert(start);
    let mut adjacent_loops = iter_surrounding(g, start)
        .filter(|&(x, y)| *g.get(x, y).unwrap() != Cell::Empty);

    let ele = adjacent_loops.next().unwrap();
    path1.push(ele);
    seen.insert(ele);

    let ele = adjacent_loops.next().unwrap();
    path2.push(ele);
    seen.insert(ele);

    assert!(adjacent_loops.next().is_none());

    let mut limit: u32 = 30;
    loop {
        dbg!(&path1);
        dbg!(&path2);
        dbg!(&seen);
        limit = limit.checked_sub(1).expect("execution limit reached");
        if let (Some(end1), Some(end2)) = (path1.last(), path2.last()) {
            if end1 == end2 {
                break;
            }
        }

        // extend path1
        let pos = *path1.last().unwrap();
        let cell = g.get(pos.0, pos.1).unwrap();
        let adj = cell.move_(pos);
        dbg!(adj);
        // assert!(!seen.contains(&adj.0) && !seen.contains(&adj.1));

        let next = if !seen.contains(&adj.0) {
            adj.0
        } else if !seen.contains(&adj.1) {
            adj.1
        } else {
            break;
        };
        seen.insert(next);
        path1.push(next);

        // extend path2
        let pos = *path2.last().unwrap();
        let cell = g.get(pos.0, pos.1).unwrap();
        let adj = cell.move_(pos);
        dbg!(adj);
        // assert!(!seen.contains(&adj.0) && !seen.contains(&adj.1));

        let next = if !seen.contains(&adj.0) {
            adj.0
        } else if !seen.contains(&adj.1) {
            adj.1
        } else {
            break;
        };
        seen.insert(next);
        path2.push(next);
    }

    path1.len()
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
    #[ignore]
    fn test_part_1a() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 4);
    }

    #[test]
    #[ignore]
    fn test_part_1b() {
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
