use std::str::FromStr;

#[derive(Debug)]
struct CrabMarines(Vec<isize>);

impl FromStr for CrabMarines {
    type Err = Box<dyn std::error::Error>;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let inner = s
            .split(',')
            .map(|n| n.trim().parse::<isize>())
            //.inspect(|x| println!("{:?}", x))
            .collect::<Result<Vec<isize>, _>>()?;
        Ok(CrabMarines(inner))
    }
}

fn part_one(crabmarines: &CrabMarines) -> isize {
    println!("crabmarines: {:?}", crabmarines);
    let smallest = *crabmarines.0.iter().min().unwrap();
    let largest = *crabmarines.0.iter().max().unwrap();

    let mut least_fuel = isize::MAX;
    for pos in smallest..=largest {
        let pos: isize = pos.try_into().unwrap();
        let fuel = crabmarines.0.iter().map(|p| (*p - pos).abs()).sum();
        if fuel < least_fuel {
            println!("New best: {} uses {}", pos, fuel);
            least_fuel = fuel;
        }
    }

    least_fuel
}

fn part_two(crabmarines: &CrabMarines) -> isize {
    println!("crabmarines: {:?}", crabmarines);
    let smallest = *crabmarines.0.iter().min().unwrap();
    let largest = *crabmarines.0.iter().max().unwrap();

    let mut least_fuel = isize::MAX;
    for pos in smallest..=largest {
        let pos: isize = pos.try_into().unwrap();
        let fuel = crabmarines
            .0
            .iter()
            .map(|p| {
                let offset = (*p - pos).abs();
                offset * (offset + 1) / 2
            })
            .sum();
        if fuel < least_fuel {
            println!("New best: {} uses {}", pos, fuel);
            least_fuel = fuel;
        }
    }

    least_fuel
}

fn main() {
    println!("Hello, world!");
    let input = include_str!("../input.txt");

    let crabmarines: CrabMarines = input.parse().unwrap();
    let ans = part_one(&crabmarines);
    println!("part one: {}", ans);
    let ans = part_two(&crabmarines);
    println!("part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "16,1,2,0,4,2,7,1,2,14";

    #[test]
    fn test_part_one() {
        let crabmarines: CrabMarines = TEST_DATA.parse().unwrap();
        let ans = part_one(&crabmarines);
        assert_eq!(ans, 37);
    }

    #[test]
    fn test_part_two() {
        let crabmarines: CrabMarines = TEST_DATA.parse().unwrap();
        let ans = part_two(&crabmarines);
        assert_eq!(ans, 168);
    }
}
