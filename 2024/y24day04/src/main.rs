use color_eyre::Result;
use ndarray::{Array2, Axis};
use std::str::FromStr;

const XMAS: [u8; 4] = *b"XMAS";
const SAMX: [u8; 4] = *b"SAMX";

struct DataType {
    inner: Array2<u8>,
    width: usize,
    height: usize,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let width = inp.lines().next().unwrap().len();
        let height = inp.lines().count();

        let inner: Vec<_> = inp
            .lines()
            .flat_map(|line| line.chars().map(|chr| u8::try_from(chr).unwrap()))
            .collect();

        Ok(Self {
            inner: Array2::from_shape_vec((height, width), inner)?,
            width,
            height,
        })
    }
}

fn rotate(xmas: &mut [u8; 4]) {
    xmas.rotate_left(1);
}

fn part_one(inp: &DataType) -> u64 {
    let mut count = 0;

    for lane in inp
        .inner
        .lanes(Axis(0))
        .into_iter()
        .chain(inp.inner.lanes(Axis(1)))
    {
        let mut window = [0x00; 4];
        for chr in lane {
            rotate(&mut window);
            *window.last_mut().unwrap() = *chr;
            if window == XMAS || window == SAMX {
                count += 1;
            }
        }
    }

    // do diagonals
    /*
    a b c d
    e f g h
    i j k l
    m n o p
    q r s t

    row=3,col=0

        */
    for start_row in 3..inp.height {
        for start_col in 0..(inp.width - 3) {
            let coord = (start_row, start_col);
            let diag = [
                *inp.inner.get(coord).unwrap(),
                *inp.inner.get((coord.0 - 1, coord.1 + 1)).unwrap(),
                *inp.inner.get((coord.0 - 2, coord.1 + 2)).unwrap(),
                *inp.inner.get((coord.0 - 3, coord.1 + 3)).unwrap(),
            ];
            // let diag_chars =
            //     diag.into_iter().map(char::from).collect::<String>();
            // dbg!(diag_chars);
            if diag == XMAS || diag == SAMX {
                count += 1;
            }
        }
    }

    for start_row in 0..(inp.height - 3) {
        for start_col in 0..(inp.width - 3) {
            let coord = (start_row, start_col);
            let diag = [
                inp.inner[coord],
                inp.inner[(coord.0 + 1, coord.1 + 1)],
                inp.inner[(coord.0 + 2, coord.1 + 2)],
                inp.inner[(coord.0 + 3, coord.1 + 3)],
            ];
            // let diag_chars =
            //     diag.into_iter().map(char::from).collect::<String>();
            // dbg!(coord, diag_chars);
            if diag == XMAS || diag == SAMX {
                count += 1;
            }
        }
    }

    count
}

fn part_two(inp: &DataType) -> u64 {
    let mut count = 0;

    let ms_sm = [[b'M', b'S'], [b'S', b'M']];

    for row in 1..(inp.height - 1) {
        for col in 1..(inp.width - 1) {
            let forward =
                [inp.inner[(row + 1, col - 1)], inp.inner[(row - 1, col + 1)]];
            let reverse =
                [inp.inner[(row + 1, col + 1)], inp.inner[(row - 1, col - 1)]];

            if inp.inner[(row, col)] == b'A'
                && ms_sm.contains(&forward)
                && ms_sm.contains(&reverse)
            {
                count += 1;
            }
        }
    }

    count
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

    const TEST_DATA: &str = "\
..X...
.SAMX.
.A..A.
XMAS.S
.X....";

    const TEST_DATA_FORWARD_WIDE: &str = "\
aaaSaS
aaAaAa
aMaMaa
XaXaaa";
    const TEST_DATA_FORWARD_TALL: &str = "\
aaaSa
aaAaS
aMaAa
XaMaa
aXaaa";

    const TEST_DATA_REVERSE_WIDE: &str = "\
XaXaaa
aMaMaa
aaAaAa
aaaSaS";

    const TEST_DATA_REVERSE_TALL: &str = "\
Xaaa
aMaa
XaAa
aMaS
aaAa
aaaS";

    const TEST_DATA_2: &str = "\
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX";

    #[test]
    fn test_rotate() {
        let mut xmas = [0, 1, 2, 3];
        rotate(&mut xmas);
        assert_eq!(xmas, [1, 2, 3, 0]);
    }

    #[test]
    fn test_forward_diagonals() {
        let inp = TEST_DATA_FORWARD_WIDE.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 2);

        let inp = TEST_DATA_FORWARD_TALL.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 2);
    }

    #[test]
    fn test_reverse_diagonals() {
        let inp = TEST_DATA_REVERSE_WIDE.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 2);

        let inp = TEST_DATA_REVERSE_TALL.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 2);
    }

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 4);

        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 18);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA_2.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 9);
    }
}
