use color_eyre::Result;
use owo_colors::OwoColorize;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

type Integer = i8;

#[derive(Clone, Debug)]
struct DataType<const N: usize> {
    inner: [[(Integer, bool); N]; N],
}

impl<const N: usize> Display for DataType<N> {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        writeln!(fmt, "Trees {{")?;
        for row in self.inner {
            write!(fmt, " ")?;
            for col in row {
                if col.1 {
                    write!(fmt, " {}", col.0.yellow())?;
                } else {
                    write!(fmt, " {}", col.0.red())?;
                }
            }
            writeln!(fmt)?;
        }
        writeln!(fmt, "}}")
    }
}

impl<const N: usize> FromStr for DataType<{ N }> {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let inner = inp
            .lines()
            .map(str::trim)
            .map(|r| {
                r.chars()
                    .map(|c| (c as Integer - b'0' as Integer, false))
                    .collect::<Vec<(Integer, bool)>>()
                    .try_into()
                    .unwrap()
            })
            .collect::<Vec<_>>()
            .try_into()
            .unwrap();

        Ok(Self { inner })
    }
}

impl<const N: usize> DataType<N> {
    pub fn scenic_score(&self, row: usize, col: usize) -> usize {
        // this is only called for trees strictly within the forest - not for
        // trees on the edges. Hence no need to consider... "edge" cases
        let height = self.inner[row][col].0;

        let mut left = 0;
        for c in (0..col).rev() {
            left += 1;
            if self.inner[row][c].0 >= height {
                break;
            }
        }

        let mut right = 0;
        for c in (col + 1)..N {
            right += 1;
            if self.inner[row][c].0 >= height {
                break;
            }
        }

        let mut up = 0;
        for r in (0..row).rev() {
            up += 1;
            if self.inner[r][col].0 >= height {
                break;
            }
        }

        let mut down = 0;
        for r in (row + 1)..N {
            down += 1;
            if self.inner[r][col].0 >= height {
                break;
            }
        }

        // println!("Position ({row}, {col}) has l: {left} d: {down} r: {right} u: {up}");

        left * right * up * down
    }
}

fn part_one<const N: usize>(inp: &DataType<N>) -> usize {
    let mut trees = inp.clone();
    // println!("{trees}");

    // down left side
    for row in 0..N {
        let mut biggest = -1;
        // go along row looking for trees
        for tree in trees.inner[row].iter_mut() {
            if tree.0 > biggest {
                tree.1 = true;
                biggest = tree.0;
            }
            // this optimisation doesn't save very much so maybe it's not worth
            // doing
            if biggest >= 9 {
                break;
            }
        }
        //}
        //println!("{trees}");

        // down right side
        //for row in 0..N {
        let mut biggest = -1;
        // go along row looking for trees
        for tree in trees.inner[row].iter_mut().rev() {
            if tree.0 > biggest {
                tree.1 = true;
                biggest = tree.0;
            }
            if biggest >= 9 {
                break;
            }
        }
    }
    // println!("{trees}");

    // along top edge
    for col in 0..N {
        let mut biggest = -1;
        for tree in trees.inner.iter_mut().map(|row| row.get_mut(col).unwrap())
        {
            if tree.0 > biggest {
                tree.1 = true;
                biggest = tree.0;
            }
            if biggest >= 9 {
                break;
            }
        }
        //}
        // println!("{trees}");

        // along bottom edge
        //for col in 0..N {
        let mut biggest = -1;
        for tree in trees
            .inner
            .iter_mut()
            .map(|row| row.get_mut(col).unwrap())
            .rev()
        {
            if tree.0 > biggest {
                tree.1 = true;
                biggest = tree.0;
            }
            if biggest >= 9 {
                break;
            }
        }
    }
    // println!("{trees}");

    // count the visible trees
    trees
        .inner
        .iter()
        .flat_map(|row| row.iter())
        .filter(|tree| tree.1)
        .count()
}

fn part_two<const N: usize>(inp: &DataType<N>) -> usize {
    // go through all of the trees to work out their viewing distances
    // can ignore the edge trees because they have viewing distance of zero
    let mut highest_scenic_score: usize = 0;

    for row in 1..(N - 1) {
        for col in 1..(N - 1) {
            let score = inp.scenic_score(row, col);
            if score > highest_scenic_score {
                highest_scenic_score = score;
            }
        }
    }

    highest_scenic_score
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data: DataType<99> = input.parse()?;
    let ans = part_one(&data);
    println!("part one: {ans}");
    let ans = part_two(&data);
    println!("part two: {ans}");
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"30373
25512
65332
33549
35390
"#;

    #[test]
    fn test_part_1() {
        let inp: DataType<5> = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 21);
    }

    #[test]
    fn test_part_2() {
        let inp: DataType<5> = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 8);
    }
}
