fn part_one(_inp: &str) -> usize {
    todo!()
}

fn part_two(_inp: &str) -> usize {
    todo!()
}

fn main() {
    let input = include_str!("../input.txt");
    let data = input;
    let ans = part_one(data);
    println!("part one: {}", ans);
    let ans = part_two(data);
    println!("part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#""#;

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA;
        let ans = part_one(inp);
        assert_eq!(ans, 4);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA;
        let ans = part_two(inp);
        assert_eq!(ans, 4);
    }
}
