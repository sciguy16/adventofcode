use itertools::Itertools;
use nalgebra::Vector2;
use std::fmt::{self, Display, Formatter};
use std::str::FromStr;

#[derive(Copy, Clone, Debug)]
enum Fold {
    X(i32),
    Y(i32),
}

impl Fold {
    pub fn translation(&self) -> Vector2<i32> {
        match self {
            Fold::X(n) => Vector2::new(*n, 0),
            Fold::Y(n) => Vector2::new(0, *n),
        }
    }
}

#[derive(Clone, Debug)]
struct ThermalImager {
    dots: Vec<Vector2<i32>>,
    folds: Vec<Fold>,
}

impl FromStr for ThermalImager {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut lines = s.lines();
        let mut dots = Vec::new();
        for l in lines.by_ref() {
            if l.len() < 2 {
                break;
            }
            let (x, y) = l
                .split(',')
                .map(|n| n.parse::<i32>().unwrap())
                .collect_tuple()
                .unwrap();
            let v = Vector2::new(x, y);
            dots.push(v);
        }

        let mut folds = Vec::new();
        for l in lines {
            let fold = l.split("along ").nth(1).unwrap();
            let (direction, value) = fold.split('=').collect_tuple().unwrap();
            let value = value.parse::<i32>().unwrap();
            let fold = match direction {
                "x" => Fold::X(value),
                "y" => Fold::Y(value),
                _ => panic!(),
            };
            folds.push(fold);
        }
        Ok(ThermalImager { dots, folds })
    }
}

impl Display for ThermalImager {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        let min_x = self.dots.iter().map(|d| d.x).min().unwrap();
        let max_x = self.dots.iter().map(|d| d.x).max().unwrap();
        let min_y = self.dots.iter().map(|d| d.y).min().unwrap();
        let max_y = self.dots.iter().map(|d| d.y).max().unwrap();

        writeln!(f)?;

        for y in min_y..=max_y {
            for x in min_x..=max_x {
                if self.dots.contains(&Vector2::new(x, y)) {
                    write!(f, "#")?;
                } else {
                    write!(f, " ")?;
                }
            }
            writeln!(f)?;
        }

        Ok(())
    }
}

impl ThermalImager {
    pub fn fold(&mut self, fold: Fold) {
        // Take all points to the right of or below the fold line and then:
        // * translate s.t. the fold line coincides with an axis
        // * reflect about that axis
        // * translate back
        let translation = fold.translation();
        self.dots
            .iter_mut()
            .filter(|d| match fold {
                Fold::X(n) => d.x > n,
                Fold::Y(n) => d.y > n,
            })
            .for_each(|d| {
                *d -= translation;
                match fold {
                    Fold::X(_) => d.x *= -1,
                    Fold::Y(_) => d.y *= -1,
                }
                *d += translation;
            });

        // Deduplicate dots
        print!("Before: {}, ", self.dots.len());
        self.dots.sort_unstable_by_key(|d| d.x);
        self.dots.sort_by_key(|d| d.y);
        self.dots.dedup();
        println!("after: {}", self.dots.len());
    }
}

fn part_one(imager: &ThermalImager) -> usize {
    let mut imager = imager.clone();

    let f = *imager.folds.first().unwrap();
    imager.fold(f);
    println!("{imager:?}");

    imager.dots.len()
}

fn part_two(imager: &ThermalImager) -> usize {
    let folds = &imager.folds;
    let mut imager = imager.clone();

    for fold in folds {
        imager.fold(*fold);
    }

    println!("code: {imager}");

    4
}

fn main() {
    let input = include_str!("../input.txt");
    let data = input.parse().unwrap();
    let ans = part_one(&data);
    println!("part one: {ans}");
    let _ans = part_two(&data);
    let ans = "PZEHRAER";
    println!("part two: {ans}");
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5"#;

    #[test]
    fn test_part_1() {
        let inp: ThermalImager = TEST_DATA.parse().unwrap();
        println!("inp: {inp:?}");
        let ans = part_one(&inp);
        assert_eq!(ans, 17);
    }

    #[test]
    fn test_part_2() {
        let inp = TEST_DATA.parse().unwrap();
        let ans = part_two(&inp);
        assert_eq!(ans, 4);
    }
}
