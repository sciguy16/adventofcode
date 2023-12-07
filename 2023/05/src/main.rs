#![feature(array_chunks)]

use color_eyre::Result;
use std::collections::HashMap;
use std::ops::Range;
use std::str::FromStr;

const MAP_LABELS: &[&str] = &[
    "soil",
    "fertiliser",
    "water",
    "light",
    "temperature",
    "humidity",
    "location",
];

#[derive(Default)]
struct DataType {
    seeds: Vec<i64>,
    maps: Vec<HashMap<Range<i64>, i64>>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut lines = inp.lines();
        let seeds = lines.next().unwrap();
        assert!(seeds.starts_with("seeds: "));
        let seeds = &seeds[7..];
        let seeds = seeds
            .split_whitespace()
            .map(str::parse)
            .collect::<Result<_, _>>()?;

        // empty line
        assert!(lines.next().unwrap().is_empty());

        let mut maps = Vec::with_capacity(MAP_LABELS.len());

        for label in MAP_LABELS {
            let header = lines.next().unwrap();
            assert!(header.ends_with(" map:"), "invalid header `{header}`");

            let mut map = HashMap::new();
            loop {
                let Some(line) = lines.next() else {
                    break;
                };
                if line.is_empty() {
                    break;
                }

                let mut components =
                    line.split_whitespace().map(str::parse::<i64>);
                let dest_start = components.next().unwrap()?;
                let src_start = components.next().unwrap()?;
                let len = components.next().unwrap()?;

                map.insert(src_start..src_start + len, dest_start - src_start);
            }
            println!("Loaded {} {} maps", map.len(), label);
            maps.push(map);
        }

        Ok(DataType { seeds, maps })
    }
}

fn part_one(inp: &DataType) -> i64 {
    inp.seeds
        .iter()
        .map(|&(mut value)| {
            // propagate number through all maps
            for (_label, map) in MAP_LABELS.iter().zip(&inp.maps) {
                let shift = map
                    .iter()
                    .find_map(|(range, &shift)| {
                        if range.contains(&value) {
                            Some(shift)
                        } else {
                            None
                        }
                    })
                    .unwrap_or_default();
                // dbg!((label, shift));
                value += shift;
            }

            value
        })
        .min()
        .unwrap()
}

fn part_two(inp: &DataType) -> i64 {
    let how_many_seeds = inp
        .seeds
        .array_chunks()
        .flat_map(|&[start, count]| (start..start + count))
        .count();
    // .collect::<Vec<_>>();
    dbg!(how_many_seeds);
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

    const TEST_DATA: &str = r#"seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 35);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 46);
    }
}
