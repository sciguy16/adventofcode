use std::collections::BTreeMap;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

#[derive(Copy, Clone)]
struct InsertionRule {
    left: u8,
    right: u8,
    output: u8,
}

impl Display for InsertionRule {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        write!(fmt, "{}{} -> {}", self.left, self.right, self.output)
    }
}

impl FromStr for InsertionRule {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        // CH -> B
        let chars = s.chars().map(|c| c as u8).collect::<Vec<_>>();

        Ok(Self {
            left: chars[0],
            right: chars[1],
            output: chars[6],
        })
    }
}

impl InsertionRule {
    pub fn matches(&self, left: u8, right: u8) -> bool {
        self.left == left && self.right == right
    }
}

#[derive(Clone)]
struct Polymer {
    inner: Vec<u8>,
    rules: Vec<InsertionRule>,
}

impl Display for Polymer {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        for c in &self.inner {
            write!(fmt, "{}", *c as char)?;
        }
        writeln!(fmt)
    }
}

impl FromStr for Polymer {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        // first line is starting polymer
        // then blank
        // then subsequent lines are insertion rules
        let mut lines = s.lines();
        let inner = lines.next().unwrap().chars().map(|c| c as u8).collect();
        lines.next();

        let mut rules = Vec::new();
        for l in lines {
            rules.push(l.parse().unwrap());
        }
        Ok(Self { inner, rules })
    }
}

impl Polymer {
    pub fn apply(&mut self, rules: &[InsertionRule]) {
        for idx in (0..self.inner.len() - 1).rev() {
            // iterate backwards through the list so that it can be
            // extended in-place without issue
            for rule in rules {
                if rule.matches(self.inner[idx], self.inner[idx + 1]) {
                    self.inner.insert(idx + 1, rule.output);
                    break;
                }
            }
        }
    }

    pub fn apply_fast(&mut self, rules: &[InsertionRule], buf: &mut Vec<u8>) {
        buf.clear();
        for idx in 0..self.inner.len() - 1 {
            // iterate backwards through the list so that it can be
            // extended in-place without issue
            unsafe {
                buf.push(*self.inner.get_unchecked(idx));
                for rule in rules {
                    if rule.matches(
                        *self.inner.get_unchecked(idx),
                        *self.inner.get_unchecked(idx + 1),
                    ) {
                        buf.push(rule.output);
                        break;
                    }
                }
            }
        }
        buf.push(unsafe { *self.inner.get_unchecked(self.inner.len() - 1) });
        std::mem::swap(&mut self.inner, buf);
    }

    pub fn counts(&self) -> BTreeMap<u8, usize> {
        let mut counts = BTreeMap::new();

        for c in &self.inner {
            if let Some(ele) = counts.get_mut(c) {
                *ele += 1;
            } else {
                counts.insert(*c, 1);
            }
        }

        counts
    }
}

fn part_one(inp: &Polymer) -> usize {
    let mut poly = inp.clone();
    let mut buf = Vec::new();
    for step in 0..10 {
        poly.apply_fast(&inp.rules, &mut buf);

        println!("step {}: {}", step + 1, poly);
    }

    let counts = poly.counts();
    //println!("counts: {:?}", counts);
    let most = counts.iter().max_by_key(|(_k, v)| *v).unwrap();
    let least = counts.iter().min_by_key(|(_k, v)| *v).unwrap();

    println!("most: {:?}, least: {:?}", most, least);

    most.1 - least.1
}

fn part_two(inp: &Polymer) -> usize {
    let mut poly = inp.clone();
    let mut buf = Vec::new();

    for _step in 0..40 {
        poly.apply_fast(&inp.rules, &mut buf);

        //println!("step {}: {}", step + 1, poly);
    }

    let counts = poly.counts();
    //println!("counts: {:?}", counts);
    let most = counts.iter().max_by_key(|(_k, v)| *v).unwrap();
    let least = counts.iter().min_by_key(|(_k, v)| *v).unwrap();

    println!("most: {:?}, least: {:?}", most, least);

    most.1 - least.1
}

fn main() {
    let input = include_str!("../input.txt");
    let data = input.parse().unwrap();
    let ans = part_one(&data);
    println!("part one: {}", ans);
    let ans = part_two(&data);
    println!("part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"#;

    #[test]
    fn test_rule_parse() {
        let r = "CH -> B";
        let r = r.parse::<InsertionRule>().unwrap();
        assert_eq!(r.left, b'C');
        assert_eq!(r.right, b'H');
        assert_eq!(r.output, b'B');
    }

    #[test]
    fn test_apply() {
        let mut inp: Polymer = TEST_DATA.parse().unwrap();
        println!("starting polymer: {}", inp);
        let r = InsertionRule {
            left: b'N',
            right: b'C',
            output: b'J',
        };
        inp.apply(&[r]);
        println!("after: {}", inp);
        assert_eq!(inp.to_string().trim(), "NNJCB");

        inp.inner = "NNCBNNCBNNCB".chars().map(|c| c as u8).collect();
        inp.apply(&[r]);
        assert_eq!(inp.to_string().trim(), "NNJCBNNJCBNNJCB");
    }

    #[test]
    fn test_apply_fast() {
        let mut inp: Polymer = TEST_DATA.parse().unwrap();
        println!("starting polymer: {}", inp);
        let r = InsertionRule {
            left: b'N',
            right: b'C',
            output: b'J',
        };
        let mut buf = Vec::new();
        inp.apply_fast(&[r], &mut buf);
        println!("after: {}", inp);
        assert_eq!(inp.to_string().trim(), "NNJCB");

        inp.inner = "NNCBNNCBNNCB".chars().map(|c| c as u8).collect();
        inp.apply(&[r]);
        assert_eq!(inp.to_string().trim(), "NNJCBNNJCBNNJCB");
    }

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        println!("starting polymer: {}", inp);
        let ans = part_one(&inp);
        assert_eq!(ans, 1588);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 42188189693529);
    }
}
