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
        }
    }
    println!("{trees}");

    // down right side
    for row in 0..N {
        let mut biggest = -1;
        // go along row looking for trees
        for tree in trees.inner[row].iter_mut().rev() {
            if tree.0 > biggest {
                tree.1 = true;
                biggest = tree.0;
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
        }
    }
    // println!("{trees}");

    // along bottom edge
    for col in 0..N {
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

fn part_two<const N: usize>(_inp: &DataType<N>) -> u64 {
    0
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
        assert_eq!(ans, 0);
    }
}
