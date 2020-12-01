use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> Result<(), Box<dyn Error>> {
    let file = File::open("input.txt")?;
    let data: Vec<i32> = BufReader::new(file)
        .lines()
        .map(|x| x.unwrap().parse::<i32>().unwrap())
        .collect();

    if let Some(result) = do_part_one(&data) {
        println!(
            "{} and {} are valid! Product is: {}",
            result.0,
            result.1,
            result.0 * result.1,
        );
    } else {
        println!("No valid pairs found!");
    }

    if let Some(result) = do_part_two(&data) {
        println!(
            "{}, {} and {} are valid! Product is: {}",
            result.0,
            result.1,
            result.2,
            result.0 * result.1 * result.2,
        );
    } else {
        println!("No valid triples found!");
    }

    Ok(())
}

fn do_part_one(list: &[i32]) -> Option<(i32, i32)> {
    for elem in list.iter() {
        if list.contains(&(2020 - elem)) {
            return Some((*elem, 2020 - elem));
        }
    }
    None
}

fn do_part_two(list: &[i32]) -> Option<(i32, i32, i32)> {
    // Find 3 entries which sum to 2020
    for x in list.iter() {
        for y in list.iter() {
            if list.contains(&(2020 - x - y)) {
                return Some((*x, *y, 2020 - x - y));
            }
        }
    }

    None
}

#[cfg(test)]
mod test {
    use super::*;
    #[test]
    fn test_part_one() {
        let test_data = vec![1721, 979, 366, 299, 675, 1456];

        let result = do_part_one(&test_data);

        assert!(result.is_some());
        assert_eq!(result, Some((1721, 299)));
        let result = result.unwrap();
        assert_eq!(result.0 * result.1, 514579);
    }

    #[test]
    fn test_part_two() {
        let test_data = vec![1721, 979, 366, 299, 675, 1456];

        let result = do_part_two(&test_data).unwrap();

        assert_eq!(result.0 * result.1 * result.2, 241861950);
    }
}
