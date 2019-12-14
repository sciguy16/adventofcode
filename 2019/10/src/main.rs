use std::fmt;
use ndarray::{
    ArrayBase,
    Array2,
};

#[derive(Copy, Clone, Debug, PartialEq)]
struct Point(i32, i32);

#[derive(Debug)]
struct Map {
    asteroids: Array2<bool>,
    width: usize,
    height: usize,
}

impl Map {
    fn new(source: &str, width: usize, height: usize) -> Self {
        let mut asteroids = Array2::from_elem((width, height), false);
        for (rownum, line) in source.lines().enumerate() {
            for (colnum, point) in line.trim().chars().enumerate() {
                asteroids[[rownum, colnum]] = match point {
                    '.' => false,
                    '#' => true,
                    x => panic!("Invalid character: {}", x),
                }
            }
        }
        Self {
            asteroids,
            width,
            height,
        }
    }
}

impl fmt::Display for Map {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for row in self.asteroids.outer_iter() {
            write!(f, "{}\n", row
                   //.map(|x| { String::from(x) })
                   .fold(String::new(), |acc, x| format!("{}{}", acc, match x {
                       true => '#',
                       false => '.',
                   }))
                  )?;
        }
        Ok(())
    }
}

fn row_from(source: &str) -> Vec<bool> {
    let mut row: Vec<bool> = Vec::with_capacity(source.len());
    for point in source.trim().chars() {
        row.push(
            match point {
                '.' => false,
                '#' => true,
                x => panic!("Invalid character: {}", x),
            }
            );
    }
    row
}

fn main() {
    let map = Map::new("input.txt", 5, 5); // TODO fix this
    let z = Point(0, 0);
    println!("Can be seen: {:?}", can_be_seen(z, z, &map));
}

fn can_be_seen(origin: Point, target: Point, map: &Map) -> bool {
    false
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_1() {
        let map_str =
            ".#..#
            .....
            #####
            ....#
            ...##";
        let height = map_str.lines().count();
        let width = map_str.lines().next().unwrap().trim().len();
        let map = Map::new(
            map_str,
            width,
            height,
            );

        println!("Map: {:?}", map);
        println!("Formatted properly:\n{}", map);

        panic!();
    }
}
