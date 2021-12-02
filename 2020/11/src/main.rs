use ndarray::{Array2, Axis};
use std::error::Error;
use std::fmt::Display;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Clone, Debug, PartialEq)]
enum CellType {
    Seat(SeatState),
    Floor,
}

#[derive(Clone, Debug, PartialEq)]
enum SeatState {
    Free,
    Occupied,
}

#[derive(Clone, Debug)]
struct Automaton {
    grid: Array2<CellType>,
}

impl From<&[String]> for Automaton {
    fn from(inp: &[String]) -> Self {
        use CellType::*;
        use SeatState::*;
        // . is floor
        // L is empty
        // # is occupied
        let width = inp[0].len();
        let height = inp.len();

        println!("Initialising a {}x{} automaton", width, height);
        // (rows, cols)
        let mut grid =
            Array2::<CellType>::from_elem((height, width), CellType::Floor);

        for (src_row, mut dst_row) in
            inp.iter().zip(grid.axis_iter_mut(Axis(0)))
        {
            // Iterate over rows
            for (src, dst) in src_row.chars().zip(dst_row.iter_mut()) {
                //println!("src: {}, dst: {:?}", src, dst);
                *dst = match src {
                    '.' => Floor,
                    'L' => Seat(Free),
                    '#' => Seat(Occupied),
                    _ => panic!("Invalid character"),
                }
            }
        }

        Self { grid }
    }
}

impl Display for Automaton {
    fn fmt(
        &self,
        fmt: &mut std::fmt::Formatter<'_>,
    ) -> Result<(), std::fmt::Error> {
        use CellType::*;
        use SeatState::*;
        write!(
            fmt,
            "{}",
            self.grid
                .axis_iter(Axis(0))
                .map(|row| row
                    .iter()
                    .map(|ele| match ele {
                        Floor => ".",
                        Seat(Free) => "L",
                        Seat(Occupied) => "#",
                    })
                    .collect::<Vec<&'static str>>()
                    .join(""))
                .collect::<Vec<String>>()
                .join("\n")
        )
    }
}

impl Automaton {
    /// Evolves the state, returning a count of the number of changed entries
    pub fn evolve(&mut self) -> usize {
        use CellType::*;
        use SeatState::*;

        // Make a copy of the original state to reference while updating
        // the automaton state
        let old_state = self.clone();
        let mut change_count = 0;

        // # Rules:
        // 1) If a seat is empty (L) and there are no occupied seats
        //     adjacent to it, the seat becomes occupied.
        // 2) If a seat is occupied (#) and four or more seats adjacent to
        //     it are also occupied, the seat becomes empty.
        // 3) Otherwise, the seat's state does not change.

        // .get() returns None of the index is out of bounds, so we do
        // not need to do any bounds checking (although going negative
        // is probably bad because usize, right?)
        for (pos, ele) in self.grid.indexed_iter_mut() {
            //println!("{:?}: {:?}", pos, ele);
            let adjacent_seats = old_state.get_adjacent_seats(pos);
            if *ele == Seat(Free)
                && adjacent_seats.iter().any(|x| **x == Seat(Occupied))
            {
                // ^ Search for occupied seat, and confirm that none were found
                *ele = Seat(Occupied);
                change_count += 1;
                //println!("Rule 1");
            } else if *ele == Seat(Occupied)
                && adjacent_seats
                    .iter()
                    .filter(|x| ***x == Seat(Occupied))
                    .count()
                    >= 4
            {
                // ^ four or more occupied adjacent seats
                *ele = Seat(Free);
                change_count += 1;
                //println!("Rule 2");
            }
        }

        change_count
    }

    fn get_adjacent_seats(&self, pos: (usize, usize)) -> Vec<&CellType> {
        let mut adjacent = Vec::with_capacity(8);

        // Do all the bounds checking by hand rather than trying to be
        // smart with iterators

        if pos.0 > 0 && pos.1 > 0 {
            adjacent.push(self.get(pos.0 - 1, pos.1 - 1));
        }

        if pos.0 > 0 {
            adjacent.push(self.get(pos.0 - 1, pos.1));
        }

        if pos.1 > 0 {
            adjacent.push(self.get(pos.0, pos.1 - 1));
        }

        if pos.0 + 1 < self.nrows() && pos.1 + 1 < self.ncols() {
            adjacent.push(self.get(pos.0 + 1, pos.1 + 1));
        }

        if pos.0 + 1 < self.nrows() {
            adjacent.push(self.get(pos.0 + 1, pos.1));
        }

        if pos.1 + 1 < self.ncols() {
            adjacent.push(self.get(pos.0, pos.1 + 1))
        }

        if pos.0 > 0 && pos.1 + 1 < self.ncols() {
            adjacent.push(self.get(pos.0 - 1, pos.1 + 1));
        }

        if pos.0 + 1 < self.nrows() && pos.1 > 0 {
            adjacent.push(self.get(pos.0 + 1, pos.1 - 1));
        }

        adjacent
    }

