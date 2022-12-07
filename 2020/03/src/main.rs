use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Debug)]
struct TreeMap {
    width: usize,
    height: usize,
    map: Vec<Vec<bool>>,
}

impl TreeMap {
    pub fn from_input(input: &[String]) -> Self {
        let width = input[0].len();
        let height = input.len();
        let mut map: Vec<Vec<bool>> = Vec::with_capacity(height);
        for line in input {
            let row = line
                .chars()
                .map(|c| match c {
                    '.' => false,
                    '#' => true,
                    x => panic!("Unexpected char: {}", x),
                })
                .collect::<Vec<bool>>();
            assert_eq!(row.len(), width);
            map.push(row);
        }

        Self { width, height, map }
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<String> =
        BufReader::new(file).lines().map(|x| x.unwrap()).collect();

    let map = TreeMap::from_input(&data);
    // Go right 3, down 1
    let (trees, empty) = part_one(&map, 1, 3);

    println!(
        "Hit {} trees, and {} empty spots. {} total = {} rows",
        trees,
        empty,
        trees + empty,
        map.height
    );

    let two = part_two(&map);
    println!("The product is: {two}");

    Ok(())
}

/// Returns (full_count, empty_count)
fn part_one(map: &TreeMap, vshift: usize, rshift: usize) -> (usize, usize) {
    let mut position: usize = 0;

    let mut empty_count: usize = 0;
    let mut full_count: usize = 0;

    for row in map.map.iter().step_by(vshift) {
        // Loop over the rows, incrementing the rightwards-shift counter
        // by the horizontal shift distance
        if row[position % map.width] {
            full_count += 1;
        } else {
            empty_count += 1;
        }

        position += rshift;
    }

    (full_count, empty_count)
}

fn part_two(map: &TreeMap) -> usize {
    //
    // Right 1, down 1.
    // Right 3, down 1. (This is the slope you already checked.)
    // Right 5, down 1.
    // Right 7, down 1.
    // Right 1, down 2.

    let cases = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)];

    let mut running_product: usize = 1;

    #[allow(clippy::uninlined_format_args)]
    for case in cases.iter() {
        let (trees, empty) = part_one(map, case.1, case.0);
        running_product *= trees;
        println!(
            "Case: {:?}: trees = {}, empty = {}, running product = {}",
            case, trees, empty, running_product
        );
    }
    running_product
}

#[cfg(test)]
mod test {
    use super::*;

    fn generate_test_map() -> TreeMap {
        let lines = [
            "..##.......".to_string(),
            "#...#...#..".to_string(),
            ".#....#..#.".to_string(),
            "..#.#...#.#".to_string(),
            ".#...##..#.".to_string(),
            "..#.##.....".to_string(),
            ".#.#.#....#".to_string(),
            ".#........#".to_string(),
            "#.##...#...".to_string(),
            "#...##....#".to_string(),
            ".#..#...#.#".to_string(),
        ];
        TreeMap::from_input(&lines)
    }

    #[test]
    fn test_part_one() {
        let map = generate_test_map();
        eprintln!("{map:?}");
        // Go right 3, down 1
        let (trees, empty) = part_one(&map, 1, 3);

        println!("Trees: {trees}, empty: {empty}");
        assert_eq!(trees, 7);
    }

    #[test]
    fn test_part_two() {
        let map = generate_test_map();
        let product_thing = part_two(&map);

        assert_eq!(product_thing, 336);
    }
}
