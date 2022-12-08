#[allow(unused)]
use log::{debug, info, trace};

fn main() {
    init_log();
    println!("Day 2, part 1: {}", solve_2a());
    println!("Day 2, part 2: {}", solve_2b());

    println!("Day 5, part 1: {}", solve_5a());
    println!("Day 5, part 2: {}", solve_5b());

    println!("Day 7, part 1: {}", solve_7a());
    println!("Day 7, part 2: {}", solve_7b());

    println!("Day 9, part 1: {}", solve_9a());
}

fn init_log() {
    use simplelog::{
        ColorChoice, Config, LevelFilter, TermLogger, TerminalMode,
    };
    let level = LevelFilter::Trace;
    TermLogger::new(
        level,
        Config::default(),
        TerminalMode::Stderr,
        ColorChoice::Auto,
    );
}

fn solve_2a() -> i64 {
    let mut program = vec![
        1, 0, 0, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 1, 10, 19, 2, 6, 19,
        23, 1, 23, 5, 27, 1, 27, 13, 31, 2, 6, 31, 35, 1, 5, 35, 39, 1, 39, 10,
        43, 2, 6, 43, 47, 1, 47, 5, 51, 1, 51, 9, 55, 2, 55, 6, 59, 1, 59, 10,
        63, 2, 63, 9, 67, 1, 67, 5, 71, 1, 71, 5, 75, 2, 75, 6, 79, 1, 5, 79,
        83, 1, 10, 83, 87, 2, 13, 87, 91, 1, 10, 91, 95, 2, 13, 95, 99, 1, 99,
        9, 103, 1, 5, 103, 107, 1, 107, 10, 111, 1, 111, 5, 115, 1, 115, 6,
        119, 1, 119, 10, 123, 1, 123, 10, 127, 2, 127, 13, 131, 1, 13, 131,
        135, 1, 135, 10, 139, 2, 139, 6, 143, 1, 143, 9, 147, 2, 147, 6, 151,
        1, 5, 151, 155, 1, 9, 155, 159, 2, 159, 6, 163, 1, 163, 2, 167, 1, 10,
        167, 0, 99, 2, 14, 0, 0,
    ];

    // Set the 1202 condition
    program[1] = 12;
    program[2] = 2;

    let mut amp = Amplifier::new(&program);
    assert_eq!(amp.process(), State::Term);

    amp.program[0]
}

fn solve_2b() -> i64 {
    let program = vec![
        1, 0, 0, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 1, 10, 19, 2, 6, 19,
        23, 1, 23, 5, 27, 1, 27, 13, 31, 2, 6, 31, 35, 1, 5, 35, 39, 1, 39, 10,
        43, 2, 6, 43, 47, 1, 47, 5, 51, 1, 51, 9, 55, 2, 55, 6, 59, 1, 59, 10,
        63, 2, 63, 9, 67, 1, 67, 5, 71, 1, 71, 5, 75, 2, 75, 6, 79, 1, 5, 79,
        83, 1, 10, 83, 87, 2, 13, 87, 91, 1, 10, 91, 95, 2, 13, 95, 99, 1, 99,
        9, 103, 1, 5, 103, 107, 1, 107, 10, 111, 1, 111, 5, 115, 1, 115, 6,
        119, 1, 119, 10, 123, 1, 123, 10, 127, 2, 127, 13, 131, 1, 13, 131,
        135, 1, 135, 10, 139, 2, 139, 6, 143, 1, 143, 9, 147, 2, 147, 6, 151,
        1, 5, 151, 155, 1, 9, 155, 159, 2, 159, 6, 163, 1, 163, 2, 167, 1, 10,
        167, 0, 99, 2, 14, 0, 0,
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
                return 100 * noun + verb;
            }
        }
    }

    panic!("Unable to solve the puzzle :(");
}

