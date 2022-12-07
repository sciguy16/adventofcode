use lazy_static::lazy_static;
use regex::Regex;
use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Debug)]
struct PasswordPolicy {
    letter: char,
    min_occurrences: usize,
    max_occurrences: usize,
}

impl PasswordPolicy {
    pub fn is_valid(&self, password: &str) -> bool {
        let count = password.matches(self.letter).count();
        count >= self.min_occurrences && count <= self.max_occurrences
    }

    pub fn is_valid_two(&self, password: &str) -> bool {
        if self.min_occurrences > password.len()
            || self.max_occurrences > password.len()
        {
            // numbers make no sense
            println!("ERROR ERROR ERROR");
            return false;
        }

        let password_vec: Vec<char> = password.chars().collect();
        let first_letter = password_vec[self.min_occurrences - 1];
        let second_letter = password_vec[self.max_occurrences - 1];

        let result = (first_letter == self.letter
            || second_letter == self.letter)
            && (first_letter != second_letter);

        println!(
            "Letters ({}, {}) = {} from '{}': {} {}: {}",
            self.min_occurrences,
            self.max_occurrences,
            self.letter,
            password,
            first_letter,
            second_letter,
            result
        );

        result
    }
}

lazy_static! {
    static ref PASSWORD_POLICY_REGEX: Regex =
        Regex::new("^([0-9]+)-(\\d+) ([a-z]): ([a-z]+)$").unwrap();
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<String> =
        BufReader::new(file).lines().map(|x| x.unwrap()).collect();

    let count = part_one(&data);
    println!("Number of valid passwords: {count}");

    let count = part_two(&data);
    println!("New number of valid passwords: {count}");

    Ok(())
}

fn part_one(lines: &[String]) -> usize {
    lines
        .iter()
        .map(|l| parse_password_policy(l).unwrap())
        .filter(|(policy, pass)| policy.is_valid(pass))
        .count()
}

fn part_two(lines: &[String]) -> usize {
    lines
        .iter()
        .map(|l| parse_password_policy(l).unwrap())
        .filter(|(policy, pass)| policy.is_valid_two(pass))
        .count()
}

/// Parse a password policy line, returning a pair of the password
/// policy and the associated password
fn parse_password_policy(line: &str) -> Option<(PasswordPolicy, &str)> {
    PASSWORD_POLICY_REGEX.captures_iter(line).find_map(|cap| {
        let groups = (cap.get(1), cap.get(2), cap.get(3), cap.get(4));
        match groups {
            (
                Some(min_occurrences),
                Some(max_occurrences),
                Some(letter),
                Some(pass),
            ) => Some((
                PasswordPolicy {
                    letter: letter.as_str().chars().next().unwrap(),
                    min_occurrences: min_occurrences.as_str().parse().unwrap(),
                    max_occurrences: max_occurrences.as_str().parse().unwrap(),
                },
                pass.as_str(),
            )),
            _ => None,
        }
    })
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_parse() {
        let line = "1-3 a: abcde";

        let (pol, pass) = parse_password_policy(line).unwrap();

        assert_eq!(pol.letter, 'a');
        assert_eq!(pol.min_occurrences, 1);
        assert_eq!(pol.max_occurrences, 3);
        assert_eq!(pass, "abcde".to_string());
    }

    #[test]
    fn run_part_one() {
        let data = vec![
            "1-3 a: abcde".to_string(),
            "1-3 b: cdefg".to_string(),
            "2-9 c: ccccccccc".to_string(),
        ];
        let count = part_one(&data);

        assert_eq!(count, 2);
    }

    #[test]
    fn run_part_2() {
        let data = vec![
            "1-3 a: abcde".to_string(),
            "1-3 b: cdefg".to_string(),
            "2-9 c: ccccccccc".to_string(),
        ];
        let count = part_two(&data);

        assert_eq!(count, 1);
    }
}
