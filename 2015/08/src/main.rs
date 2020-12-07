use std::collections::HashMap;
use std::error::Error;
use std::fmt::Debug;
use std::fmt::Display;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Clone, Debug)]
enum Operator {
    Literal(u16),
    Assign(String),
    Not(String),
    And(String, String),
    Or(String, String),
    LShift(String, u16),
    RShift(String, u16),
}

#[derive(Clone, Debug)]
struct Gate {
    operator: Operator,
    output: String,
}

impl Gate {
    pub fn from_line(inp: &str) -> Self {
        use Operator::*;

        let mut spliterator = inp.split(" -> ");
        let input_string = spliterator.next().unwrap();
        let output = spliterator.next().unwrap().to_string();

        let input_vec: Vec<&str> = input_string.split(' ').collect();

        println!("Input vec: {:?}", input_vec);
        let operator = match input_vec.len() {
            1 => {
                if let Ok(num) = input_vec[0].parse() {
                    Literal(num)
                } else {
                    Assign(input_vec[0].to_string())
                }
            }
            2 => Not(input_vec[1].to_string()),
            3 => match input_vec[1] {
                "AND" => {
                    And(input_vec[0].to_string(), input_vec[2].to_string())
                }
                "OR" => Or(input_vec[0].to_string(), input_vec[2].to_string()),
                "LSHIFT" => LShift(
                    input_vec[0].to_string(),
                    input_vec[2].parse().unwrap(),
                ),
                "RSHIFT" => RShift(
                    input_vec[0].to_string(),
                    input_vec[2].parse().unwrap(),
                ),
                _ => panic!(),
            },
            _ => panic!(),
        };

        Self { operator, output }
    }
}

