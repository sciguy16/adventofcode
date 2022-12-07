use std::collections::HashSet;
use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

type Form = HashSet<char>;

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<String> =
        BufReader::new(file).lines().map(|x| x.unwrap()).collect();

    let forms = parse_forms(&data).unwrap();
    let res = count_them(&forms);
    println!("Sum of answers is: {res}");

    let forms = parse_forms_2(&data).unwrap();
    let res = count_them(&forms);
    println!("Sum of answers part 2 is: {res}");
    Ok(())
}

fn count_them(forms: &[Form]) -> usize {
    let mut sum: usize = 0;

    for form in forms {
        sum += form.len();
    }

    sum
}

fn parse_forms(inp: &[String]) -> Result<Vec<Form>, &'static str> {
    let mut form: Form = Default::default();
    let mut forms: Vec<Form> = Default::default();

    for line in inp {
        if line.is_empty() {
            println!("---");
            forms.push(form);
            form = Default::default();
            continue;
        }

        for chr in line.chars() {
            if !('a'..='z').contains(&chr) {
                return Err("Invalid letter found");
            }
            print!("{chr}");
            form.insert(chr);
        }
    }

    Ok(forms)
}

fn parse_forms_2(inp: &[String]) -> Result<Vec<Form>, &'static str> {
    let mut form: Form = Default::default();
    let mut forms: Vec<Form> = Vec::new();
    let mut groups: Vec<Form> = Default::default();

    for line in inp {
        if line.is_empty() {
            println!("groups: {groups:?}");
            form = groups
                .iter()
                .cloned()
                .reduce(|x, y| x.intersection(&y).cloned().collect::<Form>())
                .or_else(|| Some(Form::new()))
                .to_owned()
                .unwrap();
            println!("---{form:?}");
            forms.push(form);
            form = Default::default();
            groups = Default::default();
            continue;
        }

        println!();
        for chr in line.chars() {
            if !('a'..='z').contains(&chr) {
                return Err("Invalid letter found");
            }
            print!("{chr}");
            form.insert(chr);
        }
        groups.push(form);
        form = Default::default();
    }
    Ok(forms)
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part_one() {
        let data: Vec<String> = [
            "abc", "", "a", "b", "c", "", "ab", "ac", "", "a", "a", "a", "a",
            "", "b", "",
        ]
        .iter()
        .map(|l| l.to_string())
        .collect();

        let forms = parse_forms(&data[..]).unwrap();
        assert_eq!(forms.len(), 5);

        let res = count_them(&forms);

        assert_eq!(res, 11);
    }

    #[test]
    fn test_part_two() {
        let data: Vec<String> = [
            "abc", "", "a", "b", "c", "", "ab", "ac", "", "a", "a", "a", "a",
            "", "b", "",
        ]
        .iter()
        .map(|l| l.to_string())
        .collect();

        let forms = parse_forms_2(&data[..]).unwrap();
        assert_eq!(forms.len(), 5);

        let res = count_them(&forms);

        assert_eq!(res, 6);
    }
}
