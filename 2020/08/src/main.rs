use std::collections::HashSet;
use std::convert::TryInto;
use std::error::Error;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Clone)]
enum Instruction {
    Acc(i64),
    Nop(i64),
    Jmp(i64),
}

impl Instruction {
    pub fn from_line(line: &str) -> Self {
        use Instruction::*;
        let mut spliterator = line.split(' ');
        let instr = spliterator.next().unwrap();
        let operand = spliterator.next().unwrap().parse::<i64>().unwrap();
        match instr {
            "acc" => Acc(operand),
            "nop" => Nop(operand),
            "jmp" => Jmp(operand),
            i => panic!("Illegal instruction: {}", i),
        }
    }
}

struct Cpu<'a> {
    ip: i64,
    acc: i64,
    program: &'a [Instruction],
}

impl<'a> Cpu<'a> {
    pub fn new(program: &'a [Instruction]) -> Self {
        Self {
            ip: 0,
            acc: 0,
            program,
        }
    }

    pub fn step(&mut self) -> Result<(), ()> {
        use Instruction::*;
        // Return Err(()) if ip is out of bounds
        if self.ip >= self.program.len().try_into().unwrap() {
            return Err(());
        }
        match self.program[self.ip as usize] {
            Acc(v) => {
                self.acc += v;
                self.ip += 1;
            }
            Nop(_) => self.ip += 1,
            Jmp(v) => self.ip += v,
        }
        Ok(())
    }

    pub fn ip(&self) -> i64 {
        self.ip
    }

    pub fn acc(&self) -> i64 {
        self.acc
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<Instruction> = BufReader::new(file)
        .lines()
        .map(|x| Instruction::from_line(&x.unwrap()))
        .collect();

    assert_eq!(data.len(), 633);
    let res = part_one(&data);
    println!("The value of `acc` is: {}", res);

    let res = part_two(&data);
    println!("The value of acc in a terminated run is: {}", res);

    Ok(())
}

fn part_one(program: &[Instruction]) -> i64 {
    let mut cpu = Cpu::new(program);
    let mut visited: HashSet<i64> = Default::default();

    println!("Visited: {:?}", visited);

    while !visited.contains(&cpu.ip()) {
        // Loop until we revisit a processed instruction
        println!("Processing instruction {}", cpu.ip());
        visited.insert(cpu.ip());
        cpu.step().unwrap();
    }
    cpu.acc()
}

fn part_two(program: &[Instruction]) -> i64 {
    use Instruction::*;

    let mut program_vec = program.to_vec();
    for instruction_idx in 0..program_vec.len() {
        let orig = program_vec[instruction_idx].clone();
        program_vec[instruction_idx] = match orig {
            Jmp(v) => Nop(v),
            Nop(v) => Jmp(v),
            _ => continue,
        };

        if let Some(acc) = terminates(&program_vec[..]) {
            println!("This time it's terminal!");
            return acc;
        }
        program_vec[instruction_idx] = orig;
    }

    panic!("No terminating swap found!");
}

fn terminates(program: &[Instruction]) -> Option<i64> {
    // If program loops then return None, otherwise return acc
    let mut cpu = Cpu::new(program);
    let mut visited: HashSet<i64> = HashSet::new();

    while !visited.contains(&cpu.ip()) {
        visited.insert(cpu.ip());
        if cpu.step().is_err() {
            // program has terminated
            return Some(cpu.acc());
        }
    }
    None
}

#[cfg(test)]
mod test {
    use super::*;

    fn test_data() -> Vec<Instruction> {
        [
            "nop +0", "acc +1", "jmp +4", "acc +3", "jmp -3", "acc -99",
            "acc +1", "jmp -4", "acc +6",
        ]
        .iter()
        .map(|line| Instruction::from_line(line))
        .collect()
    }

    #[test]
    fn test_part_one() {
        let data = test_data();
        let res = part_one(&data);
        assert_eq!(res, 5);
    }

    #[test]
    fn test_terminates() {
        let mut data = test_data();
        data[0] = Instruction::Jmp(0);

        let res = terminates(&data);
        assert!(res.is_none());

        let mut data = test_data();
        data[7] = Instruction::Nop(-4);

        let res = terminates(&data);
        assert_eq!(res, Some(8));
    }
}