    /// Evolves the state, returning a count of the number of changed entries
    pub fn evolve_2(&mut self) -> usize {
        use CellType::*;
        use SeatState::*;

        // Make a copy of the original state to reference while updating
        // the automaton state
        let old_state = self.clone();
        let mut change_count = 0;

        // # Rules:
        // 1) If a seat is empty (L) and there are no occupied seats
        //     adjacent to it, the seat becomes occupied.
        // 2) If a seat is occupied (#) and four or more seats adjacent to
        //     it are also occupied, the seat becomes empty.
        // 3) Otherwise, the seat's state does not change.

        // .get() returns None of the index is out of bounds, so we do
        // not need to do any bounds checking (although going negative
        // is probably bad because usize, right?)
        for (pos, ele) in self.grid.indexed_iter_mut() {
            //println!("{:?}: {:?}", pos, ele);
            let adjacent_seats =
                old_state.get_occupied_line_of_sight_count(pos);
            if *ele == Seat(Free) && adjacent_seats == 0 {
                // ^ Search for occupied seat, and confirm that none were found
                *ele = Seat(Occupied);
                change_count += 1;
                //println!("Rule 1");
            } else if *ele == Seat(Occupied) && adjacent_seats >= 5 {
                // ^ four or more occupied adjacent seats
                *ele = Seat(Free);
                change_count += 1;
                //println!("Rule 2");
            }
        }

        change_count
    }

    fn get_occupied_line_of_sight_count(&self, pos: (usize, usize)) -> usize {
        let mut count = 0;

        // Try the "adjacent seats" method above but with increasing
        // offsets each time
        for offset in 1..usize::MAX {
            if offset > pos.0
                || offset > pos.1
                || self.empty(pos.0 - offset, pos.1 - offset)
            {
                // Stop if out of bounds or empty seat
                break;
            }
            if self.occupied(pos.0 - offset, pos.1 - offset) {
                //println!("NW: occupied");
                count += 1;
                // Stop if we found one
                break;
            }
        }

        for offset in 1..usize::MAX {
            if offset > pos.0 || self.empty(pos.0 - offset, pos.1) {
                // Stop if out of bounds
                break;
            }
            if self.occupied(pos.0 - offset, pos.1) {
                //println!("N: occupied");
                count += 1;
                break;
            }
        }

        for offset in 1..usize::MAX {
            if offset > pos.1 || self.empty(pos.0, pos.1 - offset) {
                // Stop if out of bounds
                break;
            }
            if self.occupied(pos.0, pos.1 - offset) {
                //println!("W: occupied");
                count += 1;
                break;
            }
        }

        for offset in 1..usize::MAX {
            if pos.0 + offset > self.nrows()
                || pos.1 + offset >= self.ncols()
                || self.empty(pos.0 + offset, pos.1 + offset)
            {
                // Stop if out of bounds
                break;
            }
            if self.occupied(pos.0 + offset, pos.1 + offset) {
                //println!("SE: occupied");
                count += 1;
                break;
            }
        }

        for offset in 1..usize::MAX {
            if pos.0 + offset >= self.nrows()
                || self.empty(pos.0 + offset, pos.1)
            {
                // Stop if out of bounds
                break;
            }
            if self.occupied(pos.0 + offset, pos.1) {
                //println!("S: occupied");
                count += 1;
                break;
            }
        }

        for offset in 1..usize::MAX {
            if pos.1 + offset >= self.ncols()
                || self.empty(pos.0, pos.1 + offset)
            {
                // Stop if out of bounds
                break;
            }
            if self.occupied(pos.0, pos.1 + offset) {
                //println!("E: occupied");
                count += 1;
                break;
            }
        }

        for offset in 1..usize::MAX {
            if offset > pos.0
                || pos.1 + offset >= self.ncols()
                || self.empty(pos.0 - offset, pos.1 + offset)
            {
                // Stop if out of bounds
                break;
            }
            if self.occupied(pos.0 - offset, pos.1 + offset) {
                //println!("NE: occupied");
                count += 1;
                break;
            }
        }

        for offset in 1..usize::MAX {
            if pos.0 + offset > self.nrows()
                || offset > pos.1
                || self.empty(pos.0 + offset, pos.1 - offset)
            {
                // Stop if out of bounds
                //println!("SW: oob");
                break;
            }
            if self.occupied(pos.0 + offset, pos.1 - offset) {
                //println!("SW: occupied");
                count += 1;
                break;
            }
        }

        count
    }

    fn get(&self, x: usize, y: usize) -> &CellType {
        self.grid.get((x, y)).expect("Invalid grid index")
    }

    fn occupied(&self, x: usize, y: usize) -> bool {
        use CellType::Seat;
        use SeatState::Occupied;
        self.grid.get((x, y)) == Some(&Seat(Occupied))
    }

