#![feature(array_chunks)]

use color_eyre::Result;
// use rayon::prelude::*;
use std::collections::HashMap;
use std::ops::Add;
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

/// Inclusive range
#[derive(Copy, Clone, Debug, Eq, PartialEq, Hash)]
struct Range {
    start: i64,
    end: i64,
}

impl Add<i64> for Range {
    type Output = Self;
    fn add(self, shift: i64) -> Self {
        Self {
            start: self.start + shift,
            end: self.end + shift,
        }
    }
}

impl Range {
    fn from_start_and_len(start: i64, len: i64) -> Self {
        Self {
            start,
            end: start + len,
        }
    }

    fn contains(&self, target: i64) -> bool {
        self.start <= target && target <= self.end
    }

    #[allow(dead_code)]
    fn overlap(&self, target: Self) -> bool {
        // either [ ( ] ) or [ ( ) ], either way one start or end point
        // will be within the other range
        self.contains(target.start)
            || self.contains(target.end)
            || target.contains(self.start)
            || target.contains(self.end)
    }

    // self is the mapping range
    #[allow(dead_code)]
    fn apply_map(&self, input: Self, shift: i64) -> Vec<Self> {
        let mut out = Vec::new();

        // map = [ ]
        // seed = ( )
        match (self.contains(input.start), self.contains(input.end)) {
            (true, true) => {
                // [ ( ) ]
                out.push(input + shift)
            }
            (true, false) => {
                // [ ( ] )
                // left half gets shifted
                //out.push()
            }
            (false, true) => {
                // ( [ ) ]
            }
            (false, false) => {
                // ( ) [ ]
                out.push(input)
            }
        }

        if input.contains(self.start) && input.contains(self.end) {
            // ( [ ] )
        }

        out
    }
}

#[derive(Default)]
struct DataType {
    seeds: Vec<i64>,
    maps: Vec<HashMap<Range, i64>>,
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

                map.insert(
                    Range::from_start_and_len(src_start, len),
                    dest_start - src_start,
                );
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
                        if range.contains(value) {
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

/// method
///
/// * Take as input a range (start, end)
/// * For each range in the maps:
///   - Check for overlaps and split the input range into 3 subranges:
///       1. fully smaller than target range
///       2. fully contained within target range
///       3. fully greater than target range
///   - break if any contained-in range was hit (hopefully this optimisation
///     is valid)
/// * at the end, take the smallest of the lower bounds
fn part_two(inp: &DataType) -> i64 {
    // 3m13 plain iter
    // even longer with rayon
    inp.seeds
        .array_chunks()
        .flat_map(|&[start, len]| (start..start + len))
        // .par_bridge()
        .map(|mut value| {
            // propagate number through all maps
            for map in &inp.maps {
                let shift = map
                    .iter()
                    .find_map(|(range, &shift)| {
                        if range.contains(value) {
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
    // inp.seeds
    //     .array_chunks()
    //     .map(|&[start, count]| {
    //         let mut seeds = vec![Range::from_start_and_len(start, count)];
    //         for map in &inp.maps {
    //             let mut tmp = Vec::new();
    //             for (candidate_map, shift) in map {
    //                 for seed in &seeds {
    //                     tmp.extend(candidate_map.apply_map(*seed, *shift));
    //                 }
    //             }
    //             seeds = tmp;
    //         }
    //         6
    //     })
    //     .min()
    //     .unwrap()
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data = input.parse()?;
    let ans = part_one(&data);
    assert_eq!(ans, 318728750);
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
    #[ignore]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 46);
    }

    #[test]
    fn test_contains() {
        let r = Range::from_start_and_len(10, 5);
        for n in 10..=15 {
            assert!(r.contains(n));
        }
        for n in (-10..10).chain(16..40) {
            assert!(!r.contains(n));
        }
    }

    #[test]
    fn test_overlap() {
        let p = Range::from_start_and_len(10, 5);
        let q = Range::from_start_and_len(12, 2);
        let r = Range::from_start_and_len(8, 4);
        let s = Range::from_start_and_len(14, 5);

        assert!(p.overlap(q));
        assert!(q.overlap(p));

        assert!(p.overlap(r));
        assert!(r.overlap(p));

        assert!(p.overlap(s));
        assert!(s.overlap(p));

        assert!(!r.overlap(s));
        assert!(!s.overlap(r));
    }

    #[test]
    fn range_add() {
        let r = Range::from_start_and_len(10, 5);
        let s = r + 4;
        assert_eq!(s.start, 14);
        assert_eq!(s.end, 19);
    }

    #[test]
    #[ignore]
    fn apply_map() {
        const SHIFT: i64 = 20;
        let m = Range::from_start_and_len(10, 5);

        // fully contained
        let p = Range::from_start_and_len(11, 2);
        let res = m.apply_map(p, SHIFT);
        assert_eq!(res, &[Range::from_start_and_len(11 + SHIFT, 2)]);

        // left overlap
        let q = Range::from_start_and_len(8, 4);
        let res = m.apply_map(q, SHIFT);
        assert_eq!(
            res,
            &[
                Range::from_start_and_len(8, 2),
                Range::from_start_and_len(10 + SHIFT, 2)
            ]
        );

        // right overlap
        let r = Range::from_start_and_len(14, 5);
        let res = m.apply_map(r, SHIFT);
        assert_eq!(
            res,
            &[
                Range::from_start_and_len(14 + SHIFT, 2),
                Range::from_start_and_len(16, 3)
            ]
        );

        // no overlap
        let s = Range::from_start_and_len(4, 3);
        let res = m.apply_map(s, SHIFT);
        assert_eq!(res, &[s]);

        // seed contains map
        let t = Range::from_start_and_len(8, 10);
        let res = m.apply_map(t, SHIFT);
        assert_eq!(
            res,
            &[
                Range::from_start_and_len(8, 2),
                Range::from_start_and_len(10 + SHIFT, 5),
                Range::from_start_and_len(15, 3),
            ]
        );
    }
}
