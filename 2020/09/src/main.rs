use std::cmp::Ordering;
use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<u64> = BufReader::new(file)
        .lines()
        .map(|x| x.unwrap().parse::<u64>().unwrap())
        .collect();

    let res = part_one(&data, 25);
    println!("Got answer: {res}");

    let res2 = part_two(&data, res);
    println!("part 2: {res2}");

    Ok(())
}

fn part_one(data: &[u64], distance: usize) -> u64 {
    // make sure that there are at least distance+1 items for this to
    // make sense
    if data.len() < distance + 1 {
        panic!("Not enough numbers");
    }

    let mut biggest = 0;
    for index in distance..data.len() {
        print!("index: {index}\t");
        if data[index] > biggest
            && !number_can(&data[(index - distance)..=(index - 1)], data[index])
        {
            biggest = data[index];
            println!("got new biggest: {biggest}");

            println!("first number, actually");
            break;
        }
    }

    biggest
}

fn part_two(data: &[u64], target: u64) -> u64 {
    // find contiguous set of numbers that add up to target
    for start_idx in 0..data.len() {
        for length in 0..(data.len() - start_idx) {
            let slice = &data[start_idx..(start_idx + length + 1)];
            let sum: u64 = slice.iter().sum();
            match sum.cmp(&target) {
                Ordering::Equal => {
                    // we win
                    println!("Win: {slice:?}");
                    return *slice.iter().min().unwrap()
                        + *slice.iter().max().unwrap();
                }
                Ordering::Greater => break,
                _ => {}
            }
        }
    }
    todo!()
}

fn number_can(data: &[u64], number: u64) -> bool {
    //println!("data length: {}", data.len());

    /*if data.contains(&number) {
        println!("data: {:?}\nnumber: {}", data, number);
        panic!();
    }*/

    for test_num in data {
        if number >= *test_num
            && number != number - test_num
            && data.contains(&(number - test_num))
        {
            // number is a valid sum
            println!("{} + {} = {}", test_num, number - test_num, number);
            return true;
        }
    }

    // number is not a valid sum
    false
}

#[cfg(test)]
mod test {
    use super::*;

    fn test_data() -> Vec<u64> {
        vec![
            35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127,
            219, 299, 277, 309, 576,
        ]
    }

    #[test]
    fn test_part_one() {
        let data = test_data();

        let res = part_one(&data, 5);
        assert_eq!(res, 127);
    }

    #[test]
    fn test_part_two() {
        let data = test_data();
        let res = part_two(&data, 127);
        assert_eq!(res, 62);
    }
}
