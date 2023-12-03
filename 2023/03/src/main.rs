use color_eyre::Result;
use ndarray::{Array, Array2};
use std::collections::HashSet;
#[cfg(test)]
use std::fmt::Write;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

const ROWS: usize = 140;
const COLS: usize = 140;

#[derive(Debug)]
struct DataType<const ROWS: usize, const COLS: usize>(Array2<char>);

impl<const ROWS: usize, const COLS: usize> FromStr for DataType<ROWS, COLS> {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let inner = Array::from_iter(inp.chars().filter(|&c| c != '\n'));
        let inner = inner.into_shape((ROWS, COLS))?;

        Ok(Self(inner))
    }
}

impl<const ROWS: usize, const COLS: usize> Display for DataType<ROWS, COLS> {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        writeln!(fmt, "    {}y", " ".repeat(COLS / 2))?;
        // col numbers
        writeln!(
            fmt,
            "     {}",
            (0..COLS)
                .map(|c| {
                    char::from_u32(((c % 10) + '0' as usize) as u32).unwrap()
                })
                .collect::<String>(),
        )?;
        for (idx, row) in self.0.rows().into_iter().enumerate() {
            write!(
                fmt,
                "{} {idx:02} ",
                if idx == ROWS / 2 { 'x' } else { ' ' }
            )?;
            for ch in row {
                write!(fmt, "{ch}")?;
            }
            writeln!(fmt)?;
        }
        Ok(())
    }
}

fn check_or_insert<const ROWS: usize, const COLS: usize>(
    set: &mut HashSet<(usize, usize)>,
    inp: &DataType<ROWS, COLS>,
    x: usize,
    mut y: usize,
) {
    // x is vertical, y is horizonal

    let inp = &inp.0;

    // only search if the adjacent char is a digit
    if inp[(x, y)].is_ascii_digit() {
        #[cfg(test)]
        print!("Position: ({x}, {y}) `{}`", inp[(x, y)]);
        // walk back to find the start of the number

        loop {
            if !inp[(x, y)].is_ascii_digit() {
                y += 1;
                break;
            }
            if let Some(res) = y.checked_sub(1) {
                y = res;
            } else {
                break;
            }
        }
        #[cfg(test)]
        println!(", start of num: ({x}, {y})");
        // x is now the position of the start of the number
        set.insert((x, y));
    }
}

fn check_surrounding<const ROWS: usize, const COLS: usize>(
    set: &mut HashSet<(usize, usize)>,
    inp: &DataType<ROWS, COLS>,
    x: usize,
    y: usize,
) {
    // row above
    if x > 0 {
        if y > 0 {
            check_or_insert(set, inp, x - 1, y - 1);
        }
        check_or_insert(set, inp, x - 1, y);
        if y < COLS {
            check_or_insert(set, inp, x - 1, y + 1);
        }
    }

    // current row
    if y > 0 {
        check_or_insert(set, inp, x, y - 1);
    }
    if y < COLS {
        check_or_insert(set, inp, x, y + 1);
    }

    // row below
    if x < ROWS {
        if y > 0 {
            check_or_insert(set, inp, x + 1, y - 1);
        }
        check_or_insert(set, inp, x + 1, y);
        if y < COLS {
            check_or_insert(set, inp, x + 1, y + 1);
        }
    }
}

fn read_number<const ROWS: usize, const COLS: usize>(
    inp: &DataType<ROWS, COLS>,
    x: usize,
    y: usize,
) -> u64 {
    let inp = &inp.0;
    let mut out = 0;

    let row = inp.row(x);
    for digit in row.iter().skip(y).copied().take_while(char::is_ascii_digit) {
        out *= 10;
        out += (digit as u64) - b'0' as u64;
    }

    out
}

fn part_one<const ROWS: usize, const COLS: usize>(
    inp: &DataType<ROWS, COLS>,
) -> u64 {
    #[cfg(test)]
    println!("{inp}");

    // search for symbols
    let symbol_coords = inp.0.indexed_iter().filter_map(|(idx, &ele)| {
        if ele.is_ascii_digit() || ele == '.' {
            // not a symbol
            None
        } else {
            // is a symbol
            Some(idx)
        }
    });

    // record coords of nearby numbers
    let mut number_coords = HashSet::new();
    for (x, y) in symbol_coords {
        check_surrounding(&mut number_coords, inp, x, y);
    }
    #[cfg(test)]
    println!(
        "part number positions: {}",
        number_coords
            .iter()
            .fold(String::new(), |mut output, (x, y)| {
                let _ = write!(&mut output, "({x}, {y}) ");
                output
            })
    );

    // Pull out the numbers
    let mut total = 0;
    for (x, y) in number_coords {
        total += read_number(inp, x, y);
    }

    total
}

fn part_two<const ROWS: usize, const COLS: usize>(
    inp: &DataType<ROWS, COLS>,
) -> u64 {
    // println!("{inp}");

    // search for gears
    let gear_coords = inp.0.indexed_iter().filter_map(|(idx, &ele)| {
        if ele == '*' {
            // is an asterisk
            Some(idx)
        } else {
            // not an asterisk
            None
        }
    });

    let mut all_relevant_gears = Vec::new();

    for (x, y) in gear_coords {
        let mut number_coords = HashSet::new();

        check_surrounding(&mut number_coords, inp, x, y);

        // number_coords now has the locations of all gears next to the
        // asterisk
        match number_coords.len() {
            0 => {}
            1 => {}
            2 => {
                all_relevant_gears.push(number_coords);
            }
            many => panic!("Too many gears: {many}"),
        }
    }

    // Pull out the numbers
    let mut total = 0;
    for ratio in all_relevant_gears {
        let prod = ratio
            .iter()
            .map(|&(x, y)| read_number(inp, x, y))
            .product::<u64>();
        total += prod;
    }

    total
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data: DataType<ROWS, COLS> = input.parse()?;
    let ans = part_one(&data);
    println!("part one: {}", ans);
    let ans = part_two(&data);
    println!("part two: {}", ans);
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const ROWS: usize = 10;
    const COLS: usize = 10;

    const TEST_DATA: &str = r#"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."#;

    #[test]
    fn test_part_1() {
        let inp: DataType<ROWS, COLS> = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 4361);
    }

    #[test]
    fn test_part_2() {
        let inp: DataType<ROWS, COLS> = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 467835);
    }
}
