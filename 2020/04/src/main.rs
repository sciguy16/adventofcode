use lazy_static::lazy_static;
use regex::Regex;
use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

lazy_static! {
    static ref HAIR_REGEX: Regex = Regex::new("^#[0-9a-f]{6}$").unwrap();
    static ref EYE_REGEX: Regex =
        Regex::new("^amb|blu|brn|gry|grn|hzl|oth$").unwrap();
    static ref PASSPORT_ID_REGEX: Regex = Regex::new("^[0-9]{9}$").unwrap();
}
///    byr (Birth Year)
///    iyr (Issue Year)
///    eyr (Expiration Year)
///    hgt (Height)
///    hcl (Hair Color)
///    ecl (Eye Color)
///    pid (Passport ID)
///    cid (Country ID)
#[derive(Clone, Debug, Default)]
struct Passport {
    birth_year: Option<u16>,
    issue_year: Option<u16>,
    expiration_year: Option<u16>,
    height: Option<String>,
    hair_colour: Option<String>,
    eye_colour: Option<String>,
    passport_id: Option<String>,
    country_id: Option<u16>,
}

impl Passport {
    pub fn is_valid_one(&self) -> bool {
        // Care about all fields except for country ID
        self.birth_year.is_some()
            && self.issue_year.is_some()
            && self.expiration_year.is_some()
            && self.height.is_some()
            && self.hair_colour.is_some()
            && self.eye_colour.is_some()
            && self.passport_id.is_some()
    }

    /// byr (Birth Year) - four digits; at least 1920 and at most 2002.
    /// iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    /// eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    /// hgt (Height) - a number followed by either cm or in:
    ///     If cm, the number must be at least 150 and at most 193.
    ///     If in, the number must be at least 59 and at most 76.
    /// hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    /// ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    /// pid (Passport ID) - a nine-digit number, including leading zeroes.
    /// cid (Country ID) - ignored, missing or not.
    pub fn is_valid_two(&self) -> bool {
        // byr (Birth Year) - four digits; at least 1920 and at most 2002.
        if let Some(y) = self.birth_year {
            if y < 1920 || y > 2002 {
                return false;
            }
        } else {
            return false;
        }

        // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
        if let Some(y) = self.issue_year {
            if y < 2010 || y > 2020 {
                return false;
            }
        } else {
            return false;
        }

        // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
        if let Some(y) = self.expiration_year {
            if y < 2020 || y > 2030 {
                return false;
            }
        } else {
            return false;
        }

        // hgt (Height) - a number followed by either cm or in:
        //     If cm, the number must be at least 150 and at most 193.
        //     If in, the number must be at least 59 and at most 76.
        match &self.height {
            Some(h) if h.ends_with("cm") => {
                let num: u8 = h.split("cm").next().unwrap().parse().unwrap();
                if num < 150 || num > 193 {
                    return false;
                }
            }
            Some(h) if h.ends_with("in") => {
                let num: u8 = h.split("in").next().unwrap().parse().unwrap();
                if num < 59 || num > 76 {
                    return false;
                }
            }
            _ => return false,
        }

        // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
        if let Some(colour) = &self.hair_colour {
            if !HAIR_REGEX.is_match(&colour) {
                return false;
            }
        } else {
            return false;
        }

        // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
        if let Some(colour) = &self.eye_colour {
            if !EYE_REGEX.is_match(&colour) {
                return false;
            }
        } else {
            return false;
        }

        // pid (Passport ID) - a nine-digit number, including leading zeroes.
        if let Some(id) = &self.passport_id {
            if !PASSPORT_ID_REGEX.is_match(&id) {
                return false;
            }
        } else {
            return false;
        }

        // cid (Country ID) - ignored, missing or not.

        true
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<String> =
        BufReader::new(file).lines().map(|x| x.unwrap()).collect();

    let passports = parse_passports(&data);
    let num_valid = part_one(&passports);
    println!("One: {} of {} are valid!", num_valid, passports.len());

    let num_valid = part_two(&passports);
    println!("Two: {} of {} are valid!", num_valid, passports.len());

    Ok(())
}

fn part_one(inp: &[Passport]) -> usize {
    inp.iter().filter(|p| p.is_valid_one()).count()
}

fn part_two(inp: &[Passport]) -> usize {
    inp.iter().filter(|p| p.is_valid_two()).count()
}

fn parse_passports(inp: &[String]) -> Vec<Passport> {
    let mut passports = Vec::new();
    let mut current_passport: Passport = Default::default();

    for line in inp {
        if line == "" {
            // Empty line separates entries
            println!("---");
            passports.push(current_passport.clone());
            current_passport = Default::default();
            continue;
        }
        for entry in line.split(' ') {
            println!("entry: {}", entry);
            // Split name and value from entry
            let mut entry_data = entry.split(':');
            let id = entry_data.next().unwrap();
            let value = entry_data.next().unwrap();
            match id {
                "byr" if current_passport.birth_year.is_none() => {
                    current_passport.birth_year = Some(value.parse().unwrap());
                }
                "iyr" if current_passport.issue_year.is_none() => {
                    current_passport.issue_year = Some(value.parse().unwrap());
                }
                "eyr" if current_passport.expiration_year.is_none() => {
                    current_passport.expiration_year =
                        Some(value.parse().unwrap());
                }
                "hgt" if current_passport.height.is_none() => {
                    current_passport.height = Some(value.to_string());
                }
                "hcl" if current_passport.hair_colour.is_none() => {
                    current_passport.hair_colour = Some(value.to_string());
                }
                "ecl" if current_passport.eye_colour.is_none() => {
                    current_passport.eye_colour = Some(value.to_string());
                }
                "pid" if current_passport.passport_id.is_none() => {
                    current_passport.passport_id = Some(value.to_string());
                }
                "cid" if current_passport.country_id.is_none() => {
                    current_passport.country_id = Some(value.parse().unwrap());
                }
                e => panic!("Unexpected name: {}", e),
            }
        }
    }
    passports
}

#[cfg(test)]
mod test {
    use super::*;

