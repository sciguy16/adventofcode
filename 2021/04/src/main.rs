use eyre::{eyre, Error};
use ndarray::prelude::*;
use owo_colors::OwoColorize;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

#[derive(Clone, Debug)]
struct BingoBoard {
    inner: Array2<(usize, bool)>,
}

impl From<[[usize; 5]; 5]> for BingoBoard {
    fn from(value: [[usize; 5]; 5]) -> Self {
        let flattened: Array1<(usize, bool)> = value
            .iter()
            .flat_map(|row| row.to_vec())
            .map(|ele| (ele, false))
            .collect();
        let inner = flattened.into_shape((5, 5)).unwrap();
        BingoBoard { inner }
    }
}

impl Display for BingoBoard {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        for row in self.inner.rows() {
            for col in row.iter() {
                if col.1 {
                    write!(fmt, "{:3}", col.0.green())?;
                } else {
                    write!(fmt, "{:3}", col.0.white())?;
                }
            }
            writeln!(fmt)?;
        }
        Ok(())
    }
}

impl BingoBoard {
    pub fn is_win(&self) -> bool {
        // win if all numbers is any row or column are marked
        for row in self.inner.rows() {
            if row.iter().all(|ele| ele.1) {
                return true;
            }
        }
        for col in self.inner.columns() {
            if col.iter().all(|ele| ele.1) {
                return true;
            }
        }
        false
    }

    pub fn mark(&mut self, number: usize) {
        for ele in self.inner.iter_mut() {
            if ele.0 == number {
                ele.1 = true;
            }
        }
    }

    pub fn score(&self, num: usize) -> usize {
        let sum = self
            .inner
            .iter()
            .filter_map(|ele| if !ele.1 { Some(ele.0) } else { None })
            .sum::<usize>();
        println!("Sum: {}, num: {}", sum, num);
        sum * num
    }
}

#[derive(Clone, Debug)]
struct BingoSubsystem {
    drawings: Vec<usize>,
    boards: Vec<BingoBoard>,
}

impl FromStr for BingoSubsystem {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut lines = s.lines();

        // First line is the drawing order
        let drawings = lines
            .next()
            .ok_or_else(|| eyre!("Insufficient lines"))?
            .split(',')
            .map(|n| n.parse::<usize>())
            .collect::<Result<Vec<usize>, _>>()?;

        // Skip blank line
        let _ = lines.next().ok_or_else(|| eyre!("Insufficient lines"))?;

        // The remainder of the input is blocks of 5 BingoBoard rows separated
        // by blank lines

        let mut boards = Vec::new();
        let mut rows = Vec::<[usize; 5]>::with_capacity(5);
        for line in lines {
            if line.len() < 5 {
                // reasonable proxy for "empty or just the newline char"
                let board: [[usize; 5]; 5] = rows.try_into().unwrap();
                boards.push(BingoBoard::from(board));
                rows = Vec::with_capacity(5);
            } else {
                // Parse into row of numbers and push into working storage
                rows.push(
                    line.split_whitespace()
                        .map(|n| n.parse::<usize>())
                        .collect::<Result<Vec<usize>, _>>()?
                        .try_into()
                        .unwrap(),
                );
            }
        }

        Ok(BingoSubsystem { drawings, boards })
    }
}

impl BingoSubsystem {
    pub fn a_winner(&self) -> Option<&BingoBoard> {
        for board in &self.boards {
            if board.is_win() {
                return Some(&board);
            }
        }
        None
    }

    pub fn mark(&mut self, number: usize) {
        for board in self.boards.iter_mut() {
            board.mark(number);
        }
    }

    pub fn filter_winners(&mut self) {
        self.boards.retain(|b| !b.is_win());
    }
}

fn part_one(subsystem: &BingoSubsystem) -> usize {
    let drawings = &subsystem.drawings;
    let mut subsystem = (*subsystem).clone();

    // if there is already a winner then exit
    if subsystem.a_winner().is_some() {
        panic!("Can't have a winner already");
    }

    // Loop over the drawings until a board wins
    for number in drawings {
        subsystem.mark(*number);
        print!("Number: {}, winner: ", number);
        if let Some(winner) = subsystem.a_winner() {
            println!("Found a winner:\n{}", winner);
            return winner.score(*number);
        } else {
            println!("false");
        }
    }

    panic!("No winner found");
}

