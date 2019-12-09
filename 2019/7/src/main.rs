#[allow(unused)]
use log::{debug, info, trace};
use simplelog;

fn main() {
    init_log();
    println!("The solution to the second part is: {}", solve_7b());
}

fn init_log() {
    use simplelog::{Config, LevelFilter, TermLogger, TerminalMode};
    let level = LevelFilter::Trace;
    TermLogger::new(level, Config::default(), TerminalMode::Stderr).unwrap();
}

fn solve_7b() -> i32 {
    let program: Vec<i32> = vec![1, 2, 3];
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
        eprintln!("pc: {}", self.pc);
        eprintln!("prog: {:?}", self.program);
        eprintln!("ins: {}", self.program[self.pc]);
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
            eprintln!("Current state: {:?}", s);
            match s {
                State::Term => break,
                State::Running => {},
                _ => break,
            }
        }
        eprintln!("The game: {:?}", self.state);
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
}
