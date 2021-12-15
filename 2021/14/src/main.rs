use std::collections::BTreeMap;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

#[derive(Copy, Clone)]
struct InsertionRule {
    left: char,
    right: char,
    output: char,
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
        let chars = s.chars().collect::<Vec<_>>();

        Ok(Self {
            left: chars[0],
            right: chars[1],
            output: chars[6],
        })
    }
}

impl InsertionRule {
    pub fn matches(&self, left: char, right: char) -> bool {
        self.left == left && self.right == right
    }
}

#[derive(Clone)]
struct Polymer {
    inner: Vec<char>,
    rules: Vec<InsertionRule>,
}

impl Display for Polymer {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        for c in &self.inner {
            write!(fmt, "{}", c)?;
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
        let inner = lines.next().unwrap().chars().collect();
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

    pub fn apply_fast(&mut self, rules: &[InsertionRule], buf: &mut Vec<char>) {
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

    pub fn counts(&self) -> BTreeMap<char, usize> {
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

struct PolymerBTree {
    inner: BTreeMap<(char, char), isize>,
}

impl Display for PolymerBTree {
    fn fmt(&self, fmt: &mut Formatter) -> fmt::Result {
        for ((l, r), c) in &self.inner {
            writeln!(fmt, "{}{} => {}", *l as char, *r as char, c)?;
        }
        writeln!(fmt)
    }
}

impl From<&Polymer> for PolymerBTree {
    fn from(poly: &Polymer) -> Self {
        let mut inner = BTreeMap::new();

        for pair in poly.inner.windows(2) {
            *inner.entry((pair[0], pair[1])).or_default() += 1;
        }

        Self { inner }
    }
}

impl PolymerBTree {
    pub fn apply(
        &mut self,
        rules: &[InsertionRule],
        buf: &mut BTreeMap<(char, char), isize>,
    ) {
        // Apply rules to each pair, tracking the changes in buf
        // merge buf into self, then clear buf
        buf.clear();
        for (left, right) in self.inner.keys() {
            if let Some(r) = rules.iter().find(|r| r.matches(*left, *right)) {
                println!("Apply {}", r);
                // subtract one from current pair
                *buf.entry((*left, *right)).or_default() -= 1;
                // add one to (left, out) and (out, right)
                *buf.entry((*left, r.output)).or_default() += 1;
                *buf.entry((r.output, *right)).or_default() += 1;
            }
        }
        println!("Deltas: {:?}", buf);
        for (pair, delta) in buf.iter() {
            println!(
                "Adding {} to ({}, {})",
                delta, pair.0 as char, pair.1 as char
            );
            *self.inner.entry(*pair).or_default() += delta;
        }
        // Retain only elements that occur at least once
        self.inner.retain(|_k, v| *v > 0);
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

fn part_two(inp: &Polymer, limit: usize) -> usize {
    let mut poly = PolymerBTree::from(inp);

    let mut buf = BTreeMap::new();

    for step in 0..limit {
        poly.apply(&inp.rules, &mut buf);

        println!("step {}: {}", step + 1, poly);
    }

    // println!("counts: {:?}", counts);
    let most = poly.inner.iter().max_by_key(|(_k, v)| *v).unwrap();
    let least = poly.inner.iter().min_by_key(|(_k, v)| *v).unwrap();

    println!("most: {:?}, least: {:?}", most, least);

    (most.1 - least.1).try_into().unwrap()
}

fn main() {
    let input = include_str!("../input.txt");
    let data = input.parse().unwrap();
    let ans = part_one(&data);
    println!("part one: {}", ans);
    let ans = part_two(&data, 40);
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
        assert_eq!(r.left, 'C');
        assert_eq!(r.right, 'H');
        assert_eq!(r.output, 'B');
    }

    #[test]
    fn test_apply() {
        let mut inp: Polymer = TEST_DATA.parse().unwrap();
        println!("starting polymer: {}", inp);
        let r = InsertionRule {
            left: 'N',
            right: 'C',
            output: 'J',
        };
        inp.apply(&[r]);
        println!("after: {}", inp);
        assert_eq!(inp.to_string().trim(), "NNJCB");

        inp.inner = "NNCBNNCBNNCB".chars().collect();
        inp.apply(&[r]);
        assert_eq!(inp.to_string().trim(), "NNJCBNNJCBNNJCB");
    }

    #[test]
    fn test_apply_fast() {
        let mut inp: Polymer = TEST_DATA.parse().unwrap();
        println!("starting polymer: {}", inp);
        let r = InsertionRule {
            left: 'N',
            right: 'C',
            output: 'J',
        };
        let mut buf = Vec::new();
        inp.apply_fast(&[r], &mut buf);
        println!("after: {}", inp);
        assert_eq!(inp.to_string().trim(), "NNJCB");

        inp.inner = "NNCBNNCBNNCB".chars().collect();
        inp.apply(&[r]);
        assert_eq!(inp.to_string().trim(), "NNJCBNNJCBNNJCB");
    }

    #[test]
    fn test_btree_method() {
        let inp: Polymer = TEST_DATA.parse().unwrap();
        println!("starting polymer: {}", inp);
        let r = &[
            InsertionRule {
                left: 'N',
                right: 'C',
                output: 'J',
            },
            InsertionRule {
                left: 'N',
                right: 'N',
                output: 'G',
            },
            InsertionRule {
                left: 'G',
                right: 'N',
                output: 'N',
            },
        ];
        let mut buf = BTreeMap::new();
        let mut poly = PolymerBTree::from(&inp);

        // before: NNCB
        assert_eq!(poly.inner.len(), 3);
        assert_eq!(*poly.inner.get(&('N', 'N')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('N', 'C')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('C', 'B')).unwrap(), 1);
        poly.apply(r, &mut buf);
        // after: NGNJCB
        assert_eq!(poly.inner.len(), 5);
        assert_eq!(*poly.inner.get(&('N', 'G')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('G', 'N')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('N', 'J')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('J', 'C')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('C', 'B')).unwrap(), 1);
        poly.apply(r, &mut buf);
        // after NGNNJCB
        assert_eq!(poly.inner.len(), 6);
        assert_eq!(*poly.inner.get(&('N', 'G')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('G', 'N')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('N', 'N')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('N', 'J')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('J', 'C')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('C', 'B')).unwrap(), 1);
        poly.apply(r, &mut buf);
        // after NGNGNJCB
        println!("{}", poly);
        assert_eq!(poly.inner.len(), 5);
        assert_eq!(*poly.inner.get(&('N', 'G')).unwrap(), 2);
        assert_eq!(*poly.inner.get(&('G', 'N')).unwrap(), 2);
        assert_eq!(*poly.inner.get(&('N', 'J')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('J', 'C')).unwrap(), 1);
        assert_eq!(*poly.inner.get(&('C', 'B')).unwrap(), 1);
    }

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        println!("starting polymer: {}", inp);
        let ans = part_one(&inp);
        assert_eq!(ans, 1588);
    }

    //#[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp, 40);
        assert_eq!(ans, 42188189693529);
    }

    //  #[test]
    fn test_two_methods_interleaved() {
        let inp = TEST_DATA.parse().unwrap();
        let mut btreepoly = PolymerBTree::from(&inp);
        let mut poly = inp.clone();
        let mut buf = BTreeMap::new();

        println!("start: {}{}", poly, btreepoly);
        for step in 0..10 {
            poly.apply(&inp.rules);
            btreepoly.apply(&inp.rules, &mut buf);
            println!("step {}: {}{}", step + 1, poly, btreepoly)
        }

        let to_compare = PolymerBTree::from(&poly);
        println!("to compare: {}", to_compare);

        panic!()
    }

    //    #[test]
    fn compare_part_one_and_part_two() {
        let inp = TEST_DATA.parse().unwrap();
        println!("starting polymer: {}", inp);
        let ans = part_one(&inp);
        assert_eq!(ans, 1588);
        let ans = part_two(&inp, 10);
        assert_eq!(ans, 1588);
    }
}