fn part_two(subsystem: &BingoSubsystem) -> usize {
    let drawings = &subsystem.drawings;
    let mut subsystem = (*subsystem).clone();

    // if there is already a winner then exit
    if subsystem.a_winner().is_some() {
        panic!("Can't have a winner already");
    }

    println!("Start with {} boards", subsystem.boards.len().red());

    // Loop over the drawings until the final board wins
    for number in drawings {
        subsystem.mark(*number);
        if let Some(winner) = subsystem.a_winner() {
            // found a winner, if it's the last one then return its score,
            // otherwise remove it and continue
            if subsystem.boards.len() == 1 {
                println!("final winner:\n{}", winner);
                return winner.score(*number);
            } else {
                subsystem.filter_winners();
                println!(
                    "and then there were {}",
                    subsystem.boards.len().red()
                );
            }
        }
    }

    panic!("No winner found");
}

fn main() {
    let input = include_str!("../input.txt");
    let subsystem: BingoSubsystem = input.parse().unwrap();

    let ans = part_one(&subsystem);
    println!("part 1: {}", ans);

    let ans = part_two(&subsystem);
    println!("part 2: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7

"#;

    #[test]
    fn test_is_win() {
        let arr: [[usize; 5]; 5] = Default::default();
        let mut board = BingoBoard::from(arr);

        // starting board shouldn't be win
        assert!(!board.is_win());

        // fill a row
        for ele in board.inner.row_mut(1) {
            ele.1 = true;
        }

        assert!(board.is_win());

        //clear row and set column
        for ele in board.inner.row_mut(1) {
            ele.1 = false;
        }
        for ele in board.inner.column_mut(2) {
            ele.1 = true;
        }

        assert!(board.is_win());
    }

    #[test]
    fn test_mark() {
        let arr: [[usize; 5]; 5] = [[1, 2, 3, 4, 5]; 5];
        let mut board = BingoBoard::from(arr);

        assert_eq!(
            board.inner,
            array![
                [(1, false), (2, false), (3, false), (4, false), (5, false)],
                [(1, false), (2, false), (3, false), (4, false), (5, false)],
                [(1, false), (2, false), (3, false), (4, false), (5, false)],
                [(1, false), (2, false), (3, false), (4, false), (5, false)],
                [(1, false), (2, false), (3, false), (4, false), (5, false)],
            ]
        );

        board.mark(4);

        assert_eq!(
            board.inner,
            array![
                [(1, false), (2, false), (3, false), (4, true), (5, false)],
                [(1, false), (2, false), (3, false), (4, true), (5, false)],
                [(1, false), (2, false), (3, false), (4, true), (5, false)],
                [(1, false), (2, false), (3, false), (4, true), (5, false)],
                [(1, false), (2, false), (3, false), (4, true), (5, false)],
            ]
        );

        assert!(board.is_win());
    }

    #[test]
    fn test_part_one_forced() {
        let mut subsystem = TEST_DATA.parse::<BingoSubsystem>().unwrap();
        println!("{:?}", subsystem);
        assert_eq!(subsystem.boards.len(), 3);
        let numbers: &[usize] = &[14, 21, 17, 24, 4];
        for num in numbers {
            assert!(subsystem.a_winner().is_none());
            subsystem.mark(*num);
        }
        let _winner = subsystem.a_winner().unwrap();
    }

    #[test]
    fn test_part_one() {
        let subsystem = TEST_DATA.parse::<BingoSubsystem>().unwrap();
        let ans = part_one(&subsystem);
        assert_eq!(ans, 4512);
    }

    #[test]
    fn test_part_two() {
        let subsystem = TEST_DATA.parse::<BingoSubsystem>().unwrap();
        let ans = part_two(&subsystem);
        assert_eq!(ans, 1924);
    }
}
