use color_eyre::Result;
use std::{collections::HashSet, str::FromStr};

struct DataType {
    rules: HashSet<(u8, u8)>,
    pages_with_rules: HashSet<u8>,
    pages: Vec<Vec<u8>>,
}

impl FromStr for DataType {
    type Err = color_eyre::Report;

    fn from_str(inp: &str) -> std::result::Result<Self, Self::Err> {
        enum State {
            Rules,
            Pages,
        }
        let mut state = State::Rules;

        let mut rules = HashSet::new();
        let mut pages = Vec::new();

        let mut staging_vec = Vec::new();
        for line in inp.lines() {
            match &state {
                State::Rules => {
                    if line.is_empty() {
                        state = State::Pages;
                        continue;
                    }

                    staging_vec.clear();
                    staging_vec.extend(
                        line.split('|')
                            .map(str::parse::<u8>)
                            .map(Result::unwrap),
                    );
                    let [first, second] = staging_vec[..] else {
                        panic!()
                    };
                    assert!(rules.insert((first, second)));
                }
                State::Pages => {
                    pages.push(
                        line.split(',')
                            .map(str::parse::<u8>)
                            .map(Result::unwrap)
                            .collect(),
                    );
                }
            }
        }

        let pages_with_rules =
            rules.iter().flat_map(|&(a, b)| [a, b]).collect();

        Ok(Self {
            rules,
            pages_with_rules,
            pages,
        })
    }
}

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
enum Sorted {
    Sorted,
    NotSorted(usize),
}

impl Sorted {
    fn is_sorted(self) -> bool {
        matches!(self, Self::Sorted)
    }
}

fn is_sorted(page: &[u8], data: &DataType) -> Sorted {
    // check whether all pairs of (number, number that comes somewhere after)
    // are in the rules
    for (idx, left) in page.iter().enumerate().take(page.len() - 1) {
        for right in page.iter().skip(idx + 1) {
            if !data.rules.contains(&(*left, *right)) {
                return Sorted::NotSorted(idx);
            }
        }
    }
    Sorted::Sorted
}

fn part_one(inp: &DataType) -> u64 {
    inp.pages
        .iter()
        .filter(|page| is_sorted(page, inp).is_sorted())
        .map(|page| page[page.len() / 2] as u64)
        .sum()
}

fn sort(pages: &[u8], inp: &DataType) -> Vec<u8> {
    let mut pages = pages.to_vec();
    while let Sorted::NotSorted(mut not_sorted_idx) = is_sorted(&pages, inp) {
        dbg!(not_sorted_idx);
        if not_sorted_idx == 0 {
            not_sorted_idx = 1;
        }
        pages.swap(not_sorted_idx, not_sorted_idx.checked_sub(1).unwrap());
    }
    pages
}

fn part_two(inp: &DataType) -> u64 {
    for pages in &inp.pages {
        dbg!(pages);
        sort(pages, inp);
    }
    0
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data = input.parse()?;
    let ans = part_one(&data);
    println!("part one: {}", ans);
    let ans = part_two(&data);
    println!("part two: {}", ans);
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "\
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47";

    #[test]
    fn test_is_sorted() {
        let inp = TEST_DATA.parse().unwrap();
        let cases: &[(&[u8], _)] = &[
            (&[47, 53, 13], Sorted::Sorted),
            (&[47, 97, 53, 13], Sorted::NotSorted(0)),
            (&[97, 47, 53, 13], Sorted::Sorted),
        ];

        for &(page, expected) in cases {
            eprintln!("{page:?}: {expected:?}");
            assert_eq!(is_sorted(page, &inp), expected);
        }
    }

    #[test]
    fn test_sort() {
        let inp = TEST_DATA.parse().unwrap();
        let cases: &[(&[u8], &[u8])] = &[
            (&[47, 97, 53, 13], &[97, 47, 53, 13]),
            // (&[61, 13, 29], &[61, 29, 13]),
        ];
        for &(page, expected) in cases {
            assert_eq!(sort(page, &inp), expected);
        }
    }

    #[test]
    fn test_part_1() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_one(&inp);
        assert_eq!(ans, 143);
    }

    // #[test]
    // fn test_part_2() {
    //     let inp = TEST_DATA.parse().unwrap();
    //     let ans = part_two(&inp);
    //     assert_eq!(ans, 0);
    // }
}