fn solve_5a() -> i64 {
    let program = vec![
        3, 225, 1, 225, 6, 6, 1100, 1, 238, 225, 104, 0, 101, 67, 166, 224,
        1001, 224, -110, 224, 4, 224, 102, 8, 223, 223, 1001, 224, 4, 224, 1,
        224, 223, 223, 2, 62, 66, 224, 101, -406, 224, 224, 4, 224, 102, 8,
        223, 223, 101, 3, 224, 224, 1, 224, 223, 223, 1101, 76, 51, 225, 1101,
        51, 29, 225, 1102, 57, 14, 225, 1102, 64, 48, 224, 1001, 224, -3072,
        224, 4, 224, 102, 8, 223, 223, 1001, 224, 1, 224, 1, 224, 223, 223,
        1001, 217, 90, 224, 1001, 224, -101, 224, 4, 224, 1002, 223, 8, 223,
        1001, 224, 2, 224, 1, 223, 224, 223, 1101, 57, 55, 224, 1001, 224,
        -112, 224, 4, 224, 102, 8, 223, 223, 1001, 224, 7, 224, 1, 223, 224,
        223, 1102, 5, 62, 225, 1102, 49, 68, 225, 102, 40, 140, 224, 101,
        -2720, 224, 224, 4, 224, 1002, 223, 8, 223, 1001, 224, 4, 224, 1, 223,
        224, 223, 1101, 92, 43, 225, 1101, 93, 21, 225, 1002, 170, 31, 224,
        101, -651, 224, 224, 4, 224, 102, 8, 223, 223, 101, 4, 224, 224, 1,
        223, 224, 223, 1, 136, 57, 224, 1001, 224, -138, 224, 4, 224, 102, 8,
        223, 223, 101, 2, 224, 224, 1, 223, 224, 223, 1102, 11, 85, 225, 4,
        223, 99, 0, 0, 0, 677, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1105, 0, 99999,
        1105, 227, 247, 1105, 1, 99999, 1005, 227, 99999, 1005, 0, 256, 1105,
        1, 99999, 1106, 227, 99999, 1106, 0, 265, 1105, 1, 99999, 1006, 0,
        99999, 1006, 227, 274, 1105, 1, 99999, 1105, 1, 280, 1105, 1, 99999, 1,
        225, 225, 225, 1101, 294, 0, 0, 105, 1, 0, 1105, 1, 99999, 1106, 0,
        300, 1105, 1, 99999, 1, 225, 225, 225, 1101, 314, 0, 0, 106, 0, 0,
        1105, 1, 99999, 1107, 226, 226, 224, 102, 2, 223, 223, 1006, 224, 329,
        1001, 223, 1, 223, 1007, 226, 677, 224, 1002, 223, 2, 223, 1005, 224,
        344, 101, 1, 223, 223, 108, 677, 677, 224, 1002, 223, 2, 223, 1006,
        224, 359, 101, 1, 223, 223, 1008, 226, 226, 224, 1002, 223, 2, 223,
        1005, 224, 374, 1001, 223, 1, 223, 108, 677, 226, 224, 1002, 223, 2,
        223, 1006, 224, 389, 101, 1, 223, 223, 7, 226, 226, 224, 102, 2, 223,
        223, 1006, 224, 404, 101, 1, 223, 223, 7, 677, 226, 224, 1002, 223, 2,
        223, 1005, 224, 419, 101, 1, 223, 223, 107, 226, 226, 224, 102, 2, 223,
        223, 1006, 224, 434, 1001, 223, 1, 223, 1008, 677, 677, 224, 1002, 223,
        2, 223, 1005, 224, 449, 101, 1, 223, 223, 108, 226, 226, 224, 102, 2,
        223, 223, 1005, 224, 464, 1001, 223, 1, 223, 1108, 226, 677, 224, 1002,
        223, 2, 223, 1005, 224, 479, 1001, 223, 1, 223, 8, 677, 226, 224, 102,
        2, 223, 223, 1006, 224, 494, 1001, 223, 1, 223, 1108, 677, 677, 224,
        102, 2, 223, 223, 1006, 224, 509, 1001, 223, 1, 223, 1007, 226, 226,
        224, 1002, 223, 2, 223, 1005, 224, 524, 1001, 223, 1, 223, 7, 226, 677,
        224, 1002, 223, 2, 223, 1005, 224, 539, 1001, 223, 1, 223, 8, 677, 677,
        224, 102, 2, 223, 223, 1005, 224, 554, 1001, 223, 1, 223, 107, 226,
        677, 224, 1002, 223, 2, 223, 1006, 224, 569, 101, 1, 223, 223, 1107,
        226, 677, 224, 102, 2, 223, 223, 1005, 224, 584, 1001, 223, 1, 223,
        1108, 677, 226, 224, 102, 2, 223, 223, 1006, 224, 599, 1001, 223, 1,
        223, 1008, 677, 226, 224, 102, 2, 223, 223, 1006, 224, 614, 101, 1,
        223, 223, 107, 677, 677, 224, 102, 2, 223, 223, 1006, 224, 629, 1001,
        223, 1, 223, 1107, 677, 226, 224, 1002, 223, 2, 223, 1005, 224, 644,
        101, 1, 223, 223, 8, 226, 677, 224, 102, 2, 223, 223, 1005, 224, 659,
        1001, 223, 1, 223, 1007, 677, 677, 224, 102, 2, 223, 223, 1005, 224,
        674, 1001, 223, 1, 223, 4, 223, 99, 226,
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
    //println!("Output: {:?}", amp.output_buffer);

    amp.output_buffer[amp.output_buffer.len() - 1]
}

fn solve_5b() -> i64 {
    let program = vec![
        3, 225, 1, 225, 6, 6, 1100, 1, 238, 225, 104, 0, 101, 67, 166, 224,
        1001, 224, -110, 224, 4, 224, 102, 8, 223, 223, 1001, 224, 4, 224, 1,
        224, 223, 223, 2, 62, 66, 224, 101, -406, 224, 224, 4, 224, 102, 8,
        223, 223, 101, 3, 224, 224, 1, 224, 223, 223, 1101, 76, 51, 225, 1101,
        51, 29, 225, 1102, 57, 14, 225, 1102, 64, 48, 224, 1001, 224, -3072,
        224, 4, 224, 102, 8, 223, 223, 1001, 224, 1, 224, 1, 224, 223, 223,
        1001, 217, 90, 224, 1001, 224, -101, 224, 4, 224, 1002, 223, 8, 223,
        1001, 224, 2, 224, 1, 223, 224, 223, 1101, 57, 55, 224, 1001, 224,
        -112, 224, 4, 224, 102, 8, 223, 223, 1001, 224, 7, 224, 1, 223, 224,
        223, 1102, 5, 62, 225, 1102, 49, 68, 225, 102, 40, 140, 224, 101,
        -2720, 224, 224, 4, 224, 1002, 223, 8, 223, 1001, 224, 4, 224, 1, 223,
        224, 223, 1101, 92, 43, 225, 1101, 93, 21, 225, 1002, 170, 31, 224,
        101, -651, 224, 224, 4, 224, 102, 8, 223, 223, 101, 4, 224, 224, 1,
        223, 224, 223, 1, 136, 57, 224, 1001, 224, -138, 224, 4, 224, 102, 8,
        223, 223, 101, 2, 224, 224, 1, 223, 224, 223, 1102, 11, 85, 225, 4,
        223, 99, 0, 0, 0, 677, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1105, 0, 99999,
        1105, 227, 247, 1105, 1, 99999, 1005, 227, 99999, 1005, 0, 256, 1105,
        1, 99999, 1106, 227, 99999, 1106, 0, 265, 1105, 1, 99999, 1006, 0,
        99999, 1006, 227, 274, 1105, 1, 99999, 1105, 1, 280, 1105, 1, 99999, 1,
        225, 225, 225, 1101, 294, 0, 0, 105, 1, 0, 1105, 1, 99999, 1106, 0,
        300, 1105, 1, 99999, 1, 225, 225, 225, 1101, 314, 0, 0, 106, 0, 0,
        1105, 1, 99999, 1107, 226, 226, 224, 102, 2, 223, 223, 1006, 224, 329,
        1001, 223, 1, 223, 1007, 226, 677, 224, 1002, 223, 2, 223, 1005, 224,
        344, 101, 1, 223, 223, 108, 677, 677, 224, 1002, 223, 2, 223, 1006,
        224, 359, 101, 1, 223, 223, 1008, 226, 226, 224, 1002, 223, 2, 223,
        1005, 224, 374, 1001, 223, 1, 223, 108, 677, 226, 224, 1002, 223, 2,
        223, 1006, 224, 389, 101, 1, 223, 223, 7, 226, 226, 224, 102, 2, 223,
        223, 1006, 224, 404, 101, 1, 223, 223, 7, 677, 226, 224, 1002, 223, 2,
        223, 1005, 224, 419, 101, 1, 223, 223, 107, 226, 226, 224, 102, 2, 223,
        223, 1006, 224, 434, 1001, 223, 1, 223, 1008, 677, 677, 224, 1002, 223,
        2, 223, 1005, 224, 449, 101, 1, 223, 223, 108, 226, 226, 224, 102, 2,
        223, 223, 1005, 224, 464, 1001, 223, 1, 223, 1108, 226, 677, 224, 1002,
        223, 2, 223, 1005, 224, 479, 1001, 223, 1, 223, 8, 677, 226, 224, 102,
        2, 223, 223, 1006, 224, 494, 1001, 223, 1, 223, 1108, 677, 677, 224,
        102, 2, 223, 223, 1006, 224, 509, 1001, 223, 1, 223, 1007, 226, 226,
        224, 1002, 223, 2, 223, 1005, 224, 524, 1001, 223, 1, 223, 7, 226, 677,
        224, 1002, 223, 2, 223, 1005, 224, 539, 1001, 223, 1, 223, 8, 677, 677,
        224, 102, 2, 223, 223, 1005, 224, 554, 1001, 223, 1, 223, 107, 226,
        677, 224, 1002, 223, 2, 223, 1006, 224, 569, 101, 1, 223, 223, 1107,
        226, 677, 224, 102, 2, 223, 223, 1005, 224, 584, 1001, 223, 1, 223,
        1108, 677, 226, 224, 102, 2, 223, 223, 1006, 224, 599, 1001, 223, 1,
        223, 1008, 677, 226, 224, 102, 2, 223, 223, 1006, 224, 614, 101, 1,
        223, 223, 107, 677, 677, 224, 102, 2, 223, 223, 1006, 224, 629, 1001,
        223, 1, 223, 1107, 677, 226, 224, 1002, 223, 2, 223, 1005, 224, 644,
        101, 1, 223, 223, 8, 226, 677, 224, 102, 2, 223, 223, 1005, 224, 659,
        1001, 223, 1, 223, 1007, 677, 677, 224, 102, 2, 223, 223, 1005, 224,
        674, 1001, 223, 1, 223, 4, 223, 99, 226,
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
    //println!("Output: {:?}", amp.output_buffer);

    amp.output_buffer[amp.output_buffer.len() - 1]
}

fn solve_7a() -> i64 {
    let program = vec![
        3, 8, 1001, 8, 10, 8, 105, 1, 0, 0, 21, 34, 47, 72, 81, 102, 183, 264,
        345, 426, 99999, 3, 9, 102, 5, 9, 9, 1001, 9, 3, 9, 4, 9, 99, 3, 9,
        101, 4, 9, 9, 1002, 9, 3, 9, 4, 9, 99, 3, 9, 102, 3, 9, 9, 101, 2, 9,
        9, 102, 5, 9, 9, 1001, 9, 3, 9, 1002, 9, 4, 9, 4, 9, 99, 3, 9, 101, 5,
        9, 9, 4, 9, 99, 3, 9, 101, 3, 9, 9, 1002, 9, 5, 9, 101, 4, 9, 9, 102,
        2, 9, 9, 4, 9, 99, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9,
        3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1002, 9, 2,
        9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9,
        1001, 9, 1, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4,
        9, 99, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 102,
        2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3,
        9, 102, 2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9,
        4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 99, 3, 9,
        101, 1, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4,
        9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 1,
        9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9,
        102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 99, 3, 9, 1001, 9, 2, 9,
        4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 102,
        2, 9, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3,
        9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9,
        4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 99, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9,
        1001, 9, 2, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4,
        9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1002, 9,
        2, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9,
        1001, 9, 1, 9, 4, 9, 99,
    ];

    max_phase_sequence(&program)
}

fn solve_7b() -> i64 {
    let program = vec![
        3, 8, 1001, 8, 10, 8, 105, 1, 0, 0, 21, 34, 47, 72, 81, 102, 183, 264,
        345, 426, 99999, 3, 9, 102, 5, 9, 9, 1001, 9, 3, 9, 4, 9, 99, 3, 9,
        101, 4, 9, 9, 1002, 9, 3, 9, 4, 9, 99, 3, 9, 102, 3, 9, 9, 101, 2, 9,
        9, 102, 5, 9, 9, 1001, 9, 3, 9, 1002, 9, 4, 9, 4, 9, 99, 3, 9, 101, 5,
        9, 9, 4, 9, 99, 3, 9, 101, 3, 9, 9, 1002, 9, 5, 9, 101, 4, 9, 9, 102,
        2, 9, 9, 4, 9, 99, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9,
        3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1002, 9, 2,
        9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9,
        1001, 9, 1, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4,
        9, 99, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 102,
        2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3,
        9, 102, 2, 9, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 2, 9,
        4, 9, 3, 9, 1001, 9, 2, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 99, 3, 9,
        101, 1, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4,
        9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 1,
        9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9,
        102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 99, 3, 9, 1001, 9, 2, 9,
        4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 102,
        2, 9, 9, 4, 9, 3, 9, 101, 1, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3,
        9, 1001, 9, 1, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9,
        4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 99, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9,
        1001, 9, 2, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 101, 2, 9, 9, 4,
        9, 3, 9, 1001, 9, 1, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1002, 9,
        2, 9, 4, 9, 3, 9, 102, 2, 9, 9, 4, 9, 3, 9, 1002, 9, 2, 9, 4, 9, 3, 9,
        1001, 9, 1, 9, 4, 9, 99,
    ];

    max_feedback_loop(&program)
}

fn solve_9a() -> i64 {
    let program = vec![
        1102, 34463338, 34463338, 63, 1007, 63, 34463338, 63, 1005, 63, 53,
        1101, 3, 0, 1000, 109, 988, 209, 12, 9, 1000, 209, 6, 209, 3, 203, 0,
        1008, 1000, 1, 63, 1005, 63, 65, 1008, 1000, 2, 63, 1005, 63, 904,
        1008, 1000, 0, 63, 1005, 63, 58, 4, 25, 104, 0, 99, 4, 0, 104, 0, 99,
        4, 17, 104, 0, 99, 0, 0, 1101, 27, 0, 1014, 1101, 286, 0, 1023, 1102,
        1, 35, 1018, 1102, 20, 1, 1000, 1101, 26, 0, 1010, 1101, 0, 289, 1022,
        1102, 1, 30, 1019, 1102, 734, 1, 1025, 1102, 1, 31, 1012, 1101, 25, 0,
        1001, 1102, 1, 1, 1021, 1101, 0, 36, 1002, 1101, 0, 527, 1028, 1101,
        895, 0, 1026, 1102, 1, 23, 1016, 1101, 21, 0, 1003, 1102, 22, 1, 1011,
        1102, 1, 522, 1029, 1102, 1, 892, 1027, 1102, 1, 0, 1020, 1102, 1, 28,
        1015, 1102, 38, 1, 1006, 1101, 0, 32, 1008, 1101, 743, 0, 1024, 1101,
        0, 37, 1007, 1102, 1, 24, 1013, 1102, 1, 33, 1009, 1102, 39, 1, 1004,
        1102, 1, 34, 1005, 1102, 1, 29, 1017, 109, 19, 21102, 40, 1, -3, 1008,
        1016, 40, 63, 1005, 63, 203, 4, 187, 1106, 0, 207, 1001, 64, 1, 64,
        1002, 64, 2, 64, 109, -7, 2101, 0, -7, 63, 1008, 63, 32, 63, 1005, 63,
        227, 1106, 0, 233, 4, 213, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -3,
        2108, 37, -2, 63, 1005, 63, 255, 4, 239, 1001, 64, 1, 64, 1105, 1, 255,
        1002, 64, 2, 64, 109, 11, 21108, 41, 40, -6, 1005, 1014, 275, 1001, 64,
        1, 64, 1106, 0, 277, 4, 261, 1002, 64, 2, 64, 109, 10, 2105, 1, -7,
        1105, 1, 295, 4, 283, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -27, 1201,
        -2, 0, 63, 1008, 63, 25, 63, 1005, 63, 321, 4, 301, 1001, 64, 1, 64,
        1105, 1, 321, 1002, 64, 2, 64, 109, 15, 21107, 42, 41, 0, 1005, 1018,
        341, 1001, 64, 1, 64, 1106, 0, 343, 4, 327, 1002, 64, 2, 64, 109, -25,
        2108, 20, 10, 63, 1005, 63, 359, 1105, 1, 365, 4, 349, 1001, 64, 1, 64,
        1002, 64, 2, 64, 109, 12, 2107, 35, 0, 63, 1005, 63, 385, 1001, 64, 1,
        64, 1106, 0, 387, 4, 371, 1002, 64, 2, 64, 109, 4, 21101, 43, 0, 6,
        1008, 1015, 43, 63, 1005, 63, 409, 4, 393, 1106, 0, 413, 1001, 64, 1,
        64, 1002, 64, 2, 64, 109, 9, 21101, 44, 0, -8, 1008, 1010, 46, 63,
        1005, 63, 437, 1001, 64, 1, 64, 1106, 0, 439, 4, 419, 1002, 64, 2, 64,
        109, 5, 21108, 45, 45, -4, 1005, 1019, 457, 4, 445, 1106, 0, 461, 1001,
        64, 1, 64, 1002, 64, 2, 64, 109, -22, 2102, 1, 7, 63, 1008, 63, 33, 63,
        1005, 63, 481, 1106, 0, 487, 4, 467, 1001, 64, 1, 64, 1002, 64, 2, 64,
        109, 14, 21102, 46, 1, -1, 1008, 1014, 43, 63, 1005, 63, 507, 1106, 0,
        513, 4, 493, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 12, 2106, 0, 1, 4,
        519, 1106, 0, 531, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, -17, 1205,
        10, 547, 1001, 64, 1, 64, 1106, 0, 549, 4, 537, 1002, 64, 2, 64, 109,
        -8, 1202, -2, 1, 63, 1008, 63, 17, 63, 1005, 63, 569, 1105, 1, 575, 4,
        555, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 23, 1206, -5, 593, 4, 581,
        1001, 64, 1, 64, 1105, 1, 593, 1002, 64, 2, 64, 109, -14, 1208, -8, 24,
        63, 1005, 63, 613, 1001, 64, 1, 64, 1105, 1, 615, 4, 599, 1002, 64, 2,
        64, 109, -2, 1207, -1, 33, 63, 1005, 63, 633, 4, 621, 1105, 1, 637,
        1001, 64, 1, 64, 1002, 64, 2, 64, 109, 2, 21107, 47, 48, 5, 1005, 1016,
        659, 4, 643, 1001, 64, 1, 64, 1105, 1, 659, 1002, 64, 2, 64, 109, -11,
        1208, 8, 32, 63, 1005, 63, 681, 4, 665, 1001, 64, 1, 64, 1106, 0, 681,
        1002, 64, 2, 64, 109, 2, 2101, 0, 0, 63, 1008, 63, 36, 63, 1005, 63,
        703, 4, 687, 1106, 0, 707, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 12,
        1206, 7, 719, 1106, 0, 725, 4, 713, 1001, 64, 1, 64, 1002, 64, 2, 64,
        109, 2, 2105, 1, 8, 4, 731, 1001, 64, 1, 64, 1106, 0, 743, 1002, 64, 2,
        64, 109, -21, 2102, 1, 9, 63, 1008, 63, 39, 63, 1005, 63, 769, 4, 749,
        1001, 64, 1, 64, 1105, 1, 769, 1002, 64, 2, 64, 109, 11, 1201, -3, 0,
        63, 1008, 63, 24, 63, 1005, 63, 793, 1001, 64, 1, 64, 1105, 1, 795, 4,
        775, 1002, 64, 2, 64, 109, 20, 1205, -5, 809, 4, 801, 1105, 1, 813,
        1001, 64, 1, 64, 1002, 64, 2, 64, 109, -23, 1207, 4, 36, 63, 1005, 63,
        833, 1001, 64, 1, 64, 1105, 1, 835, 4, 819, 1002, 64, 2, 64, 109, -3,
        2107, 33, 5, 63, 1005, 63, 853, 4, 841, 1106, 0, 857, 1001, 64, 1, 64,
        1002, 64, 2, 64, 109, 16, 1202, -9, 1, 63, 1008, 63, 37, 63, 1005, 63,
        879, 4, 863, 1105, 1, 883, 1001, 64, 1, 64, 1002, 64, 2, 64, 109, 12,
        2106, 0, -1, 1105, 1, 901, 4, 889, 1001, 64, 1, 64, 4, 64, 99, 21101,
        0, 27, 1, 21101, 0, 915, 0, 1106, 0, 922, 21201, 1, 48476, 1, 204, 1,
        99, 109, 3, 1207, -2, 3, 63, 1005, 63, 964, 21201, -2, -1, 1, 21101, 0,
        942, 0, 1105, 1, 922, 21202, 1, 1, -1, 21201, -2, -3, 1, 21101, 0, 957,
        0, 1105, 1, 922, 22201, 1, -1, -2, 1106, 0, 968, 21202, -2, 1, -2, 109,
        -3, 2106, 0, 0,
    ];
    let mut amp = Amplifier::new(&program);
    amp.program.append(&mut vec![0; 100]);
    amp.input_buffer.push(1);
    while amp.process() == State::OutputReady {}
    assert_eq!(amp.process(), State::Term);

    println!("Output: {:?}", amp.output_buffer);

    amp.output_buffer[0]
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
    program: Vec<i64>,
    pc: usize,
    input_buffer: Vec<i64>,
    output_buffer: Vec<i64>,
    state: State,
    relative_base: usize,
}

impl Amplifier {
    fn new(program: &[i64]) -> Self {
        Self {
            program: program.to_owned(),
            pc: 0,
            input_buffer: Vec::new(),
            output_buffer: Vec::new(),
            state: State::Running,
            relative_base: 0,
        }
    }

    fn resolve_args(&mut self) -> Vec<i64> {
        let mut args = Vec::new();
        // mode stuff
        let mut param_modes = self.program[self.pc] / 100;
        let instr = self.program[self.pc] % 100;
        let nparams: usize = match instr {
            1 | 2 => 3,
            3 | 4 => 1,
            5 | 6 => 2,
            7 | 8 => 3,
            9 => 1,
            _ => unimplemented!(),
        };

        for idx in 1..=nparams {
            let pmode = param_modes % 10;
            let is_write = ([1, 2, 7, 8].contains(&instr) && idx == 3)
                || (instr == 3 && idx == 1);
            //eprintln!("idx: {}, pmode: {}, is_write: {:?}", idx, pmode, is_write);
            match pmode {
                0 => {
                    // Position mode
                    if !is_write {
                        args.push(
                            self.program[self.program[self.pc + idx] as usize],
                        );
                    } else {
                        args.push(self.program[self.pc + idx]);
                    }
                }
                1 => {
                    // Immediate mode
                    args.push(self.program[self.pc + idx]);
                }
                2 => {
                    // Relative mode
                    if !is_write {
                        args.push(
                            self.program[self.relative_base
                                + (self.program[self.pc + idx]
                                    % std::usize::MAX as i64)
                                    as usize],
                        );
                    } else {
                        args.push(
                            self.relative_base as i64
                                + (self.program[self.pc + idx]
                                    % std::usize::MAX as i64),
                        );
                    }
                }
                _ => {
                    panic!("Invalid mode");
                }
            }
            param_modes /= 10;
        }

        args
    }

    fn step(&mut self) -> State {
        //eprintln!("prog: {:?}", self.program);
        //eprintln!("ins: {}", self.program[self.pc]);
        // Split instruction from parameter modes
        let instruction = self.program[self.pc] % 100;
        //eprintln!("Resolved instruction is {}", instruction);
        match instruction {
            1 => {
                // ADD
                let args = self.resolve_args();
                //let write_idx = self.program[self.pc+3] as usize;
                //eprintln!("args[2] is {}", args[2]);
                //assert_eq!(args[2], self.program[self.pc+3], "is bad");
                self.program[args[2] as usize] = args[0] + args[1];
                self.pc += 4;
                self.state = State::Running;
            }
            2 => {
                // MUL
                let args = self.resolve_args();
                //let write_idx = self.program[self.pc+3] as usize;
                self.program[args[2] as usize] = args[0] * args[1];
                self.pc += 4;
                self.state = State::Running;
            }
            3 => {
                // INPUT
                if self.input_buffer.is_empty() {
                    // No input available, return and wait for more
                    //eprintln!("Empty input buffer: {:?}", self.input_buffer);
                    self.state = State::InputWaiting;
                } else {
                    //let write_idx = self.program[self.pc+1] as usize;
                    //eprintln!("write idx is: {}", write_idx);
                    //eprintln!("Input buffer is: {:?}", self.input_buffer);
                    let args = self.resolve_args();
                    eprintln!("write idx is: {}", args[0]);
                    self.program[args[0] as usize] =
                        self.input_buffer.remove(0);
                    self.pc += 2;
                    self.state = State::Running;
                }
            }
            4 => {
                // OUTPUT
                let args = self.resolve_args();
                //eprintln!("OUT: args = {:?}", args);
                self.output_buffer.push(args[0]);
                self.pc += 2;
                self.state = State::OutputReady;
            }
            5 => {
                // JUMP-IF-TRUE
                let args = self.resolve_args();
                //eprintln!("args is: {:?}", args);
                if args[0] != 0 {
                    // Set instruction pointer to the second arg
                    self.pc = args[1] as usize;
                } else {
                    // Skip the args and move on
                    self.pc += 3;
                }
            }
            6 => {
                // JUMP-IF-FALSE
                let args = self.resolve_args();
                //eprintln!("args is: {:?}", args);
                if args[0] == 0 {
                    // Set instruction pointer to the second arg
                    self.pc = args[1] as usize;
                } else {
                    // Skip the args and move on
                    self.pc += 3;
                }
            }
            7 => {
                // LESS THAN
                let args = self.resolve_args();
                let write_idx = self.program[self.pc + 3] as usize;
                self.program[write_idx] = if args[0] < args[1] { 1 } else { 0 };
                self.pc += 4;
            }
            8 => {
                // EQ
                let args = self.resolve_args();
                let write_idx = self.program[self.pc + 3] as usize;
                self.program[write_idx] =
                    if args[0] == args[1] { 1 } else { 0 };
                self.pc += 4;
            }
            9 => {
                // Update relative base offset
                let args = self.resolve_args();
                self.relative_base += args[0] as usize;
                self.pc += 2;
            }
            99 => {
                // TERM
                self.state = State::Term;
            }
            _ => {
                // ERR
                eprintln!(
                    "Error: pc={}, instr={}",
                    self.pc, self.program[self.pc],
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

fn phase_sequence(program: &[i64], phases: &Vec<i64>) -> i64 {
    assert_eq!(phases.len(), 5);

    let mut input: i64 = 0;
    for phase in phases {
        //eprintln!("--- -- - Phase is: {} - -- ---", phase);
        let mut amp = Amplifier::new(program);
        amp.input_buffer.push(*phase);
        amp.input_buffer.push(input);
        assert_eq!(amp.process(), State::OutputReady);
        //eprintln!("output buffer is: {:?}", amp.output_buffer);
        input = amp.output_buffer[0];
    }

    input
}

fn max_phase_sequence(program: &[i64]) -> i64 {
    let mut phases = vec![0, 1, 2, 3, 4];
    let mut heap = permutohedron::Heap::new(&mut phases);
    let mut biggest = 0;
    while let Some(perm) = heap.next_permutation() {
        let try_out = phase_sequence(program, perm);
        if try_out > biggest {
            biggest = try_out;
        }
    }

    biggest
}

fn feedback_loop(program: &[i64], phases: &[i64]) -> i64 {
    assert_eq!(phases.len(), 5);
    let mut amps: Vec<Amplifier> = Vec::with_capacity(5);
    for phase in phases {
        let mut a = Amplifier::new(program);
        a.input_buffer.push(*phase);
        amps.push(a);
    }
    // Seed the first amplifier
    amps[0].input_buffer.push(0);

    let mut term_count = 0;
    loop {
        if term_count >= 5 {
            // all amplifiers have finished
            break;
        }
        for idx in 0..5 {
            //eprintln!(" -- Amp {}, tc = {} --", idx, term_count);
            if term_count >= 5 {
                break;
            }
            match amps[idx].process() {
                State::InputWaiting => {
                    // Can't do anything if it's waiting for input, so
                    // we pass and hope that the next loop will come
                    // with an input
                    //eprintln!("Waiting for input");
                    break;
                }
                State::OutputReady => {
                    // Output is ready, so we take it and push it into
                    // the next amplifier's input stage
                    let val = amps[idx].output_buffer.remove(0);
                    amps[(idx + 1) % 5].input_buffer.push(val);
                }
                State::Term => {
                    term_count += 1;
                }
                State::Err => panic!(),
                State::Running => panic!(),
            }
        }
    }

    // At the end the final output has been put into the first amplifier's
    // input buffer
    assert_eq!(amps[0].input_buffer.len(), 1);
    amps[0].input_buffer[0]
}

fn max_feedback_loop(program: &[i64]) -> i64 {
    let mut phases = vec![5, 6, 7, 8, 9];
    let mut heap = permutohedron::Heap::new(&mut phases);
    let mut biggest = 0;
    while let Some(perm) = heap.next_permutation() {
        let try_out = feedback_loop(program, perm);
        if try_out > biggest {
            biggest = try_out;
        }
    }

    biggest
}

#[cfg(test)]
mod test {
    use super::*;
    use log::{debug, trace};
    #[test]
    fn day_2_test_1() {
        init_log();
        trace!("Starting test");
        debug!("debug");
        let program = vec![1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50];
        let mut amp = Amplifier::new(&program);
        match amp.process() {
            State::Term => {
                assert_eq!(amp.program[0], 3500);
            }
            s => panic!("Unexpected state: {:?}", s),
        }
    }

    #[test]
    fn day_2_test_2() {
        let program = vec![1, 0, 0, 0, 99];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.program[0], 2);
    }

    #[test]
    fn day_2_test_3() {
        let program = vec![2, 3, 0, 3, 99];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.program[3], 6);
    }

    #[test]
    fn day_2_test_4() {
        let program = vec![2, 4, 4, 5, 99, 0];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.program[5], 9801);
    }

    #[test]
    fn day_2_test_5() {
        let program = vec![1, 1, 1, 4, 99, 5, 6, 0, 99];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.program[0], 30);
        assert_eq!(amp.program[4], 2);
    }

    #[test]
    fn day_5_test_1() {
        // Test the input and output instructions
        let program = vec![3, 0, 4, 0, 99];
        for idx in -10..10 {
            let mut amp = Amplifier::new(&program);

            assert_eq!(amp.process(), State::InputWaiting);
            // Waiting for input, so we give it some and let it continue
            //eprintln!("Sending some input");
            amp.input_buffer.push(idx);

            assert_eq!(amp.process(), State::OutputReady);
            // There's some output available, so print it and continue
            //eprintln!("Output: {:?}", amp.output_buffer);

            assert_eq!(amp.process(), State::Term);
            assert_eq!(amp.output_buffer[0], idx);
        }
    }

    #[test]
    fn day_5_test_2() {
        // Test the parameter indirection modes
        let program = vec![1002, 4, 3, 4, 33];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
    }

    #[test]
    fn day_5_test_3() {
        // Position-mode equal to 8
        let program = vec![3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8];
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
        let program = vec![3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8];
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
        let program = vec![3, 3, 1108, -1, 8, 3, 4, 3, 99];
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
        let program = vec![3, 3, 1107, -1, 8, 3, 4, 3, 99];
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
        let program =
            vec![3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9];
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
        let program = vec![3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1];
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
    fn day_5_test_9() {
        // "Larger example"
        let program = vec![
            3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31,
            1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104,
            999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99,
        ];
        for idx in 5..10 {
            let mut amp = Amplifier::new(&program);
            assert_eq!(amp.process(), State::InputWaiting);
            amp.input_buffer.push(idx);

            // Check that it produces the correct output
            assert_eq!(amp.process(), State::OutputReady);
            let correct = match idx.cmp(&8) {
                std::cmp::Ordering::Less => 999,
                std::cmp::Ordering::Equal => 1000,
                std::cmp::Ordering::Greater => 1001,
            };
            // let correct = if idx == 8 {
            //     1000
            // } else if idx < 8 {
            //     999
            // } else {
            //     1001
            // };
            assert_eq!(amp.output_buffer[0], correct);

            // Check that it terminated properly
            assert_eq!(amp.process(), State::Term);
        }
    }

    #[test]
    fn day_7_test_1() {
        let program = vec![
            3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0,
        ];

        assert_eq!(phase_sequence(&program, &vec![4, 3, 2, 1, 0]), 43210);
    }

    #[test]
    fn day_7_test_2() {
        let program = vec![
            3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23, 101, 5, 23, 23,
            1, 24, 23, 23, 4, 23, 99, 0, 0,
        ];

        assert_eq!(max_phase_sequence(&program), 54321);
    }

    #[test]
    fn day_7_test_3() {
        let program = vec![
            3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33,
            1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0,
        ];
        assert_eq!(max_phase_sequence(&program), 65210);
    }

    #[test]
    fn day_7_test_4() {
        let program = vec![
            3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26, 27, 4,
            27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5,
        ];
        assert_eq!(feedback_loop(&program, &[9, 8, 7, 6, 5]), 139629729);
    }

    #[test]
    fn day_7_test_5() {
        let program = vec![
            3, 52, 1001, 52, -5, 52, 3, 53, 1, 52, 56, 54, 1007, 54, 5, 55,
            1005, 55, 26, 1001, 54, -5, 54, 1105, 1, 12, 1, 53, 54, 53, 1008,
            54, 0, 55, 1001, 55, 1, 55, 2, 53, 55, 53, 4, 53, 1001, 56, -1, 56,
            1005, 56, 6, 99, 0, 0, 0, 0, 10,
        ];
        assert_eq!(max_feedback_loop(&program), 18216);
    }

    #[test]
    fn day_9_test_1() {
        let program = vec![109, 19, 99];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.relative_base, 19);
    }

    #[test]
    fn day_9_test_2() {
        let program = vec![109, 19, 204, -34, 99];
        let mut amp = Amplifier::new(&program);
        amp.program.append(&mut vec![0; 2030]);
        amp.relative_base = 2000;
        assert_eq!(amp.process(), State::OutputReady);
        assert_eq!(amp.output_buffer[0], 0);
    }

    #[test]
    fn day_9_test_3() {
        // Quine
        let program = vec![
            109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101,
            0, 99,
        ];
        let mut amp = Amplifier::new(&program);
        amp.program.append(&mut vec![0; 1000]);

        eprintln!("Length of program is {}", amp.program.len());
        loop {
            match amp.process() {
                State::Term => break,
                State::OutputReady => print!("."),
                _ => {}
            }
        }

        eprintln!("\nOutput is: {:?}", amp.output_buffer);

        assert_eq!(
            amp.output_buffer,
            vec![
                1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101,
                0, 99, 0,
            ]
        );
    }

    #[test]
    fn day_9_test_4() {
        let program = vec![1102, 34915192, 34915192, 7, 4, 7, 99, 0];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::OutputReady);
        assert_eq!(amp.process(), State::Term);
        eprintln!("Number is: {:?}", amp.output_buffer);
        assert_eq!(amp.output_buffer[0], 1219070632396864);
    }

    #[test]
    fn day_9_test_5() {
        let program = vec![104, 1125899906842624, 99];
        let mut amp = Amplifier::new(&program);
        assert_eq!(amp.process(), State::OutputReady);
        assert_eq!(amp.process(), State::Term);
        eprintln!("Number is: {:?}", amp.output_buffer);
        assert_eq!(amp.output_buffer[0], 1125899906842624);
    }

    #[test]
    fn day_9_test_6() {
        // Reflect input to output in relative mode
        let program = vec![109, 1, 203, 2, 204, 2, 99];
        let mut amp = Amplifier::new(&program);
        amp.input_buffer.push(4);
        assert_eq!(amp.process(), State::OutputReady);
        assert_eq!(amp.process(), State::Term);
        assert_eq!(amp.output_buffer[0], 4);
    }
}
