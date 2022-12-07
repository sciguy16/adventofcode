use nalgebra::DMatrix;
use owo_colors::OwoColorize;
use std::collections::BTreeSet;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

#[derive(Debug)]
struct HeightMap<const R: usize, const C: usize>(DMatrix<u32>);

impl<const R: usize, const C: usize> FromStr for HeightMap<R, C> {
    type Err = Box<dyn std::error::Error>;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let m = DMatrix::from_iterator(
            C,
            R,
            s.chars()
                .filter(|c| "0123456789".contains(*c))
                .map(|c| c.to_digit(10).unwrap()),
        )
        .transpose();
        Ok(HeightMap(m))
    }
}

impl<const R: usize, const C: usize> Display for HeightMap<R, C> {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        write!(fmt, "{}", self.0)
    }
}

impl<const R: usize, const C: usize> HeightMap<R, C> {
    pub fn minima(&self) -> Vec<(u32, (usize, usize))> {
        let mut min = Vec::new();
        for r in 0..R {
            for c in 0..C {
                // compare each element to the element immediately above,
                // below, left, or right of it
                let mut smallest = true;
                let mut surrounding = [' '; 4];
                if r > 0 {
                    smallest &= self.0[(r, c)] < self.0[(r - 1, c)];
                    surrounding[0] =
                        char::from_digit(self.0[(r - 1, c)], 10).unwrap();
                }
                if r < R - 1 {
                    smallest &= self.0[(r, c)] < self.0[(r + 1, c)];
                    surrounding[1] =
                        char::from_digit(self.0[(r + 1, c)], 10).unwrap();
                }
                if c > 0 {
                    smallest &= self.0[(r, c)] < self.0[(r, c - 1)];
                    surrounding[2] =
                        char::from_digit(self.0[(r, c - 1)], 10).unwrap();
                }
                if c < C - 1 {
                    smallest &= self.0[(r, c)] < self.0[(r, c + 1)];
                    surrounding[3] =
                        char::from_digit(self.0[(r, c + 1)], 10).unwrap();
                }
                if smallest {
                    let ele = self.0[(r, c)];
                    println!("                  {}", surrounding[0]);
                    println!(
                        "Found local min: {}{}{}",
                        surrounding[2],
                        ele.yellow(),
                        surrounding[3]
                    );
                    println!("                  {}", surrounding[1]);
                    min.push((ele, (r, c)));
                }
            }
        }
        println!("Found {} minima!", min.len().blue().bold());
        min
    }

    pub fn basin_sizes(&self) -> Vec<usize> {
        let minima = self.minima();
        let mut basins = Vec::with_capacity(minima.len());
        let hm = &self.0;

        for (_h, (r, c)) in minima {
            let mut seen = BTreeSet::<(usize, usize)>::new();
            // Push minimum point into to_check
            let mut to_check = vec![(r, c)];
            // For point in `to_check`, push into `seen` and then look
            // at the four points around it. If a point is greater than
            // current and not in `seen` and not 9 then push it into
            // `to_check`
            // if `to_check` is empty then break and push the basin size
            // (`seen`.len()) to `basins`
            loop {
                if to_check.is_empty() {
                    break;
                }

                let (r, c) = to_check.pop().unwrap();
                seen.insert((r, c));
                let h = hm[(r, c)];
                if r > 0
                    && (h..9).contains(&hm[(r - 1, c)])
                    && !seen.contains(&(r - 1, c))
                {
                    to_check.push((r - 1, c));
                }
                if r < R - 1
                    && (h..9).contains(&hm[(r + 1, c)])
                    && !seen.contains(&(r + 1, c))
                {
                    to_check.push((r + 1, c));
                }
                if c > 0
                    && (h..9).contains(&hm[(r, c - 1)])
                    && !seen.contains(&(r, c - 1))
                {
                    to_check.push((r, c - 1));
                }
                if c < C - 1
                    && (h..9).contains(&hm[(r, c + 1)])
                    && !seen.contains(&(r, c + 1))
                {
                    to_check.push((r, c + 1));
                }
            }
            basins.push(seen.len());
        }

        basins
    }
}

fn part_one<const R: usize, const C: usize>(hm: &HeightMap<R, C>) -> u32 {
    let minima = hm.minima();
    // risk is 1 + height
    minima.iter().map(|(r, _)| 1 + r).sum()
}

fn part_two<const R: usize, const C: usize>(hm: &HeightMap<R, C>) -> usize {
    let mut basin_sizes = hm.basin_sizes();
    basin_sizes.sort_unstable();
    basin_sizes.reverse();
    println!("basins: {basin_sizes:?}");
    basin_sizes.iter().take(3).product()
}

fn main() {
    println!("Hello, world!");
    let input = include_str!("../input.txt");
    let hm: HeightMap<100, 100> = input.parse().unwrap();
    let ans = part_one(&hm);
    println!("part one: {ans}");
    let ans = part_two(&hm);
    println!("part two: {ans}");
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"2199943210
3987894921
9856789892
8767896789
9899965678"#;

    #[test]
    fn test_part_1() {
        let hm: HeightMap<5, 10> = TEST_DATA.parse().unwrap();
        println!("{}", hm);
        let ans = part_one(&hm);
        assert_eq!(ans, 15);
    }

    #[test]
    fn test_part_2() {
        let hm: HeightMap<5, 10> = TEST_DATA.parse().unwrap();
        println!("{}", hm);
        let ans = part_two(&hm);
        assert_eq!(ans, 1134);
    }
}
