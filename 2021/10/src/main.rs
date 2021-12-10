#[derive(Copy, Clone, Debug, Eq, PartialEq)]
enum Token {
    Brace,
    Bracket,
    Paren,
    Angle,
}

impl Token {
    pub fn score(&self) -> u64 {
        use Token::*;
        match self {
            Brace => 1197,
            Bracket => 57,
            Paren => 3,
            Angle => 25137,
        }
    }
    pub fn score2(&self) -> u64 {
        use Token::*;
        match self {
            Brace => 3,
            Bracket => 2,
            Paren => 1,
            Angle => 4,
        }
    }
}

#[derive(Copy, Clone, Debug, Eq, PartialEq)]
enum TokenType {
    Open(Token),
    Close(Token),
}

impl TryFrom<char> for TokenType {
    type Error = String;

    fn try_from(value: char) -> Result<Self, Self::Error> {
        use Token::*;
        use TokenType::*;
        Ok(match value {
            '{' => Open(Brace),
            '}' => Close(Brace),
            '[' => Open(Bracket),
            ']' => Close(Bracket),
            '(' => Open(Paren),
            ')' => Close(Paren),
            '<' => Open(Angle),
            '>' => Close(Angle),
            t => return Err(format!("Invalid token: {}", t)),
        })
    }
}

fn part_one(programs: &[&'static str]) -> u64 {
    use TokenType::*;

    let mut token_stack = Vec::<Token>::new();
    let mut score: u64 = 0;

    // for each token in the input if OPEN then push to token stack
    // if CLOSE then pop the top of token stack. If it matches then OK,
    // else CORRUPTED
    // OPEN tokens are always valid
    // if CORRUPTED then add the offending input token's score to the score
    for program in programs {
        'program: for token in program.chars() {
            let token = TokenType::try_from(token).unwrap();
            match token {
                Open(t) => token_stack.push(t),
                Close(t) => {
                    // pop the top of the token stack and check whether it's
                    // okay
                    let last = token_stack.pop().unwrap();
                    if t != last {
                        // mismatch!
                        println!(
                            "Syntax error: got '{:?}', expected '{:?}'",
                            t, last
                        );
                        score += t.score();
                        break 'program;
                    }
                }
            }
        }
    }
    score
}

fn part_two(programs: &[&'static str]) -> u64 {
    use TokenType::*;

    let mut scores = Vec::<u64>::new();

    // for each token in the input if OPEN then push to token stack
    // if CLOSE then pop the top of token stack. If it matches then OK,
    // else CORRUPTED
    // OPEN tokens are always valid
    // if CORRUPTED then add the offending input token's score to the score
    for program in programs {
        let mut token_stack = Vec::<Token>::new();
        let mut bad = false;
        'program: for token in program.chars() {
            let token = TokenType::try_from(token).unwrap();
            match token {
                Open(t) => token_stack.push(t),
                Close(t) => {
                    // pop the top of the token stack and check whether it's
                    // okay
                    let last = token_stack.pop().unwrap();
                    if t != last {
                        // mismatch, ignore!
                        bad = true;
                        break 'program;
                    }
                }
            }
        }

        // Program has completed analysis.
        // If it was syntax error or complete then skip any further processing
        if bad || token_stack.is_empty() {
            continue;
        }
        // Otherwise, add up the score of the remaining completion string
        // under token_stack
        let mut score: u64 = 0;
        for token in token_stack.iter().rev() {
            score *= 5;
            score += token.score2();
        }
        scores.push(score);
    }

    scores.sort_unstable();
    scores[scores.len() / 2]
}

fn main() {
    println!("Hello, world!");
    let input = include_str!("../input.txt");
    let programs = input.lines().collect::<Vec<&'static str>>();
    let ans = part_one(&programs);
    println!("part one: {}", ans);
    let ans = part_two(&programs);
    println!("part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"#;

    #[test]
    fn test_part_1() {
        let programs = TEST_DATA.lines().collect::<Vec<&'static str>>();
        let ans = part_one(&programs);
        assert_eq!(ans, 26397);
    }

    #[test]
    fn test_part_2() {
        let programs = TEST_DATA.lines().collect::<Vec<&'static str>>();
        let ans = part_two(&programs);
        assert_eq!(ans, 288957);
    }
}
