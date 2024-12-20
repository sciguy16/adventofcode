use color_eyre::Result;
use std::{collections::HashMap, str::FromStr, time::Instant};

struct DataType {
    start_state: char,
    steps: usize,
    states: HashMap<char, Subroutine>,
}

#[derive(Copy, Clone)]
struct Subroutine {
    when_zero: Action,
    when_one: Action,
}

#[derive(Copy, Clone)]
struct Action {
    write: bool,
    movement: Direction,
    next: char,
}

#[derive(Copy, Clone)]
enum Direction {
    Left,
    Right,
}

impl FromStr for Direction {
    type Err = ();
    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        Ok(match s {
            "left" => Self::Left,
            "right" => Self::Right,
            _ => panic!(),
        })
    }
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut lines = inp.lines();
        let start_state = lines
            .next()
            .unwrap()
            .strip_prefix("Begin in state ")
            .unwrap()
            .strip_suffix('.')
            .unwrap();
        assert_eq!(start_state.len(), 1);
        let start_state = start_state.chars().next().unwrap();

        let steps = lines
            .next()
            .unwrap()
            .strip_prefix("Perform a diagnostic checksum after ")
            .unwrap()
            .strip_suffix(" steps.")
            .unwrap()
            .parse()
            .unwrap();

        let mut states = HashMap::new();

        let state_regex = r"In state ([A-F]):
  If the current value is 0:
    - Write the value (0|1)\.
    - Move one slot to the (left|right)\.
    - Continue with state ([A-F])\.
  If the current value is 1:
    - Write the value (0|1)\.
    - Move one slot to the (left|right)\.
    - Continue with state ([A-F])\.";
        let state_regex = regex::Regex::new(state_regex).unwrap();

        for (
            _,
            [state_state, when_zero_write, when_zero_move, when_zero_next, when_one_write, when_one_move, when_one_next],
        ) in state_regex.captures_iter(inp).map(|c| c.extract())
        {
            let prev = states.insert(
                state_state.chars().next().unwrap(),
                Subroutine {
                    when_zero: Action {
                        write: when_zero_write.parse::<u8>().unwrap() != 0,
                        movement: when_zero_move.parse().unwrap(),
                        next: when_zero_next.chars().next().unwrap(),
                    },
                    when_one: Action {
                        write: when_one_write.parse::<u8>().unwrap() != 0,
                        movement: when_one_move.parse().unwrap(),
                        next: when_one_next.chars().next().unwrap(),
                    },
                },
            );
            assert!(prev.is_none());
        }

        Ok(Self {
            start_state,
            steps,
            states,
        })
    }
}

struct TuringMachine {
    tape: Vec<bool>,
    cursor: usize,
}

impl TuringMachine {
    fn new(size: usize) -> Self {
        Self {
            tape: vec![false; size],
            cursor: size / 2,
        }
    }

    fn count_ones(&self) -> usize {
        self.tape.iter().filter(|&&value| value).count()
    }

    fn write(&mut self, value: bool) {
        self.tape[self.cursor] = value;
    }

    fn read(&self) -> bool {
        self.tape[self.cursor]
    }

    fn move_(&mut self, direction: Direction) {
        self.cursor = match direction {
            Direction::Left => self.cursor.checked_sub(1).unwrap(),
            Direction::Right => self.cursor.checked_add(1).unwrap(),
        }
    }
}

fn part_one(inp: &DataType) -> u64 {
    let mut current_state = inp.start_state;
    let mut machine = TuringMachine::new(inp.steps.checked_mul(2).unwrap());

    for _ in 0..inp.steps {
        let state = inp.states.get(&current_state).unwrap();
        let action = if machine.read() {
            state.when_one
        } else {
            state.when_zero
        };
        machine.write(action.write);
        machine.move_(action.movement);
        current_state = action.next;
    }

    machine.count_ones() as u64
}

fn part_two(_inp: &DataType) -> u64 {
    0
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data = input.parse()?;

    let start = Instant::now();
    let ans = part_one(&data);
    let elapsed = start.elapsed();
    println!("part one: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    let start = Instant::now();
    let ans = part_two(&data);
    let elapsed = start.elapsed();
    println!("part two: {} in {} ms", ans, elapsed.as_secs_f32() * 1000.0);

    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.";

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse::<DataType>().unwrap();
        assert_eq!(inp.start_state, 'A');
        assert_eq!(inp.steps, 6);
        assert_eq!(inp.states.len(), 2);
        assert_eq!(inp.states.get(&'A').unwrap().when_zero.next, 'B');

        let ans = part_one(&inp);
        assert_eq!(ans, 3);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 0);
    }
}