    fn test_data() -> Vec<String> {
        [
            "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
            "byr:1937 iyr:2017 cid:147 hgt:183cm",
            "",
            "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884",
            "hcl:#cfa07d byr:1929",
            "",
            "hcl:#ae17e1 iyr:2013",
            "eyr:2024",
            "ecl:brn pid:760753108 byr:1931",
            "hgt:179cm",
            "",
            "hcl:#cfa07d eyr:2025 pid:166559648",
            "iyr:2011 ecl:brn hgt:59in",
            "",
        ]
        .iter()
        .map(|l| l.to_string())
        .collect()
    }

    #[test]
    fn test_part_one() {
        let data = test_data();
        let passports = parse_passports(&data);
        assert_eq!(passports.len(), 4, "Wrong number of passports loaded");
        let num_valid = part_one(&passports);
        assert_eq!(num_valid, 2, "Wrong number of valid passports");
    }

    #[test]
    fn test_part_two_valid() {
        let data: Vec<String> = [
            "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980",
            "hcl:#623a2f",
            "",
            "eyr:2029 ecl:blu cid:129 byr:1989",
            "iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm",
            "",
            "hcl:#888785",
            "hgt:164cm byr:2001 iyr:2015 cid:88",
            "pid:545766238 ecl:hzl",
            "eyr:2022",
            "",
            "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021",
            "pid:093154719",
            "",
        ]
        .iter()
        .map(|l| l.to_string())
        .collect();

        let passports = parse_passports(&data);
        assert_eq!(passports.len(), 4, "Wrong number of passports loaded");

        for passport in passports {
            assert!(passport.is_valid_two());
        }
    }

    #[test]
    fn test_part_two_invalid() {
        let data: Vec<String> = [
            "eyr:1972 cid:100",
            "hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926",
            "",
            "iyr:2019",
            "hcl:#602927 eyr:1967 hgt:170cm",
            "ecl:grn pid:012533040 byr:1946",
            "",
            "hcl:dab227 iyr:2012",
            "ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277",
            "",
            "hgt:59cm ecl:zzz",
            "eyr:2038 hcl:74454a iyr:2023",
            "pid:3556412378 byr:2007",
            "",
        ]
        .iter()
        .map(|l| l.to_string())
        .collect();

        let passports = parse_passports(&data);
        assert_eq!(passports.len(), 4, "Wrong number of passports loaded");

        for passport in passports {
            assert!(!passport.is_valid_two());
        }
    }
}
