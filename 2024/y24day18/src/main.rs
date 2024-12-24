use aoc_grid::{Coord, Grid};
use color_eyre::Result;
use petgraph::{graphmap::GraphMap, Undirected};
use rustc_hash::FxBuildHasher;
use std::{
    fmt::{Display, Formatter},
    str::FromStr,
    time::Instant,
};

const PUZZLE_INPUT: &str = include_str!("../input.txt");

struct DataType<const DIM: i64, const LINES_TO_READ: usize> {
    grid: Grid<CellType>,
    spare_bytes: Vec<Coord>,
}

#[derive(Copy, Clone, Debug, Default, PartialEq, Eq)]
enum CellType {
    #[default]
    Safe,
    Danger,
}

impl Display for CellType {
    fn fmt(&self, fmt: &mut Formatter) -> std::fmt::Result {
        fmt.write_str(match self {
            Self::Safe => " ",
            Self::Danger => "#",
        })
    }
}

impl<const DIM: i64, const LINES_TO_READ: usize> FromStr
    for DataType<{ DIM }, { LINES_TO_READ }>
{
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut grid = Grid::new_default(DIM + 1, DIM + 1);
        let mut spare_bytes = Vec::new();

        for (idx, line) in inp.lines().enumerate() {
            let mut iter = line.split(',');
            let x = iter.next().unwrap().parse::<i64>().unwrap();
            let y = iter.next().unwrap().parse::<i64>().unwrap();
            if idx < LINES_TO_READ {
                grid.set((x, y), CellType::Danger);
            } else {
                spare_bytes.push((x, y).into());
            }
        }

        Ok(Self { grid, spare_bytes })
    }
}

fn make_grid_into_graph(
    grid: &Grid<CellType>,
) -> GraphMap<Coord, (), Undirected, FxBuildHasher> {
    let mut graph = GraphMap::<_, _, Undirected, FxBuildHasher>::default();

    for (coord, _) in grid
        .iter()
        .filter(|&(_, &celltype)| celltype == CellType::Safe)
    {
        // Add routes to non-danger neighbours
        for (neigh, _) in grid
            .iter_cardinal_neighbours(coord)
            .filter(|&(_, &celltype)| celltype == CellType::Safe)
        {
            graph.add_edge(coord, neigh, ());
        }
    }

    graph
}

fn part_one<const DIM: i64, const LINES_TO_READ: usize>(
    inp: &DataType<{ DIM }, { LINES_TO_READ }>,
) -> u64 {
    let graph = make_grid_into_graph(&inp.grid);
    let origin = Coord::from((0, 0));
    let destination = Coord::from((DIM, DIM));

    let dijk = petgraph::algo::dijkstra::dijkstra(
        &graph,
        origin,
        Some(destination),
        |_| 1,
    );

    *dijk.get(&destination).unwrap()
}

fn part_two<const DIM: i64, const LINES_TO_READ: usize>(
    inp: &DataType<{ DIM }, { LINES_TO_READ }>,
) -> String {
    let mut graph = make_grid_into_graph(&inp.grid);
    let origin = Coord::from((0, 0));
    let destination = Coord::from((DIM, DIM));

    for &next_byte in &inp.spare_bytes {
        // Delete related edges from the graph
        graph.remove_node(next_byte);

        let dijk = petgraph::algo::dijkstra::dijkstra(
            &graph,
            origin,
            Some(destination),
            |_| 1,
        );

        if !dijk.contains_key(&destination) {
            return format!("{},{}", next_byte.x, next_byte.y);
        }
    }

    panic!();
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let data: DataType<70, 1024> = PUZZLE_INPUT.parse()?;

    let start = Instant::now();
    let ans = part_one(&data);
    let elapsed = start.elapsed();
    println!("part one: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    let start = Instant::now();
    let ans = part_two(&data);
    let elapsed = start.elapsed();
    println!("part two: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0";

    #[test]
    fn test_part_1() {
        let inp: DataType<6, 12> = TEST_DATA.parse().unwrap();
        println!("{}", inp.grid);
        let ans = part_one(&inp);
        assert_eq!(ans, 22);
    }

    #[test]
    fn test_part_1_b() {
        let inp: DataType<70, 1024> = PUZZLE_INPUT.parse().unwrap();
        println!("{}", inp.grid);
        let ans = part_one(&inp);
        assert_eq!(ans, 382);
    }

    #[test]
    fn test_part_2() {
        let inp: DataType<6, 12> = TEST_DATA.parse().unwrap();
        assert_eq!(inp.spare_bytes.len(), 25 - 12);
        let ans = part_two(&inp);
        assert_eq!(ans, "6,1");
    }

    #[test]
    fn test_part_2_b() {
        let inp: DataType<70, 1024> = PUZZLE_INPUT.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, "6,36");
    }
}