impl Display for Gate {
    fn fmt(
        &self,
        fmt: &mut std::fmt::Formatter,
    ) -> Result<(), std::fmt::Error> {
        use Operator::*;
        match &self.operator {
            Literal(v) => write!(fmt, "{}", v)?,
            Assign(v) => write!(fmt, "{}", v)?,
            And(a, b) => write!(fmt, "{} & {}", a, b)?,
            Or(a, b) => write!(fmt, "{} | {}", a, b)?,
            Not(v) => write!(fmt, "NOT {}", v)?,
            LShift(v, s) => write!(fmt, "{} << {}", v, s)?,
            RShift(v, s) => write!(fmt, "{} >> {}", v, s)?,
        }
        write!(fmt, " -> {}", self.output)
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<Gate> = BufReader::new(file)
        .lines()
        .map(|x| Gate::from_line(&x.unwrap()))
        .collect();
    assert_eq!(data.len(), 339);
    let res = part_one(&data, None);
    let a = res.get("a").unwrap();
    println!("res: {:?}", res);
    println!("The value of `a` is: {}", a);

    let res = part_one(&data, Some(*a));
    let a = res.get("a").unwrap();
    println!("The value of `a` is now: {}", a);
    Ok(())
}

fn part_one(gates: &[Gate], seed_for_b: Option<u16>) -> HashMap<String, u16> {
    use Operator::*;

    let mut wires: HashMap<String, u16> = Default::default();
    if let Some(b) = seed_for_b {
    	wires.insert("b".to_string(), b);
    }

    // Track whether each gate has been executed, as they have been written
    // out of order
    let mut gates_with_status: Vec<(Gate, bool)> =
        gates.iter().map(|g| ((*g).clone(), false)).collect();

    // track whether any gates have been successful - if none succeed then a bad
    // has happened
    let mut any_success = true;
    while
    /*gates_with_status.iter().filter(|g| !g.1).count() > 0 &&*/
    any_success {
        any_success = false;
        for gate in gates_with_status.iter_mut().filter(|g| !g.1) {
            println!("Executing {:?}", gate);
            let output = gate.0.output.to_string();
            match &gate.0.operator {
                Literal(val) => {
                    wires.insert(output, *val);
                    gate.1 = true;
                    any_success = true;
                }
                Assign(wire) => {
                    if let Some(inp) = wires.get(wire) {
                        let inp = *inp;
                        wires.insert(output, inp);
                        gate.1 = true;
                        any_success = true;
                    }
                }
                Not(wire) => {
                    if let Some(inp) = wires.get(wire) {
                        let inp = *inp;
                        wires.insert(output, !inp);
                        gate.1 = true;
                        any_success = true;
                    } else if let Ok(num) = wire.parse::<u16>() {
                        // arg is a literal
                        wires.insert(output, !num);
                        gate.1 = true;
                        any_success = true;
                    }
                }
                And(a, b) => {
                    let a = if let Some(a) = wires.get(a) {
                        *a
                    } else if let Ok(a) = a.parse::<u16>() {
                        a
                    } else {
                        continue;
                    };
                    let b = if let Some(b) = wires.get(b) {
                        *b
                    } else if let Ok(b) = b.parse::<u16>() {
                        b
                    } else {
                        continue;
                    };
                    wires.insert(output, a & b);
                    gate.1 = true;
                    any_success = true;
                }
                Or(a, b) => {
                    let a = if let Some(a) = wires.get(a) {
                        *a
                    } else if let Ok(a) = a.parse::<u16>() {
                        a
                    } else {
                        continue;
                    };
                    let b = if let Some(b) = wires.get(b) {
                        *b
                    } else if let Ok(b) = b.parse::<u16>() {
                        b
                    } else {
                        continue;
                    };

                    wires.insert(output, a | b);
                    gate.1 = true;
                    any_success = true;
                }
                LShift(wire, shift) => {
                    if let Some(inp) = wires.get(wire) {
                        let inp = *inp;
                        wires.insert(output, inp << shift);
                        gate.1 = true;
                        any_success = true;
                    }
                }
                RShift(wire, shift) => {
                    if let Some(inp) = wires.get(wire) {
                        let inp = *inp;
                        wires.insert(output, inp >> shift);
                        gate.1 = true;
                        any_success = true;
                    }
                }
            }
            if gate.1 {
                println!("GATE PROCESSED");
            } else {
                println!("GATE MISSED");
            }
        }
        if any_success {
            println!("SUCCESS");
        } else {
            println!("MISS");
            println!("WIRES STATE: {:?}", wires);
            println!(
                "GATES NOT YET PROCESSED: {}",
                gates_with_status
                    .iter()
                    .filter(|g| !g.1)
                    .map(|g| format!("{}", g.0))
                    .fold(String::new(), |a, b| format!("{}\n{}", a, b))
            );
        }
    }

    wires
}

#[cfg(test)]
mod test {
    use super::*;

    fn test_data() -> Vec<Gate> {
        // This is the provided test dataset, but with assign added and
        // the order messed up (because the real input is out of order)
        [
            "x OR y -> e",
            "x LSHIFT 2 -> f",
            "f OR g -> abc",
            "123 -> x",
            "y -> z",
            "456 -> y",
            "x AND y -> d",
            "y RSHIFT 2 -> g",
            "NOT x -> h",
            "NOT y -> i",
            "NOT 5 -> pq",
            "56 AND i -> qr",
            "pq OR 934 -> qwe",
        ]
        .iter()
        .map(|line| Gate::from_line(&line))
        .collect()
    }

    #[test]
    fn test_part_one() {
        let data = test_data();
        assert_eq!(data.len(), 13);

        let res = part_one(&data, None);
        let answers = [
            ("d", 72_u16),
            ("e", 507),
            ("f", 492),
            ("g", 114),
            ("h", 65412),
            ("i", 65079),
            ("x", 123),
            ("y", 456),
            ("z", 456),
            ("abc", 510),
            ("pq", 65530),
            ("qr", 48),
            ("qwe", 65534),
        ];
        for (wire, signal) in answers.iter() {
            println!("Checking case... ({}, {})", wire, signal);
            assert_eq!(res.get(*wire).unwrap(), signal);
        }
    }

    #[test]
    fn test_seed_for_b() {
    	let data = test_data();
    	let res = part_one(&data, Some(5432));
    	assert_eq!(res.get("b").unwrap(), &5432);
    }
}
