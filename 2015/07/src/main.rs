#![allow(unused)]

use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() {
    let filename = "test.txt";
    let wires: HashMap<&str, u16> = HashMap::new();

    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);

    for line in reader.lines() {
        let line = line.unwrap();
        println!("Line is: {line}");
        let chunks: Vec<&str> = line.split(" -> ").collect();

        // There should always be a LHS and a RHS
        assert_eq!(chunks.len(), 2);
        let lhs = chunks[0];
        let rhs = chunks[1];

        // Time to resolve the logic operation...
        match lhs {
            op if op.contains("AND") => println!("AND!!"),
            _ => println!("Not and"),
        }
    }
    println!("Done!");
}
