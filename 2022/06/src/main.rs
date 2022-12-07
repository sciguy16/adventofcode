use color_eyre::Result;
use std::collections::HashSet;

fn solve(inp: &[u8], length: usize) -> usize {
    // reusing this allocation reduces the runtime from 1.8ms to 1.7ms
    let mut hashset = HashSet::<u8>::with_capacity(length);
    inp.windows(length)
        .enumerate()
        .find(|(_, window)| {
            hashset.clear();
            window.iter().for_each(|x| {
                hashset.insert(*x);
            });
            hashset.len() == length
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
    println!("part one: {ans}");
    let ans = solve(&data[..], 14);
    println!("part two: {ans}");
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
