use nalgebra::DMatrix;
use petgraph::algo::dijkstra;
use petgraph::Graph;
use std::str::FromStr;

struct CavernMatrix<const R: usize, const C: usize> {
    inner: DMatrix<u32>,
}

impl<const R: usize, const C: usize> FromStr for CavernMatrix<R, C> {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let m = DMatrix::from_iterator(
            C,
            R,
            s.chars().filter_map(|c| c.to_digit(10)),
        )
        .transpose();
        Ok(Self { inner: m })
    }
}

fn index(r: usize, c: usize) -> u32 {
    (r << 8 | c) as u32
}

fn reverse_index(i: u32) -> (usize, usize) {
    ((i >> 8) as usize, (i & 0xff) as usize)
}

struct CavernGraph<const R: usize, const C: usize> {
    inner: Graph<(usize, usize), u32>,
    cost_matrix: CavernMatrix<R, C>,
    dimension: usize,
}

impl<const R: usize, const C: usize> From<CavernMatrix<R, C>>
    for CavernGraph<R, C>
{
    fn from(mat: CavernMatrix<R, C>) -> Self {
        assert_eq!(R, C);
        // Only consider movements down and left, because any other
        // movement will be strictly longer than the shortest route

        let mut edges = Vec::<(u32, u32, u32)>::new();
        for r in 0..R {
            for c in 0..C {
                // insert edges from current (r, c) to the elements
                // immediately below and immediately right
                if r < R - 1 {
                    let cost_down = mat.inner[(r + 1, c)];
                    edges.push((index(r, c), index(r + 1, c), cost_down));
                }
                if c < C - 1 {
                    let cost_right = mat.inner[(r, c + 1)];
                    edges.push((index(r, c), index(r, c + 1), cost_right));
                }
            }
        }
        let inner = Graph::from_edges(edges.iter());
        Self {
            inner,
            cost_matrix: mat,
            dimension: R,
        }
    }
}

fn part_one<const R: usize, const C: usize>(
    graph: &CavernGraph<R, C>,
) -> usize {
    println!("{:?}", graph.inner);

    let start = index(0, 0);
    let end = index(graph.dimension - 1, graph.dimension - 1);
    let node_map =
        dijkstra(&graph.inner, start.into(), Some(end.into()), |e| {
            *e.weight()
        });
    println!("start: {start}, end: {end} = 0x{:x}", end);
    println!("node map: {:?}", node_map);
    let cost = *node_map.get(&end.into()).unwrap();
    println!("cost: {}", cost);
    assert!(cost < 368, "Your answer is too high");
    cost as usize
}

fn part_two<const R: usize, const C: usize>(_inp: &CavernGraph<R, C>) -> usize {
    0
}

fn main() {
    let input = include_str!("../input.txt");
    let data: CavernMatrix<100, 100> = input.parse().unwrap();
    let data = CavernGraph::from(data);
    let ans = part_one(&data);
    println!("part one: {}", ans);
    let ans = part_two(&data);
    println!("part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"#;

    #[test]
    fn test_part_1() {
        let inp: CavernMatrix<10, 10> = TEST_DATA.parse().unwrap();
        let graph = CavernGraph::from(inp);
        let ans = part_one(&graph);
        assert_eq!(ans, 40);
    }

    /*#[test]
    fn test_part_2() {
        let inp = TEST_DATA;
        let ans = part_two(inp);
        assert_eq!(ans, 4);
    }*/
}
