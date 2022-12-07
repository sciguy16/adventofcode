use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<usize> = BufReader::new(file)
        .lines()
        .map(|x| x.unwrap().parse().unwrap())
        .collect();

    let res = part_one(&data);
    println!("Magic number: {res}");

    Ok(())
}

fn part_one(data: &[usize]) -> usize {
    let mut adapters = data.to_vec();
    adapters.sort_unstable();

    // Make a chain of adapters with max. 3 jolts difference

    // Start with the source joltage
    let mut adapter_chain: Vec<usize> = vec![0];

    let mut current_joltage: usize = 0;

    for adapter in adapters {
        if adapter > current_joltage + 3 {
            // difference of 3 not met; abort
            println!("Joltage difference too big");
            break;
        }
        adapter_chain.push(adapter);
        current_joltage = adapter;
    }
    // get built-in adapter
    adapter_chain.push(adapter_chain.last().unwrap() + 3);

    //println!("Joltage chain: {:?}", adapter_chain);

    let (ones, threes) = differences(&adapter_chain);
    //println!("Ones: {}, threes: {}", ones, threes);

    ones * threes
}

fn differences(data: &[usize]) -> (usize, usize) {
    //let mut data_iterator = data.iter().peekable();
    let mut ones = 0;
    let mut threes = 0;
    for pairs in data.windows(2) {
        // while we haven't run out of iterator, check the differences
        match pairs[1] - pairs[0] {
            1 => ones += 1,
            3 => threes += 1,
            _ => {}
        }
    }

    (ones, threes)
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part_one_one() {
        let data = vec![16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4];
        let res = part_one(&data);
        assert_eq!(res, 7 * 5);
    }

    #[test]
    fn test_part_one_two() {
        let data = vec![
            28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39,
            11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3,
        ];
        let res = part_one(&data);
        assert_eq!(res, 22 * 10);
    }
}
