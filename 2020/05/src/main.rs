use std::convert::TryFrom;
use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(PartialEq)]
struct Seat {
    row: usize,
    col: usize,
}

impl Seat {
    pub fn id(&self) -> usize {
        self.row * 8 + self.col
    }
}

impl TryFrom<&str> for Seat {
    type Error = &'static str;
    fn try_from(inp: &str) -> std::result::Result<Self, &'static str> {
        if inp.len() != 10 {
            return Err("Wrong length");
        }

        let (row, col) = inp.split_at(7);

        let row = row.replace('F', "0").replace('B', "1");
        let col = col.replace('L', "0").replace('R', "1");

        let row = usize::from_str_radix(&row, 2).unwrap();
        let col = usize::from_str_radix(&col, 2).unwrap();

        Ok(Self { row, col })
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<String> =
        BufReader::new(file).lines().map(|x| x.unwrap()).collect();

    let seats: Vec<Seat> = data
        .iter()
        .map(|inp| Seat::try_from(inp.as_str()).unwrap())
        .collect();

    let res = part_one(&seats);
    println!("Largest seat ID: {}", res);

    let res = part_two(&seats);
    println!("Missing seat is: {}", res);

    Ok(())
}

fn part_one(seats: &[Seat]) -> usize {
    // Largest seat ID
    seats.iter().map(|s| s.id()).max().unwrap()
}

fn part_two(seats: &[Seat]) -> usize {
    // Find missing seat ID

    let mut have_found_seats_yet = false;

    for row in 0..=127 {
        for col in 0..=7 {
            let s = Seat { row, col };

            // run until find seats, and then find a gap
            if !seats.contains(&s) {
                if have_found_seats_yet {
                    return s.id();
                }
            } else {
                have_found_seats_yet = true;
            }
        }
    }

    panic!("No missing seat found");
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part_one() {
        let data = [
            ("FBFBBFFRLR", 44, 5, 357),
            ("BFFFBBFRRR", 70, 7, 567),
            ("FFFBBBFRRR", 14, 7, 119),
            ("BBFFBBFRLL", 102, 4, 820),
        ];

        for (pass, row, col, id) in data.iter() {
            let seat = Seat::try_from(*pass).unwrap();
            assert_eq!(seat.row, *row, "Wrong row");
            assert_eq!(seat.col, *col, "Wrong col");
            assert_eq!(seat.id(), *id, "Wrong id");
        }
    }
}
