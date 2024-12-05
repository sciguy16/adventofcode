#![allow(unused)]

use ndarray::{Array2, ArrayBase};
use std::cmp::{max, min};
use std::convert;
use std::fmt;
use std::ops;

#[derive(Copy, Clone, Debug, PartialEq)]
struct Point(usize, usize);

impl convert::From<(usize, usize)> for Point {
    fn from((x, y): (usize, usize)) -> Self {
        Self(x, y)
    }
}

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
            writeln!(
                f,
                "{}",
                row
                    //.map(|x| { String::from(x) })
                    .fold(String::new(), |acc, x| format!(
                        "{}{}",
                        acc,
                        match x {
                            true => '#',
                            false => '.',
                        }
                    ))
            )?;
        }
        Ok(())
    }
}

impl ops::Index<Point> for Map {
    type Output = bool;

    fn index(&self, point: Point) -> &Self::Output {
        // Convenience impl that allows points to be referenced directly
        // from Map by Points.
        &self.asteroids[[point.0, point.1]]
    }
}

fn row_from(source: &str) -> Vec<bool> {
    let mut row: Vec<bool> = Vec::with_capacity(source.len());
    for point in source.trim().chars() {
        row.push(match point {
            '.' => false,
            '#' => true,
            x => panic!("Invalid character: {}", x),
        });
    }
    row
}

fn main() {
    let map = Map::new("input.txt", 5, 5); // TODO fix this
    let z = Point(0, 0);
    println!("Can be seen: {:?}", can_be_seen(z, z, &map));
}

fn get_all_counts(map: &Map) -> Array2<usize> {
    let mut counts = Array2::from_elem(map.asteroids.raw_dim(), 0_usize);
    for (point, val) in map.asteroids.indexed_iter() {
        counts[[point.0, point.1]] =
            if *val { count_visible(point, map) } else { 0 };
    }
    counts
}

fn count_visible<T>(origin: T, map: &Map) -> usize
where
    T: Into<Point> + Copy,
{
    map.asteroids.indexed_iter().fold(0, |acc, x| {
        acc + match can_be_seen(origin.into(), (x.0).into(), map) {
            true => 1,
            false => 0,
        }
    })
}

fn can_be_seen(origin: Point, target: Point, map: &Map) -> bool {
    // The target has to be an asteroid
    if !map[target] {
        return false;
    }

    // Self doesn't count
    if origin == target {
        return false;
    }

    // Find integral points on the line segment joining 'orign' to
    // 'point' and check whether there's an asteroid there

    // y - y1 = m(x - x1) for any point (x1, y1) on the line.
    // => y = m(x - x1) + y1
    // Can find the integral points by iterating from min(x1, x2) to
    // max(x1, x2) and checking whether the corresponding y is integral
    // and then whether there is an asteroid
    let x1 = origin.0 as f32;
    let y1 = origin.1 as f32;
    let x2 = target.0 as f32;
    let y2 = target.1 as f32;
    let m: f32 = (y1 - y2) / (x1 - x2);
    let line = |x: usize| -> f32 {
        let x = x as f32;
        m * (x - (origin.0 as f32)) + origin.1 as f32
    };
    for x in (min(origin.0, target.0) + 1)..max(origin.0, target.0) {
        println!("x: {}, y: {}", x, line(x));
        let y = line(x);
        if y.fract() == 0f32 {
            // y has zero fractional part so it's basically an integer
            let y = y as usize;
            if map[Point(x, y)] {
                // There's an asteroid blocking the view
                println!("View is blocked");
                return false;
            }
        }
    }
    true
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_1() {
        let map_str = ".#..#
            .....
            #####
            ....#
            ...##";
        let height = map_str.lines().count();
        let width = map_str.lines().next().unwrap().trim().len();
        let map = Map::new(map_str, width, height);

        println!("Map: {map:?}");
        println!("Formatted properly:\n{map}");

        let origin = Point(0, 0);
        assert!(can_be_seen(origin, Point(2, 2), &map));
        assert!(!can_be_seen(origin, Point(4, 4), &map));

        println!("Calculating count");

        let count = count_visible(Point(0, 1), &map);
        assert_eq!(count, 7);
    }

    #[test]
    fn test_2() {
        let map_str = ".#..#
            .....
            #####
            ....#
            ...##";
        let height = map_str.lines().count();
        let width = map_str.lines().next().unwrap().trim().len();
        let map = Map::new(map_str, width, height);

        println!("Map: {map:?}");
        println!("Formatted properly:\n{map}");

        println!("All counts:\n{:?}", get_all_counts(&map));
        // panic!();
    }
}
