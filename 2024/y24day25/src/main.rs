use color_eyre::Result;
use std::{str::FromStr, time::Instant};

const PUZZLE_INPUT: &str = include_str!("../input.txt");

struct DataType {
    locks: Vec<Keying>,
    keys: Vec<Keying>,
}

#[derive(Copy, Clone, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Keying {
    inner: [u8; 5],
}

impl From<[u8; 5]> for Keying {
    fn from(inner: [u8; 5]) -> Self {
        Self { inner }
    }
}

impl Keying {
    fn is_ok_with_key(self, key: Self) -> bool {
        self.inner
            .iter()
            .zip(key.inner)
            .all(|(lock_pin, key_pin)| *lock_pin <= 5 - key_pin)
    }
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut locks = Vec::new();
        let mut keys = Vec::new();

        let mut current = Vec::<u8>::new();
        for line in inp.lines().chain([""]) {
            if line.is_empty() {
                // process current
                let keying = (0..5)
                    .map(|idx| {
                        current
                            .iter()
                            .skip(idx)
                            .step_by(5)
                            .filter(|&&chr| chr == b'#')
                            .count() as u8
                            - 1
                    })
                    .collect::<Vec<_>>();
                assert_eq!(keying.len(), 5);

                let keying = Keying {
                    inner: keying.try_into().unwrap(),
                };

                if current[0] == b'#' {
                    locks.push(keying);
                } else {
                    keys.push(keying);
                }

                current.clear();
                continue;
            }

            current.extend(line.as_bytes().iter());
        }

        Ok(Self { locks, keys })
    }
}

fn part_one(inp: &DataType) -> u64 {
    let mut count = 0;

    for lock in &inp.locks {
        for &key in &inp.keys {
            count += lock.is_ok_with_key(key) as u64;
        }
    }

    count
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let data = PUZZLE_INPUT.parse()?;

    let start = Instant::now();
    let ans = part_one(&data);
    let elapsed = start.elapsed();
    println!("part one: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "\
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
";

    #[test]
    fn test_cmp() {
        assert!(
            !Keying::from([0, 5, 3, 4, 3])
                .is_ok_with_key(Keying::from([5, 0, 2, 1, 3])),
            "overlap in the last column.",
        );
        assert!(
            !Keying::from([0, 5, 3, 4, 3])
                .is_ok_with_key(Keying::from([4, 3, 4, 0, 2])),
            "overlap in the second column.",
        );
        assert!(
            Keying::from([0, 5, 3, 4, 3])
                .is_ok_with_key(Keying::from([3, 0, 2, 0, 1])),
            "all columns fit!",
        );
        assert!(
            !Keying::from([1, 2, 0, 5, 3])
                .is_ok_with_key(Keying::from([5, 0, 2, 1, 3])),
            "overlap in the first column.",
        );
        assert!(
            Keying::from([1, 2, 0, 5, 3])
                .is_ok_with_key(Keying::from([4, 3, 4, 0, 2])),
            "all columns fit!",
        );
        assert!(
            Keying::from([1, 2, 0, 5, 3])
                .is_ok_with_key(Keying::from([3, 0, 2, 0, 1])),
            "all columns fit!",
        );
    }

    #[test]
    fn test_part_1() {
        let inp: DataType = TEST_DATA.parse().unwrap();
        assert_eq!(
            inp.locks,
            [
                Keying {
                    inner: [0, 5, 3, 4, 3]
                },
                Keying {
                    inner: [1, 2, 0, 5, 3]
                }
            ]
        );
        assert_eq!(
            inp.keys,
            [
                Keying {
                    inner: [5, 0, 2, 1, 3]
                },
                Keying {
                    inner: [4, 3, 4, 0, 2]
                },
                Keying {
                    inner: [3, 0, 2, 0, 1]
                }
            ]
        );
        let ans = part_one(&inp);
        assert_eq!(ans, 3);
    }

    #[test]
    fn test_part_1_b() {
        let inp = PUZZLE_INPUT.parse().unwrap();
        let ans = part_one(&inp);
        assert_ne!(ans, 3664, "Your answer is too low");
        assert_eq!(ans, 3690);
    }
}
