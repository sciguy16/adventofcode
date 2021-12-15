use std::str::FromStr;

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
        let combination = {
            let samples = combination.samples.clone().map(|s| {
                let mut chars = s.chars().collect::<Vec<_>>();
                chars.sort_unstable();
                chars.iter().collect::<String>()
            });
            let digits = combination.digits.clone().map(|s| {
                let mut chars = s.chars().collect::<Vec<_>>();
                chars.sort_unstable();
                chars.iter().collect::<String>()
            });

            Combination { samples, digits }
        };
        // do stuff
        let digits = &combination.samples;
        let one = digits.iter().find(|d| d.len() == 2).unwrap();
        let four = digits.iter().find(|d| d.len() == 4).unwrap();
        let seven = digits.iter().find(|d| d.len() == 3).unwrap();
        let eight = digits.iter().find(|d| d.len() == 7).unwrap();

        // a is in 7 but not 1
        let _a = seven.chars().find(|c| !one.contains(*c)).unwrap();

        // length 5: 2, 3, 5
        let length_5 = combination
            .samples
            .iter()
            .filter(|d| d.len() == 5)
            .collect::<Vec<_>>();

        // length 6: 0, 6, 9
        let length_6 = combination
            .samples
            .iter()
            .filter(|d| d.len() == 6)
            .collect::<Vec<_>>();

        // of the length 5 numbers, only 3 contains all segments used in 7
        let three = *length_5
            .iter()
            .find(|d| seven.chars().all(|seg| d.contains(seg)))
            .unwrap();

        // of the length 6 numbers, only 6 is missing a segment from 1
        let six = *length_6
            .iter()
            .find(|d| !one.chars().all(|seg| d.contains(seg)))
            .unwrap();

        // of the length 5 numbers, only 5 is fully contained in 6
        let five = *length_5
            .iter()
            .find(|d| d.chars().all(|seg| six.contains(seg)))
            .unwrap();

        // only one length 5 number remains: 2
        let two = *length_5
            .iter()
            .find(|d| ![three, five].contains(d))
            .unwrap();

        // of the length 6 numbers, 4 embeds into 9 but not 0 or 6
        let nine = *length_6
            .iter()
            .find(|d| four.chars().all(|seg| d.contains(seg)))
            .unwrap();

        // only one length 6 number remains: 0
        let zero = *length_6.iter().find(|d| ![nine, six].contains(d)).unwrap();

        // now that we have all of the numbers, it only remains to substitute
        // them for the display digits
        let value = |d: &str| match d {
            x if x == zero => 0usize,
            x if x == one => 1,
            x if x == two => 2,
            x if x == three => 3,
            x if x == four => 4,
            x if x == five => 5,
            x if x == six => 6,
            x if x == seven => 7,
            x if x == eight => 8,
            x if x == nine => 9,
            x => panic!("{} not found", x),
        };

        let thousands = value(&combination.digits[0]);
        let hundreds = value(&combination.digits[1]);
        let tens = value(&combination.digits[2]);
        let ones = value(&combination.digits[3]);
        let number = thousands * 1000 + hundreds * 100 + tens * 10 + ones;
        println!("number: {}", number);
        total += number;
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
