use color_eyre::Result;
use std::{str::FromStr, time::Instant};

const PUZZLE_INPUT: i32 = 325489;

struct DataType;

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(_inp: &str) -> std::result::Result<Self, Self::Err> {
        Ok(Self)
    }
}

fn find_loop_start_and_idx(inp: i32) -> (i32, i32) {
    for (idx, base) in (1_i32..100).step_by(2).enumerate() {
        let idx: i32 = idx.try_into().unwrap();
        if inp < base.pow(2) {
            return (idx - 1, base - 2);
        }
    }
    panic!()
}

/*
37  36  35  34  33  32  31
38  17  16  15  14  13  30
39  18   5   4   3  12  29
40  19   6   1   2  11  28
41  20   7   8   9  10  27
42  21  22  23  24  25  26
43  44  45  46  47  48  49
*/
fn part_one(inp: i32) -> i32 {
    // Loop starts on the biggest odd square smaller than the value
    let (loop_start, loop_idx) = find_loop_start_and_idx(inp);
    dbg!(inp, loop_start, loop_idx);

    // Side length is exactly the loop idx
    let distance_along_perimeter = inp - loop_start;
    dbg!(distance_along_perimeter);

    let coords_of_loop_start = ((loop_idx / 2), -(loop_idx / 2));

    // note that this implementation is for the wrong spiral, so it won't work
    let which_side = distance_along_perimeter / loop_idx;
    let distance_along_side = distance_along_perimeter % loop_idx;
    let number_position = match which_side {
        0 => (
            coords_of_loop_start.0,
            coords_of_loop_start.1 + distance_along_side,
        ),
        1 => (
            coords_of_loop_start.0 - distance_along_side,
            -coords_of_loop_start.1,
        ),
        2 => (
            -coords_of_loop_start.0,
            coords_of_loop_start.1 + loop_idx - distance_along_side,
        ),
        3 => (
            coords_of_loop_start.0 - loop_idx + distance_along_side,
            coords_of_loop_start.1,
        ),
        _ => panic!(),
    };

    dbg!(number_position);
    number_position.0.abs() + number_position.1.abs()
}

fn part_two(_inp: i32) -> u64 {
    0
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let data = PUZZLE_INPUT;

    let start = Instant::now();
    let ans = part_one(data);
    let elapsed = start.elapsed();
    println!("part one: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    let start = Instant::now();
    let ans = part_two(data);
    let elapsed = start.elapsed();
    println!("part two: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    #[ignore]
    fn test_part_1() {
        for &(value, expected) in
            &[(1, 0), (12, 3), (23, 2), (1024, 31), (PUZZLE_INPUT, 9999)]
        {
            let ans = part_one(value);
            assert_eq!(ans, expected);
        }
    }

    #[test]
    fn test_part_2() {
        let inp = 0;
        let ans = part_two(inp);
        assert_eq!(ans, 0);
    }
}
