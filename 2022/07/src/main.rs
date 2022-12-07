use color_eyre::{eyre::eyre, Result};
use std::collections::HashMap;

const THRESHOLD: usize = 100000;
const FS_SIZE: usize = 70000000;
const SPACE_NEEDED: usize = 30000000;

#[derive(Debug, Default)]
struct Directory<'a> {
    inner: HashMap<&'a str, DirEntry<'a>>,
}

impl<'a> Directory<'a> {
    pub fn calculate_sizes(&self, sizes: &mut Vec<usize>) -> usize {
        let size = self.inner.values().map(|v| v.calculate_sizes(sizes)).sum();
        sizes.push(size);

        size
    }
}

#[derive(Debug)]
enum DirEntry<'a> {
    File { size: usize },
    Dir { entries: Directory<'a> },
}

impl Default for DirEntry<'_> {
    fn default() -> Self {
        DirEntry::Dir {
            entries: Default::default(),
        }
    }
}

impl DirEntry<'_> {
    pub fn file(size: usize) -> Self {
        Self::File { size }
    }

    pub fn dir() -> Self {
        Self::Dir {
            entries: Default::default(),
        }
    }

    pub fn calculate_sizes(&self, sizes: &mut Vec<usize>) -> usize {
        match self {
            DirEntry::File { size } => *size,
            DirEntry::Dir { entries } => entries.calculate_sizes(sizes),
        }
    }
}

impl<'a> Directory<'a> {
    fn from_str(inp: &'a str) -> Result<Directory<'a>> {
        let mut fs = Directory::default();

        let mut path = Vec::new();

        for line in inp.lines().map(str::trim) {
            if let Some('$') = line.chars().next() {
                // instruction
                let mut parts = line.split(' ');
                let _ = parts.next();
                match parts.next() {
                    Some("cd") => {
                        // change dir
                        match parts.next() {
                            Some("/") => {
                                // return to root
                                path.clear();
                            }
                            Some("..") => {
                                // go up 1
                                path.pop();
                            }
                            Some(dir) => {
                                // move up the tree
                                path.push(dir);
                            }
                            None => Err(eyre!("Malformed command"))?,
                        }
                        // println!("cd: now in {path:?}");
                    }
                    Some("ls") => {
                        // list files, no argument
                        assert!(parts.next().is_none(), "Malformed command");
                    }
                    other => Err(eyre!("Unexpected command: {:?}", other))?,
                }
            } else {
                // output
                let mut parts = line.split(' ');
                let first_part = parts.next().unwrap();
                let name = parts.next().unwrap();

                // get direntry for current dir
                // start at root and walk up
                let mut current = &mut fs;
                for level in &path {
                    let DirEntry::Dir{entries,  }  =
                        current.inner.entry(level).or_default()else{panic!()};
                    current = entries;
                }

                if first_part == "dir" {
                    current.inner.insert(name, DirEntry::dir());
                } else {
                    current
                        .inner
                        .insert(name, DirEntry::file(first_part.parse()?));
                }
            }
        }

        Ok(fs)
    }
}

fn solve(inp: &Directory) -> (usize, usize) {
    let mut used_space = 0;

    let mut dir_sizes = Vec::new();

    for entry in inp.inner.values() {
        match entry {
            DirEntry::Dir { entries } => {
                let size = entries.calculate_sizes(&mut dir_sizes);
                used_space += size;
            }
            DirEntry::File { size } => used_space += size,
        }
    }

    // dbg!(used_space);
    // dbg!(&dir_sizes);

    let total_size =
        dir_sizes.iter().filter(|s| **s <= THRESHOLD).sum::<usize>();

    // dbg!(used_space);
    let available_space = FS_SIZE - used_space;
    let need_to_delete = SPACE_NEEDED - available_space;
    // dbg!(available_space);
    // dbg!(need_to_delete);

    // need to delete smallest file larger than need_to_delete
    let dir_to_del = dir_sizes
        .iter()
        .filter(|s| **s >= need_to_delete)
        .min()
        .unwrap();

    (total_size, *dir_to_del)
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let input = include_str!("../input.txt");
    let data = Directory::from_str(input)?;
    // dbg!(&data);
    let (ans1, ans2) = solve(&data);
    println!("part one: {ans1}");
    println!("part two: {ans2}");
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"#;

    #[test]
    fn test_part_1() {
        let inp = Directory::from_str(TEST_DATA).unwrap();
        dbg!(&inp);
        let (ans, _) = solve(&inp);
        assert_eq!(ans, 95437);
    }

    #[test]
    fn test_part_2() {
        let inp = Directory::from_str(TEST_DATA).unwrap();
        let (_, ans) = solve(&inp);
        assert_eq!(ans, 24933642);
    }
}
