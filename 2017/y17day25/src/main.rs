use color_eyre::Result;
use std::{str::FromStr, time::Instant};

const FIRST_LETTER: u8 = b'A';

struct DataType {
    start_state: usize,
    steps: usize,
    states: Vec<Subroutine>,
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
    next: usize,
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
        let start_state = (start_state.as_bytes()[0] - FIRST_LETTER).into();

        let steps = lines
            .next()
            .unwrap()
            .strip_prefix("Perform a diagnostic checksum after ")
            .unwrap()
            .strip_suffix(" steps.")
            .unwrap()
            .parse()
            .unwrap();

        let mut states = Vec::with_capacity(6);

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
        let mut expected_letter = FIRST_LETTER.checked_sub(1).unwrap();
        for (
            _,
            [state_state, when_zero_write, when_zero_move, when_zero_next, when_one_write, when_one_move, when_one_next],
        ) in state_regex.captures_iter(inp).map(|c| c.extract())
        {
            // sense-check the state letters
            let cur_letter = state_state.as_bytes()[0];
            expected_letter += 1;
            assert_eq!(cur_letter, expected_letter);

            states.push(Subroutine {
                when_zero: Action {
                    write: when_zero_write.parse::<u8>().unwrap() != 0,
                    movement: when_zero_move.parse().unwrap(),
                    next: (when_zero_next.as_bytes()[0] - FIRST_LETTER).into(),
                },
                when_one: Action {
                    write: when_one_write.parse::<u8>().unwrap() != 0,
                    movement: when_one_move.parse().unwrap(),
                    next: (when_one_next.as_bytes()[0] - FIRST_LETTER).into(),
                },
            });
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
    furthest_left: usize,
    furthest_right: usize,
}

impl TuringMachine {
    fn new(size: usize) -> Self {
        Self {
            tape: vec![false; size],
            cursor: size / 2,
            furthest_left: size / 2,
            furthest_right: size / 2,
        }
    }

    fn count_ones(&self) -> usize {
        self.tape
            .iter()
            .skip(self.furthest_left)
            .take(1 + self.furthest_right - self.furthest_left)
            .filter(|&&value| value)
            .count()
    }

    fn write(&mut self, value: bool) {
        self.tape[self.cursor] = value;
    }

    fn read(&self) -> bool {
        self.tape[self.cursor]
    }

    fn move_(&mut self, direction: Direction) {
        match direction {
            Direction::Left => self.cursor -= 1,
            Direction::Right => self.cursor += 1,
        }
        self.furthest_left = self.furthest_left.min(self.cursor);
        self.furthest_right = self.furthest_right.max(self.cursor);
    }
}

fn part_one(inp: &DataType) -> u64 {
    let mut current_state = inp.start_state;
    let mut machine = TuringMachine::new(inp.steps.checked_mul(2).unwrap());

    for _ in 0..inp.steps {
        let state = inp.states.get(current_state).unwrap();
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
        assert_eq!(inp.start_state, 0);
        assert_eq!(inp.steps, 6);
        assert_eq!(inp.states.len(), 2);
        assert_eq!(inp.states[0].when_zero.next, 1);

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
