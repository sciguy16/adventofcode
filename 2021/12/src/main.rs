use itertools::Itertools;
use petgraph::algo;
use petgraph::graph::{Graph, NodeIndex};
use std::collections::BTreeMap;
use std::str::FromStr;

struct Cave {
    inner: Graph<String, ()>,
    map: BTreeMap<String, NodeIndex<u32>>,
}

impl FromStr for Cave {
    type Err = Box<dyn std::error::Error>;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut map = BTreeMap::new();

        let mut inner = Graph::new();

        for l in s.lines() {
            let (start, end): (String, String) =
                l.split('-').map(String::from).collect_tuple().unwrap();
            let start = if let Some(node) = map.get(&start) {
                *node
            } else {
                let node = inner.add_node(start.clone());
                map.insert(start, node);
                node
            };
            let end = if let Some(node) = map.get(&end) {
                *node
            } else {
                let node = inner.add_node(end.clone());
                map.insert(end, node);
                node
            };
            //edges.push((start, end));
            inner.add_edge(start, end, ());
        }

        // let inner = Graph::from_edges(&edges);
        Ok(Cave { inner, map })
    }
}

enum CaveSize {
    Small,
    Large,
}

impl FromStr for CaveSize {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if s.chars().all(|c| c.is_uppercase()) {
            Ok(CaveSize::Large)
        } else if s.chars().all(|c| c.is_lowercase()) {
            Ok(CaveSize::Small)
        } else {
            Err(())
        }
    }
}

fn part_one(cave: &Cave) -> usize {
    let start = *cave.map.get("start").unwrap();
    let end = *cave.map.get("end").unwrap();
    let _spaths =
        algo::all_simple_paths::<Vec<_>, _>(&cave.inner, start, end, 1, None)
            .collect::<Vec<_>>();

    // let path_count = 0;

    // path_count
    0
}

fn part_two(_inp: &Cave) -> usize {
    todo!()
}

fn main() {
    let input = include_str!("../input.txt");
    let data = input.parse().unwrap();
    let ans = part_one(&data);
    println!("part one: {ans}");
    let ans = part_two(&data);
    println!("part two: {ans}");
}

#[cfg(test)]
mod test {
    #![allow(dead_code)]
    use super::*;

    const TEST_DATA_1: &str = r#"start-A
start-b
A-c
A-b
b-d
A-end
b-end"#;

    //#[test]
    fn test_part_1() {
        let inp = TEST_DATA_1.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 4);
    }

    //#[test]
    fn test_part_2() {
        let inp = TEST_DATA_1.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 4);
    }
}
