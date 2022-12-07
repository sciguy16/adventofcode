use nalgebra::DMatrix;
use owo_colors::OwoColorize;
use std::collections::BTreeSet;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

#[derive(Debug, Clone)]
struct OctopusMap {
    inner: DMatrix<u8>,
}

impl FromStr for OctopusMap {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let inner = DMatrix::from_iterator(
            10,
            10,
            s.chars()
                .filter(|c| "0123456789".contains(*c))
                .map(|c| c.to_digit(10).unwrap() as u8),
        )
        .transpose();
        Ok(Self { inner })
    }
}

// based on impl_fmt! from nalgebra
// https://docs.rs/nalgebra/latest/src/nalgebra/base/matrix.rs.html#1899
impl Display for OctopusMap {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        let (nrows, ncols) = self.inner.shape();
        if nrows == 0 || ncols == 0 {
            return write!(fmt, "[ ]");
        }

        writeln!(fmt)?;
        writeln!(fmt, "  ┌ {:>width$} ┐", "", width = 2 * ncols - 1)?;
        for i in 0..nrows {
            write!(fmt, "  │")?;
            for j in 0..ncols {
                match self.inner[(i, j)] {
                    0 => write!(fmt, " {}", "0".yellow().bold())?,
                    n => write!(fmt, "{n:2}")?,
                }
            }
            writeln!(fmt, " │")?;
        }

        writeln!(fmt, "  └ {:>width$} ┘", "", width = 2 * ncols - 1)?;
        writeln!(fmt)
    }
}

impl OctopusMap {
    pub fn step(&mut self) -> usize {
        let mut flashes = 0;
        let mut has_flashed = BTreeSet::<(usize, usize)>::new();

        let (nrows, ncols) = self.inner.shape() as (usize, usize);

        // Increase the energy of each octopus by one
        self.inner.iter_mut().for_each(|ele| *ele += 1);

        let mut any_flashes = true;
        while any_flashes {
            // loop until they have stopped flashing
            any_flashes = false;
            for r in 0..nrows {
                for c in 0..ncols {
                    if self.inner[(r, c)] > 9 && !has_flashed.contains(&(r, c))
                    {
                        // jellyfish must flash and has not already
                        any_flashes = true;
                        flashes += 1;
                        has_flashed.insert((r, c));

                        // boost the surrounding chappos
                        // horizontal
                        if r > 0 {
                            self.inner[(r - 1, c)] += 1;
                        }
                        if r + 1 < nrows {
                            self.inner[(r + 1, c)] += 1;
                        }
                        // vertical
                        if c > 0 {
                            self.inner[(r, c - 1)] += 1;
                        }
                        if c + 1 < ncols {
                            self.inner[(r, c + 1)] += 1;
                        }
                        // diagonal
                        if r > 0 && c > 0 {
                            self.inner[(r - 1, c - 1)] += 1;
                        }
                        if r + 1 < nrows && c + 1 < ncols {
                            self.inner[(r + 1, c + 1)] += 1;
                        }
                        if r > 0 && c + 1 < ncols {
                            self.inner[(r - 1, c + 1)] += 1;
                        }
                        if r + 1 < nrows && c > 0 {
                            self.inner[(r + 1, c - 1)] += 1;
                        }
                    }
                }
            }
        }

        // Reset any octopus > 9 back to zero
        self.inner.iter_mut().for_each(|ele| {
            if *ele > 9 {
                *ele = 0
            }
        });

        flashes
    }

    pub fn all_zero(&self) -> bool {
        self.inner.iter().all(|ele| *ele == 0)
    }
}

fn part_one(map: &OctopusMap) -> usize {
    let mut map = map.clone();
    let mut flashes = 0;
    for step in 0..100 {
        flashes += map.step();
        println!("step {}: {}", step + 1, map);
    }
    flashes
}

fn part_two(map: &OctopusMap) -> usize {
    let mut map = map.clone();
    let mut count = 0;
    while !map.all_zero() {
        count += 1;
        map.step();
    }
    count
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
    use super::*;

    const TEST_DATA: &str = r#"5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        println!("{inp}");
        let ans = part_one(&inp);
        assert_eq!(ans, 1656);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 195);
    }
}