    fn empty(&self, x: usize, y: usize) -> bool {
        use CellType::Seat;
        use SeatState::Free;
        self.grid.get((x, y)) == Some(&Seat(Free))
    }

    fn nrows(&self) -> usize {
        self.grid.nrows()
    }

    fn ncols(&self) -> usize {
        self.grid.ncols()
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<String> =
        BufReader::new(file).lines().map(|x| x.unwrap()).collect();

    let automaton = Automaton::from(&data[..]);
    println!("Starting automaton:\n{}\n\n", automaton);

    let res = part_one(automaton.clone());
    println!("Part one: {}", res);

    let res = part_two(automaton);
    println!("Part two: {}", res);

    Ok(())
}

fn part_one(mut automaton: Automaton) -> usize {
    use CellType::*;
    use SeatState::*;

    // Try evolving until it reaches a stable state
    let mut iter_count = 0;
    while automaton.evolve() != 0 {
        iter_count += 1;
    }
    println!("Reached a stopping point after {} iterations!", iter_count);
    //println!("{}", automaton);

    // Count the occupied seats
    automaton
        .grid
        .iter()
        .filter(|ele| **ele == Seat(Occupied))
        .count()
}

fn part_two(mut automaton: Automaton) -> usize {
    use CellType::*;
    use SeatState::*;

    // Try evolving until it reaches a stable state
    let mut iter_count = 0;
    while automaton.evolve_2() != 0 {
        iter_count += 1;
    }
    println!("Reached a stopping point after {} iterations!", iter_count);
    //println!("{}", automaton);

    // Count the occupied seats
    automaton
        .grid
        .iter()
        .filter(|ele| **ele == Seat(Occupied))
        .count()
}

#[cfg(test)]
mod test {
    use super::*;

    fn test_automaton() -> Automaton {
        Automaton::from(
            &[
                "#.##.##.##",
                "#######.##",
                "#.#.#..#..",
                "####.##.##",
                "#.##.##.##",
                "#.#####.##",
                "..#.#.....",
                "##########",
                "#.######.#",
                "#.#####.##",
            ]
            .map(|x| x.to_string())[..],
        )
    }

    #[test]
    fn test_get_adjacent() {
        use CellType::*;
        use SeatState::*;
        let automaton = test_automaton();

        // Top-left corner
        let adjacent = automaton.get_adjacent_seats((0, 0));
        assert_eq!(adjacent, vec![&Seat(Occupied), &Seat(Occupied), &Floor]);

        // Bottom-left corner
        let adjacent = automaton.get_adjacent_seats((9, 0));
        assert_eq!(adjacent, vec![&Seat(Occupied), &Floor, &Floor]);

        // Place in the middle
        let adjacent = automaton.get_adjacent_seats((6, 6));
        assert_eq!(
            adjacent,
            vec![
                &Seat(Occupied),
                &Seat(Occupied),
                &Floor,
                &Seat(Occupied),
                &Seat(Occupied),
                &Floor,
                &Floor,
                &Seat(Occupied)
            ]
        );
    }

    #[test]
    #[ignore]
    fn test_part_one() {
        let automaton = test_automaton();

        println!("Automaton:\n{}", automaton);
        let res = part_one(automaton);

        assert_eq!(res, 37);
    }

    #[test]
    fn test_get_line_of_sight() {
        // This one can see 8 occupied seats
        let automaton = Automaton::from(
            &[
                ".......#.",
                "...#.....",
                ".#.......",
                ".........",
                "..#L....#",
                "....#....",
                ".........",
                "#........",
                "...#.....",
            ]
            .map(|x| x.to_string())[..],
        );
        println!("Seat in question: {:?}", automaton.get(4, 3));
        let occupied = automaton.get_occupied_line_of_sight_count((4, 3));
        assert_eq!(occupied, 8);

        // This one can see 0 occupied seats
        let automaton = Automaton::from(
            &[".............", ".L.L.#.#.#.#.", "............."]
                .map(|x| x.to_string())[..],
        );
        println!("Seat in question: {:?}", automaton.get(1, 1));
        let occupied = automaton.get_occupied_line_of_sight_count((1, 1));
        assert_eq!(occupied, 0);

        // This one can see 8 occupied seats
        let automaton = Automaton::from(
            &[
                ".##.##.", "#.#.#.#", "##...##", "...L...", "##...##",
                "#.#.#.#", ".##.##.",
            ]
            .map(|x| x.to_string())[..],
        );
        println!("Seat in question: {:?}", automaton.get(3, 3));
        let occupied = automaton.get_occupied_line_of_sight_count((3, 3));
        assert_eq!(occupied, 0);
    }

    #[test]
    #[ignore]
    fn test_part_two() {
        let automaton = test_automaton();

        println!("Automaton:\n{}", automaton);
        let res = part_two(automaton);

        assert_eq!(res, 26);
    }
}
