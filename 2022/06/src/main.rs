use color_eyre::Result;
use std::collections::HashSet;

type DataType = [u8];

fn solve(inp: &DataType, length: usize) -> usize {
    inp.windows(length)
        .enumerate()
        .find(|(_, window)| {
            window.iter().collect::<HashSet<_>>().len() == length
        })
        .unwrap()
        .0
        + length
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_bytes!("../input.txt");
    let data = input;
    let ans = solve(&data[..], 4);
    println!("part one: {}", ans);
    let ans = solve(&data[..], 14);
    println!("part two: {}", ans);
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &[(&[u8], usize, usize)] = &[
        (b"mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7, 19),
        (b"bvwbjplbgvbhsrlpgdmjqwftvncz", 5, 23),
        (b"nppdvjthqldpwncqszvftbrmjlhg", 6, 23),
        (b"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10, 29),
        (b"zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11, 26),
    ];

    #[test]
    fn test_part_1() {
        for (inp, target, _) in TEST_DATA {
            let ans = solve(inp, 4);
            assert_eq!(ans, *target);
        }
    }

    #[test]
    fn test_part_2() {
        for (inp, _, target) in TEST_DATA {
            let ans = solve(inp, 14);
            assert_eq!(ans, *target);
        }
    }
}
