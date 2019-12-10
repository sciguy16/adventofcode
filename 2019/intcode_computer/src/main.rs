#[allow(unused)]
use log::{debug, info, trace};
use simplelog;

fn main() {
    init_log();
    println!("Day 2, part 1: {}", solve_2a());
    println!("Day 2, part 2: {}", solve_2b());

    println!("Day 5, part 1: {}", solve_5a());
    println!("Day 5, part 2: {}", solve_5b());

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

fn solve_5a() -> i32 {
    let program = vec![
        3,225,1,225,6,6,1100,1,238,225,104,0,101,67,166,224,1001,
        224,-110,224,4,224,102,8,223,223,1001,224,4,224,1,224,223,
        223,2,62,66,224,101,-406,224,224,4,224,102,8,223,223,101,3,
        224,224,1,224,223,223,1101,76,51,225,1101,51,29,225,1102,57,
        14,225,1102,64,48,224,1001,224,-3072,224,4,224,102,8,223,
        223,1001,224,1,224,1,224,223,223,1001,217,90,224,1001,224,
        -101,224,4,224,1002,223,8,223,1001,224,2,224,1,223,224,223,
        1101,57,55,224,1001,224,-112,224,4,224,102,8,223,223,1001,
        224,7,224,1,223,224,223,1102,5,62,225,1102,49,68,225,102,40,
        140,224,101,-2720,224,224,4,224,1002,223,8,223,1001,224,4,
        224,1,223,224,223,1101,92,43,225,1101,93,21,225,1002,170,31,
        224,101,-651,224,224,4,224,102,8,223,223,101,4,224,224,1,
        223,224,223,1,136,57,224,1001,224,-138,224,4,224,102,8,223,
        223,101,2,224,224,1,223,224,223,1102,11,85,225,4,223,99,0,0,
        0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,
        1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,
        99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,
        1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,
        0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,
        225,1101,314,0,0,106,0,0,1105,1,99999,1107,226,226,224,102,
        2,223,223,1006,224,329,1001,223,1,223,1007,226,677,224,1002,
        223,2,223,1005,224,344,101,1,223,223,108,677,677,224,1002,
        223,2,223,1006,224,359,101,1,223,223,1008,226,226,224,1002,
        223,2,223,1005,224,374,1001,223,1,223,108,677,226,224,1002,
        223,2,223,1006,224,389,101,1,223,223,7,226,226,224,102,2,
        223,223,1006,224,404,101,1,223,223,7,677,226,224,1002,223,2,
        223,1005,224,419,101,1,223,223,107,226,226,224,102,2,223,
        223,1006,224,434,1001,223,1,223,1008,677,677,224,1002,223,2,
        223,1005,224,449,101,1,223,223,108,226,226,224,102,2,223,
        223,1005,224,464,1001,223,1,223,1108,226,677,224,1002,223,2,
        223,1005,224,479,1001,223,1,223,8,677,226,224,102,2,223,223,
        1006,224,494,1001,223,1,223,1108,677,677,224,102,2,223,223,
        1006,224,509,1001,223,1,223,1007,226,226,224,1002,223,2,223,
        1005,224,524,1001,223,1,223,7,226,677,224,1002,223,2,223,
        1005,224,539,1001,223,1,223,8,677,677,224,102,2,223,223,
        1005,224,554,1001,223,1,223,107,226,677,224,1002,223,2,223,
        1006,224,569,101,1,223,223,1107,226,677,224,102,2,223,223,
        1005,224,584,1001,223,1,223,1108,677,226,224,102,2,223,223,
        1006,224,599,1001,223,1,223,1008,677,226,224,102,2,223,223,
        1006,224,614,101,1,223,223,107,677,677,224,102,2,223,223,
        1006,224,629,1001,223,1,223,1107,677,226,224,1002,223,2,223,
        1005,224,644,101,1,223,223,8,226,677,224,102,2,223,223,1005,
        224,659,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,
        224,674,1001,223,1,223,4,223,99,226,
        ];

    let mut amp = Amplifier::new(&program);
    amp.input_buffer.push(1);
    loop {
        amp.process();
        //println!("State: {:?}", amp.state);
        if amp.state == State::Term {
            break;
        }
    }
    println!("Output: {:?}", amp.output_buffer);

    amp.output_buffer[amp.output_buffer.len() - 1]
}

fn solve_5b() -> i32 {
    let program = vec![
        3,225,1,225,6,6,1100,1,238,225,104,0,101,67,166,224,1001,
        224,-110,224,4,224,102,8,223,223,1001,224,4,224,1,224,223,
        223,2,62,66,224,101,-406,224,224,4,224,102,8,223,223,101,3,
        224,224,1,224,223,223,1101,76,51,225,1101,51,29,225,1102,57,
        14,225,1102,64,48,224,1001,224,-3072,224,4,224,102,8,223,
        223,1001,224,1,224,1,224,223,223,1001,217,90,224,1001,224,
        -101,224,4,224,1002,223,8,223,1001,224,2,224,1,223,224,223,
        1101,57,55,224,1001,224,-112,224,4,224,102,8,223,223,1001,
        224,7,224,1,223,224,223,1102,5,62,225,1102,49,68,225,102,40,
        140,224,101,-2720,224,224,4,224,1002,223,8,223,1001,224,4,
        224,1,223,224,223,1101,92,43,225,1101,93,21,225,1002,170,31,
        224,101,-651,224,224,4,224,102,8,223,223,101,4,224,224,1,
        223,224,223,1,136,57,224,1001,224,-138,224,4,224,102,8,223,
        223,101,2,224,224,1,223,224,223,1102,11,85,225,4,223,99,0,0,
        0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,
        1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,
        99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,
        1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,
        0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,
        225,1101,314,0,0,106,0,0,1105,1,99999,1107,226,226,224,102,
        2,223,223,1006,224,329,1001,223,1,223,1007,226,677,224,1002,
        223,2,223,1005,224,344,101,1,223,223,108,677,677,224,1002,
        223,2,223,1006,224,359,101,1,223,223,1008,226,226,224,1002,
        223,2,223,1005,224,374,1001,223,1,223,108,677,226,224,1002,
        223,2,223,1006,224,389,101,1,223,223,7,226,226,224,102,2,
        223,223,1006,224,404,101,1,223,223,7,677,226,224,1002,223,2,
        223,1005,224,419,101,1,223,223,107,226,226,224,102,2,223,
        223,1006,224,434,1001,223,1,223,1008,677,677,224,1002,223,2,
        223,1005,224,449,101,1,223,223,108,226,226,224,102,2,223,
        223,1005,224,464,1001,223,1,223,1108,226,677,224,1002,223,2,
        223,1005,224,479,1001,223,1,223,8,677,226,224,102,2,223,223,
        1006,224,494,1001,223,1,223,1108,677,677,224,102,2,223,223,
        1006,224,509,1001,223,1,223,1007,226,226,224,1002,223,2,223,
        1005,224,524,1001,223,1,223,7,226,677,224,1002,223,2,223,
        1005,224,539,1001,223,1,223,8,677,677,224,102,2,223,223,
        1005,224,554,1001,223,1,223,107,226,677,224,1002,223,2,223,
        1006,224,569,101,1,223,223,1107,226,677,224,102,2,223,223,
        1005,224,584,1001,223,1,223,1108,677,226,224,102,2,223,223,
        1006,224,599,1001,223,1,223,1008,677,226,224,102,2,223,223,
        1006,224,614,101,1,223,223,107,677,677,224,102,2,223,223,
        1006,224,629,1001,223,1,223,1107,677,226,224,1002,223,2,223,
        1005,224,644,101,1,223,223,8,226,677,224,102,2,223,223,1005,
        224,659,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,
        224,674,1001,223,1,223,4,223,99,226,
        ];

    let mut amp = Amplifier::new(&program);
    // System ID is 5
    amp.input_buffer.push(5);
    loop {
        amp.process();
        //println!("State: {:?}", amp.state);
        if amp.state == State::Term {
            break;
        }
    }
    println!("Output: {:?}", amp.output_buffer);

    amp.output_buffer[amp.output_buffer.len() - 1]
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
    OutputReady,
    InputWaiting,
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
        let mut param_modes = self.program[self.pc] / 100;
        let nparams: usize = match self.program[self.pc] % 100 {
            1|2 => 3,
            3|4 => 1,
            5|6 => 2,
            7|8 => 3,
            _ => unimplemented!(),
        };

        for idx in 1..=nparams {
            if param_modes % 10 == 0 {
                // Position mode
                args.push(self.program[self.program[self.pc + idx] as usize]);
            } else {
                // Immediate mode
                args.push(self.program[self.pc + idx]);
            }
            param_modes /= 10;
        }

        args
    }

    fn step(&mut self) -> State {
        eprintln!("pc: {}", self.pc);
        eprintln!("prog: {:?}", self.program);
        eprintln!("ins: {}", self.program[self.pc]);
        // Split instruction from parameter modes
        let instruction = self.program[self.pc] % 100;
        eprintln!("Resolved instruction is {}", instruction);
        match instruction {
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
                if self.input_buffer.len() < 1 {
                    // No input available, return and wait for more
                    self.state = State::InputWaiting;
                } else {
                    let write_idx = self.program[self.pc+1] as usize;
                    eprintln!("write idx is: {}", write_idx);
                    eprintln!("Input buffer is: {:?}", self.input_buffer);
                    self.program[write_idx] = self.input_buffer.remove(0);
                    self.pc += 2;
                }
            },
            4 => {
                // OUTPUT
                let args = self.resolve_args();
                //eprintln!("OUT: args = {:?}", args);
                self.output_buffer.push(args[0]);
                self.pc += 2;
                self.state = State::OutputReady;
            },
            5 => {
                // JUMP-IF-TRUE
                let args = self.resolve_args();
                eprintln!("args is: {:?}", args);
                if args[0] != 0 {
                    // Set instruction pointer to the second arg
                    self.pc = args[1] as usize;
                } else {
                    // Skip the args and move on
                    self.pc += 3;
                }
            },
            6 => {
                // JUMP-IF-FALSE
                unimplemented!();
            },
            7 => {
                // LESS THAN
                let args = self.resolve_args();
                let write_idx = self.program[self.pc+3] as usize;
                self.program[write_idx] = if args[0] < args[1] {
                    1
                } else {
                    0
                };
                self.pc += 4;
            },
            8 => {
                // EQ
                let args = self.resolve_args();
                let write_idx = self.program[self.pc+3] as usize;
                self.program[write_idx] = if args[0] == args[1] {
                    1
                } else {
                    0
                };
                self.pc += 4;
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
        self.state = State::Running;
        while self.state == State::Running {
            let _ = self.step();
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

    #[test]
    fn day_5_test_1() {
        // Test the input and output instructions
        let program = vec![3,0,4,0,99];
        for idx in -10..10 {
            let mut amp = Amplifier::new(&program);

            assert_eq!(amp.process(), State::InputWaiting);
            // Waiting for input, so we give it some and let it continue
            eprintln!("Sending some input");
            amp.input_buffer.push(idx);

            assert_eq!(amp.process(), State::OutputReady);
            // There's some output available, so print it and continue
            eprintln!("Output: {:?}", amp.output_buffer);

            assert_eq!(amp.process(), State::Term);
            assert_eq!(amp.output_buffer[0], idx);
        }
    }

    #[test]
    fn day_5_test_2() {
        // Test the parameter indirection modes
        let program = vec![1002,4,3,4,33];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
    }

    #[test]
    fn day_5_test_3() {
        // Position-mode equal to 8
        let program = vec![3,9,8,9,10,9,4,9,99,-1,8];
        for idx in 5..10 {
            let mut amp = Amplifier::new(&program);
            assert_eq!(amp.process(), State::InputWaiting);
            amp.input_buffer.push(idx);

            // Check that it produces the correct output
            assert_eq!(amp.process(), State::OutputReady);
            let correct = if idx == 8 { 1 } else { 0 };
            assert_eq!(amp.output_buffer[0], correct);

            // Check that it terminated properly
            assert_eq!(amp.process(), State::Term);
        }
    }

    #[test]
    fn day_5_test_4() {
        // Position mode LT 8
        let program = vec![3,9,7,9,10,9,4,9,99,-1,8];
        for idx in 5..10 {
            let mut amp = Amplifier::new(&program);
            assert_eq!(amp.process(), State::InputWaiting);
            amp.input_buffer.push(idx);

            // Check that it produces the correct output
            assert_eq!(amp.process(), State::OutputReady);
            let correct = if idx < 8 { 1 } else { 0 };
            assert_eq!(amp.output_buffer[0], correct);

            // Check that it terminated properly
            assert_eq!(amp.process(), State::Term);
        }
    }

    #[test]
    fn day_5_test_5() {
        // Immediate mode EQ
        let program = vec![3,3,1108,-1,8,3,4,3,99];
        for idx in 5..10 {
            let mut amp = Amplifier::new(&program);
            assert_eq!(amp.process(), State::InputWaiting);
            amp.input_buffer.push(idx);

            // Check that it produces the correct output
            assert_eq!(amp.process(), State::OutputReady);
            let correct = if idx == 8 { 1 } else { 0 };
            assert_eq!(amp.output_buffer[0], correct);

            // Check that it terminated properly
            assert_eq!(amp.process(), State::Term);
        }
    }

    #[test]
    fn day_5_test_6() {
        // Immediate mode LT
        let program = vec![3,3,1107,-1,8,3,4,3,99];
        for idx in 5..10 {
            let mut amp = Amplifier::new(&program);
            assert_eq!(amp.process(), State::InputWaiting);
            amp.input_buffer.push(idx);

            // Check that it produces the correct output
            assert_eq!(amp.process(), State::OutputReady);
            let correct = if idx < 8 { 1 } else { 0 };
            assert_eq!(amp.output_buffer[0], correct);

            // Check that it terminated properly
            assert_eq!(amp.process(), State::Term);
        }
    }

    #[test]
    fn day_5_test_7() {
        // Position mode jump
        let program = vec![3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9];
        for idx in -2..2 {
            let mut amp = Amplifier::new(&program);
            assert_eq!(amp.process(), State::InputWaiting);
            amp.input_buffer.push(idx);

            // Check that it produces the correct output
            assert_eq!(amp.process(), State::OutputReady);
            let correct = if idx != 0 { 1 } else { 0 };
            assert_eq!(amp.output_buffer[0], correct);

            // Check that it terminated properly
            assert_eq!(amp.process(), State::Term);
        }
    }

    #[test]
    fn day_5_test_8() {
        // Immediate mode jump
        let program = vec![3,3,1105,-1,9,1101,0,0,12,4,12,99,1];
        for idx in -2..2 {
            let mut amp = Amplifier::new(&program);
            assert_eq!(amp.process(), State::InputWaiting);
            amp.input_buffer.push(idx);

            // Check that it produces the correct output
            assert_eq!(amp.process(), State::OutputReady);
            let correct = if idx != 0 { 1 } else { 0 };
            assert_eq!(amp.output_buffer[0], correct);

            // Check that it terminated properly
            assert_eq!(amp.process(), State::Term);
        }
    }

}
