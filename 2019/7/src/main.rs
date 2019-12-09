#[allow(unused)]
use log::{debug, info, trace};
use simplelog;

fn main() {
    init_log();
    println!("Day 2, part 1: {}", solve_2a());
    println!("Day 2, part 2: {}", solve_2b());
    println!("Day 7, part 2: {}", solve_7b());
}

fn init_log() {
    use simplelog::{Config, LevelFilter, TermLogger, TerminalMode};
    let level = LevelFilter::Trace;
    TermLogger::new(level, Config::default(), TerminalMode::Stderr).unwrap();
}

fn solve_2a() -> i32 {
    let mut program = vec![
        1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,2,6,19,23,1,23,5,27,1,27,13,
        31,2,6,31,35,1,5,35,39,1,39,10,43,2,6,43,47,1,47,5,51,1,51,9,55,2,55,6,
        59,1,59,10,63,2,63,9,67,1,67,5,71,1,71,5,75,2,75,6,79,1,5,79,83,1,10,
        83,87,2,13,87,91,1,10,91,95,2,13,95,99,1,99,9,103,1,5,103,107,1,107,10,
        111,1,111,5,115,1,115,6,119,1,119,10,123,1,123,10,127,2,127,13,131,1,
        13,131,135,1,135,10,139,2,139,6,143,1,143,9,147,2,147,6,151,1,5,151,
        155,1,9,155,159,2,159,6,163,1,163,2,167,1,10,167,0,99,2,14,0,0
    ];

    // Set the 1202 condition
    program[1] = 12;
    program[2] =  2;

    let mut amp = Amplifier::new(&program);
    assert_eq!(amp.process(), State::Term);

    amp.program[0]
}

fn solve_2b() -> i32 {
    let program = vec![
        1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,2,6,19,23,1,23,5,27,1,27,13,
        31,2,6,31,35,1,5,35,39,1,39,10,43,2,6,43,47,1,47,5,51,1,51,9,55,2,55,6,
        59,1,59,10,63,2,63,9,67,1,67,5,71,1,71,5,75,2,75,6,79,1,5,79,83,1,10,
        83,87,2,13,87,91,1,10,91,95,2,13,95,99,1,99,9,103,1,5,103,107,1,107,10,
        111,1,111,5,115,1,115,6,119,1,119,10,123,1,123,10,127,2,127,13,131,1,
        13,131,135,1,135,10,139,2,139,6,143,1,143,9,147,2,147,6,151,1,5,151,
        155,1,9,155,159,2,159,6,163,1,163,2,167,1,10,167,0,99,2,14,0,0
    ];

    // Iterate over input integers
    for noun in 0..99 {
        for verb in 0..99 {
            let mut amp = Amplifier::new(&program);
            // Set the input
            amp.program[1] = noun;
            amp.program[2] = verb;
            assert_eq!(amp.process(), State::Term);
            if amp.program[0] == 19690720 {
                // Found the correct output
                return 100*noun + verb;
            }
        }
    }
    
    panic!("Unable to solve the puzzle :(");
}


fn solve_7b() -> i32 {
    let program: Vec<i32> = vec![99, 2, 3];
    let mut a = Amplifier::new(&program);

    a.process();

    4
}

#[derive(Clone, Debug, PartialEq)]
enum State {
    Running,
    Term,
    Output,
    Input,
    Err,
}

struct Amplifier {
    program: Vec<i32>,
    pc: usize,
    input_buffer: Vec<i32>,
    output_buffer: Vec<i32>,
    state: State,
}

impl Amplifier {
    fn new(program: &Vec<i32>) -> Self {
        Self {
            program: program.clone(),
            pc: 0,
            input_buffer: Vec::new(),
            output_buffer: Vec::new(),
            state: State::Running,
        }
    }

    fn resolve_args(&mut self) -> Vec<i32> {
        let mut args = Vec::new();
        // mode stuff
        match self.program[self.pc] {
            1|2 => {
                args.push(self.program[self.program[self.pc + 1] as usize]);
                args.push(self.program[self.program[self.pc + 2] as usize]);
            },
            _ => unimplemented!(),
        }
        args
    }

    fn step(&mut self) -> State {
        //eprintln!("pc: {}", self.pc);
        //eprintln!("prog: {:?}", self.program);
        //eprintln!("ins: {}", self.program[self.pc]);
        match &mut self.program[self.pc] {
            1 => {
                // ADD
                let args = self.resolve_args();
                let write_idx = self.program[self.pc+3] as usize;
                self.program[write_idx] = args[0] + args[1];
                self.pc += 4;
                self.state = State::Running;
            },
            2 => {
                // MUL
                let args = self.resolve_args();
                let write_idx = self.program[self.pc+3] as usize;
                self.program[write_idx] = args[0] * args[1];
                self.pc += 4;
                self.state = State::Running;
            },
            3 => {
                // INPUT
                unimplemented!();
            },
            4 => {
                // OUTPUT
                unimplemented!();
            },
            5 => {
                // JUMP-IF-TRUE
                unimplemented!();
            },
            6 => {
                // JUMP-IF-FALSE
                unimplemented!();
            },
            7 => {
                // LESS THAN
                unimplemented!();
            },
            8 => {
                // EQ
                unimplemented!();
            },
            99 => {
                // TERM
                self.state = State::Term;
            },
            _ => {
                // ERR
                eprintln!(
                    "Error: pc={}, instr={}",
                    self.pc,
                    self.program[self.pc],
                    );
                self.state = State::Err;
            }
        }
        self.state.clone()
    }

    fn process(&mut self) -> State {
        while self.state == State::Running {
            let s = self.step();
            //eprintln!("Current state: {:?}", s);
            match s {
                State::Term => break,
                State::Running => {},
                _ => break,
            }
        }
        //eprintln!("The game: {:?}", self.state);
        self.state.clone()
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use log::{debug, info, trace};
    #[test]
    fn day_2_test_1() {
        init_log();
        trace!("Starting test");
        debug!("debug");
        let program = vec![1,9,10,3,2,3,11,0,99,30,40,50];
        let mut amp = Amplifier::new(&program);
        match amp.process() {
            State::Term => {
                assert_eq!(amp.program[0], 3500);
            },
            s => panic!("Unexpected state: {:?}", s),
        }
    }

    #[test]
    fn day_2_test_2() {
        let program = vec![1,0,0,0,99];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.program[0], 2);
    }

    #[test]
    fn day_2_test_3() {
        let program = vec![2,3,0,3,99];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.program[3], 6);
    }

    #[test]
    fn day_2_test_4() {
        let program = vec![2,4,4,5,99,0];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.program[5], 9801);
    }

    #[test]
    fn day_2_test_5() {
        let program = vec![1,1,1,4,99,5,6,0,99];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.program[0], 30);
        assert_eq!(amp.program[4], 2);
    }
}
