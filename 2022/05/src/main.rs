use color_eyre::{eyre::eyre, Result};
use std::str::FromStr;

fn transpose_stacks(inp: &[Vec<Option<char>>]) -> Vec<Vec<char>> {
    let number_of_stacks = inp.iter().map(|row| row.len()).max().unwrap();
    let mut stacks = vec![Vec::new(); number_of_stacks];

    for row in inp.iter().rev() {
        for (chr, stack) in row.iter().zip(stacks.iter_mut()) {
            if let Some(chr) = chr {
                stack.push(*chr);
            }
        }
    }

    stacks
}

struct DataType {
    stacks: Vec<Vec<char>>,
    instructions: Vec<Instruction>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut lines = inp.lines();

        // read in stacks
        let mut rows = Vec::new();
        for line in &mut lines {
            if line.is_empty() {
                // reached end of stacks
                break;
            }

            // iterate over the crates we can see at each height
            let mut row = Vec::new();
            for crate_name in line.chars().skip(1).step_by(4) {
                match crate_name {
                    'A'..='Z' => row.push(Some(crate_name)),
                    ' ' => row.push(None),
                    '1'..='9' | '[' | ']' => {}
                    other => Err(eyre!("Unexpected char `{}`", other))?,
                }
            }
            rows.push(row);
        }

        // transpose stacks
        // dbg!(&rows);
        let stacks = transpose_stacks(&rows);

        // read in instructions
        let instructions = lines
            .map(Instruction::from_str)
            .collect::<Result<Vec<_>, _>>()?;

        Ok(Self {
            stacks,
            instructions,
        })
    }
}

struct Instruction {
    count: usize,
    source: usize,
    dest: usize,
}

impl FromStr for Instruction {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        let mut split = inp.split(' ');
        let count = split.clone().nth(1).unwrap().parse()?;
        let source = split.clone().nth(3).unwrap().parse::<usize>()? - 1;
        let dest = split.nth(5).unwrap().parse::<usize>()? - 1;

        Ok(Self {
            count,
            source,
            dest,
        })
    }
}

fn part_one(inp: &DataType) -> String {
    let mut stacks = inp.stacks.clone();

    // apply the instructions
    for Instruction {
        count,
        source,
        dest,
    } in &inp.instructions
    {
        // println!("Stacks:\n{stacks:#?}");
        for _ in 0..*count {
            // print!("Move from {source} to {dest}: ");
            let tmp = stacks[*source].pop().unwrap();
            // println!("{tmp}");
            stacks[*dest].push(tmp);
        }
    }

    // get the top of each stack and form into a word
    stacks.iter().map(|stack| stack.last().unwrap()).collect()
}

fn part_two(inp: &DataType) -> String {
    let mut stacks = inp.stacks.clone();

    // apply the instructions
    let mut tmp = Vec::new();
    for Instruction {
        count,
        source,
        dest,
    } in &inp.instructions
    {
        tmp.clear();
        for _ in 0..*count {
            // tmp will end up with the removed crates in reverse order
            tmp.push(stacks[*source].pop().unwrap());
        }
        stacks[*dest].extend(tmp.iter().rev());
    }

    // get the top of each stack and form into a word
    stacks.iter().map(|stack| stack.last().unwrap()).collect()
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data = input.parse()?;
    let ans = part_one(&data);
    println!("part one: {ans}");
    let ans = part_two(&data);
    println!("part two: {ans}");
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"#;

    #[test]
    fn test_transpose_stacks() {
        // use above test data
        let input = &[
            vec![None, Some('D')],
            vec![Some('N'), Some('C')],
            vec![Some('Z'), Some('M'), Some('P')],
        ];
        let stacks = transpose_stacks(input);
        assert_eq!(stacks.len(), 3);
        assert_eq!(stacks[0].len(), 2);
        assert_eq!(stacks[1].len(), 3);
        assert_eq!(stacks[2].len(), 1);

        let parsed: DataType = TEST_DATA.parse().unwrap();
        assert_eq!(parsed.stacks, stacks);
    }

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, "CMZ");
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, "MCD");
    }
}
