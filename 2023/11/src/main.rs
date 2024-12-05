// use color_eyre::Result;
// use std::str::FromStr;

// struct DataType {
//     galaxies: Vec<(usize, usize)>,
// }

// impl FromStr for DataType {
//     type Err = color_eyre::Report;

//     fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
//         let galaxies = inp
//             .lines()
//             .enumerate()
//             .flat_map(|(row, line)| {
//                 line.chars()
//                     .enumerate()
//                     .map(move |(col, chr)| (row, col, chr))
//             })
//             .filter(|&(_r, _c, chr)| chr == '#')
//             .map(|(r, c, _c)| (r, c))
//             .collect();

//         Ok(Self { galaxies })
//     }
// }

// impl DataType {
//     pub fn expand(&mut self) {
//         // expand ros
//     }
// }

// fn part_one(_inp: &DataType) -> u64 {
//     0
// }

// fn part_two(_inp: &DataType) -> u64 {
//     0
// }

// fn main() -> Result<()> {
//     color_eyre::install()?;
//     let input = include_str!("../input.txt");
//     let data = input.parse()?;
//     let ans = part_one(&data);
//     println!("part one: {}", ans);
//     let ans = part_two(&data);
//     println!("part two: {}", ans);
//     Ok(())
// }

// #[cfg(test)]
// mod test {
//     use super::*;

//     const TEST_DATA: &str = r#"...#......
// .......#..
// #.........
// ..........
// ......#...
// .#........
// .........#
// ..........
// .......#..
// #...#....."#;

//     #[test]
//     fn test_part_1() {
//         let inp = TEST_DATA.parse().unwrap();
//         let ans = part_one(&inp);
//         assert_eq!(ans, 374);
//     }

//     #[test]
//     fn test_part_2() {
//         let inp = TEST_DATA.parse().unwrap();
//         let ans = part_two(&inp);
//         assert_eq!(ans, 0);
//     }
// }
