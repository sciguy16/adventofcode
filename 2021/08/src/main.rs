use std::str::FromStr;

struct Displays(Vec<Display>);
struct Display([char; 7]);

struct Combinations(Vec<Combination>);
impl FromStr for Combinations {
    type Err = Box<dyn std::error::Error>;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let inner = s
            .lines()
            .map(|l| l.parse::<Combination>())
            .collect::<Result<Vec<Combination>, _>>()?;
        Ok(Combinations(inner))
    }
}

struct Combination {
    samples: [String; 10],
    digits: [String; 4],
}

impl FromStr for Combination {
    type Err = Box<dyn std::error::Error>;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut spliterator = s.split(" | ");
        let samples = spliterator.next().unwrap();
        let digits = spliterator.next().unwrap();

        let samples = samples
            .split(' ')
            .map(String::from)
            .collect::<Vec<_>>()
            .try_into()
            .unwrap();
        let digits = digits
            .split(' ')
            .map(String::from)
            .collect::<Vec<_>>()
            .try_into()
            .unwrap();
        Ok(Combination { samples, digits })
    }
}

fn part_one(combinations: &Combinations) -> usize {
    let mut total = 0;

    for combination in &combinations.0 {
        // Look for digits  1, 4, 7, 8
        // These digits use 2, 4, 3, 7 segments. Filter for those
        // lengths in the digits lists and count 'em
        total += combination
            .digits
            .iter()
            .filter(|d| [2, 4, 3, 7].contains(&d.len()))
            .count();
    }

    total
}

fn part_two(combinations: &Combinations) -> usize {
    let mut total = 0;

    for combination in &combinations.0 {
        // do stuff
        let digits = &combination.digits;
        let one = digits.iter().find(|d| d.len() == 2).unwrap();
        let four = digits.iter().find(|d| d.len() == 4).unwrap();
        let seven = digits.iter().find(|d| d.len() == 3).unwrap();
        let eight = digits.iter().find(|d| d.len() == 7).unwrap();

        // a is in 7 but not 1
        let a = seven.chars().find(|c| !one.contains(*c)).unwrap();
    }

    total
}

fn main() {
    println!("Hello, world!");
    let input = include_str!("../input.txt");
    let combinations: Combinations = input.parse().unwrap();
    let ans = part_one(&combinations);
    println!("part one: {}", ans);
    let ans = part_two(&combinations);
    println!("part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_INPUT_1: &str =
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf";
    const TEST_INPUT_2: &str = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce";

    #[test]
    fn test_part_1a() {
        let _combinations: Combinations = TEST_INPUT_1.parse().unwrap();
    }

    #[test]
    fn test_part_1b() {
        let combinations: Combinations = TEST_INPUT_2.parse().unwrap();
        let ans = part_one(&combinations);
        assert_eq!(ans, 26);
    }

    #[test]
    fn test_part_2() {
        let combinations: Combinations = TEST_INPUT_2.parse().unwrap();
        let ans = part_two(&combinations);
        assert_eq!(ans, 61229);
    }
}
