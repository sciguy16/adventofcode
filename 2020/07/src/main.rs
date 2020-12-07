use lazy_static::lazy_static;
use regex::Regex;
use std::collections::HashMap;
use std::collections::HashSet;
use std::error::Error;
use std::fs::File;
use std::hash::Hash;
use std::io::{BufRead, BufReader};

lazy_static! {
    static ref CHILD_PARSE_REGEX: Regex =
        Regex::new(r"([0-9]+) ([a-z ]+) bags?[\.,]\s?").unwrap();
}

#[derive(Debug)]
struct Relation {
    /// e.g. "vibrant plum" bags contain...
    parent: String,
    /// e.g. ("dotted black", 6)
    children: HashMap<String, usize>,
}

impl PartialEq for Relation {
    fn eq(&self, rhs: &Self) -> bool {
        self.parent == rhs.parent
    }
}

impl Eq for Relation {}

impl Hash for Relation {
    fn hash<H>(&self, hasher: &mut H)
    where
        H: std::hash::Hasher,
    {
        self.parent.hash(hasher)
    }
}

impl Relation {
    pub fn from_string(inp: &str) -> Result<Self, &'static str> {
        // light red bags contain 1 bright white bag, 2 muted yellow bags.
        let mut spliterator = inp.split(" bags contain ");
        let parent = spliterator.next().unwrap().to_string();
        let children_string = spliterator.next().unwrap();
        println!("Parent: `{}`, children: `{}`", parent, children_string);

        // now:
        // Parent: `light red`
        // children: `1 bright white bag, 2 muted yellow bags.`

        let mut children: HashMap<String, usize> = Default::default();
        // child_string: 1 bright white bag
        for capture in CHILD_PARSE_REGEX.captures_iter(&children_string) {
            println!("cap: {:?}", capture);
            let count = capture[1].parse::<usize>().unwrap();
            let colour = capture[2].to_string();

            children.insert(colour, count);
        }
        Ok(Self { parent, children })
    }

    pub fn can_hold(&self, bag: &str) -> bool {
        self.children.contains_key(bag)
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello, world!");

    let file = File::open("input.txt")?;
    let data: Vec<Relation> = BufReader::new(file)
        .lines()
        .map(|x| Relation::from_string(&x.unwrap()).unwrap())
        .collect();

    let res = part_one(&data);
    println!("{} bags can eventually hold shiny gold!", res);

    let res = part_two(&data);
    println!("My shiny gold bag contains {} other bags!", res);

    Ok(())
}

fn part_one(relations: &[Relation]) -> usize {
    // Determine how many bags can contain a
    // * shiny gold bag
    // at any level of nesting

    //let mut valid_bags: HashSet<&Relation> = Default::default();

    // Get all bags which can hold a shiny gold bag directly
    let mut valid_bags: HashSet<&Relation> = relations
        .iter()
        .filter(|r| r.can_hold("shiny gold"))
        .collect();
    println!(
        "\n\nThese bags can hold shiny gold:\n{:?}",
        valid_bags
            .iter()
            .map(|r| &r.parent)
            .collect::<Vec<&String>>()
    );

    let mut previous_level: HashSet<&Relation> = valid_bags.clone();
    let mut next_level: HashSet<&Relation> = Default::default();

    loop {
        // for current level bags, check whether any can be held
        // if none can be held then break, otherwise save them into new level
        println!("Previous level: {:?}", previous_level);
        for rel in relations {
            for bag in &previous_level {
                if rel.can_hold(&bag.parent) {
                    println!(">> {} can hold {}", rel.parent, bag.parent);
                    next_level.insert(rel);
                    valid_bags.insert(rel);
                }
            }
        }

        println!(
            "Next level bags: {:?}",
            next_level
                .iter()
                .map(|r| &r.parent)
                .collect::<Vec<&String>>()
        );

        if next_level.is_empty() {
            println!("EMPTY NEXT LEVEL");
            break;
        }
        //panic!();
        previous_level = next_level;
        next_level = Default::default();
    }

    valid_bags.len()
}

fn part_two(relations_slice: &[Relation]) -> usize {
    // Start with shiny gold bag and count how many bags it contains
    let mut count: usize = 0;

    let mut relations: HashMap<&String, &Relation> = Default::default();
    for rel in relations_slice {
        relations.insert(&rel.parent, rel);
    }

    let mut previous_level: HashSet<(&Relation, usize)> = Default::default();
    let mut next_level: HashSet<(&Relation, usize)> = Default::default();

    previous_level
        .insert((relations.get(&"shiny gold".to_string()).unwrap(), 1));

    loop {
        for bag in previous_level.iter() {
            for (bag_type, rel) in relations.iter() {
                // For each bag in the previous level, note down what they
                // must contain (and add to the counter)
                if let Some(child_count) = bag.0.children.get(*bag_type) {
                    // "rel" is inside "bag"
                    println!(
                        "{} contains {} {} times",
                        bag.0.parent, rel.parent, child_count
                    );
                    count += bag.1 * child_count;
                    println!("-- running total: {}", count);
                    next_level.insert((rel, *child_count * bag.1));
                }
            }
        }

        if next_level.is_empty() {
            println!("EMPTY NEXT LEVEL");
            break;
        }

        previous_level = next_level;
        next_level = Default::default();
    }

    count
}

fn get_bag_types(relations: &[Relation]) -> HashSet<String> {
    // Build a Vec of all the children and parents for relations
    // and then dedup them
    let mut bag_types: HashSet<String> = relations
        .iter()
        .map(|r| r.children.keys())
        .flatten()
        .cloned()
        .collect();
    println!("\n------\nchildren: {:?}", bag_types);

    for rel in relations {
        bag_types.insert(rel.parent.clone());
    }

    //types_vec.sort();
    //types_vec.dedup();

    println!("\n-----\nbag types: {:?}", bag_types);

    bag_types
}

#[cfg(test)]
mod test {
    use super::*;

    fn test_data() -> Vec<Relation> {
        let data = [
    	"light red bags contain 1 bright white bag, 2 muted yellow bags.",
"dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
"bright white bags contain 1 shiny gold bag.",
"muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
"shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
"dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
"vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
"faded blue bags contain no other bags.",
"dotted black bags contain no other bags."];
        data.iter()
            .map(|line| Relation::from_string(&line).unwrap())
            .collect()
    }

    #[test]
    fn test_part_one() {
        let data = test_data();
        println!("data: {:?}", data);
        assert_eq!(data.len(), 9);
        assert_eq!(get_bag_types(&data).len(), 9);

        let res = part_one(&data);

        assert_eq!(res, 4);
    }

    #[test]
    fn test_part_two_ex_one() {
        let data = test_data();
        let res = part_two(&data);

        assert_eq!(res, 32);
    }

    #[test]
    fn test_part_two_ex_two() {
        let data: Vec<Relation> = [
            "shiny gold bags contain 2 dark red bags.",
            "dark red bags contain 2 dark orange bags.",
            "dark orange bags contain 2 dark yellow bags.",
            "dark yellow bags contain 2 dark green bags.",
            "dark green bags contain 2 dark blue bags.",
            "dark blue bags contain 2 dark violet bags.",
            "dark violet bags contain no other bags.",
        ]
        .iter()
        .map(|line| Relation::from_string(&line).unwrap())
        .collect();
        let res = part_two(&data);

        assert_eq!(res, 126);
    }
}
