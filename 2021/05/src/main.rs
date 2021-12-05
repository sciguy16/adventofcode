use eyre::{eyre, Error};
#[cfg(debug_assertions)]
use owo_colors::OwoColorize;
use std::str::FromStr;

#[derive(Copy, Clone, Debug)]
enum Orientation {
    Horizontal,
    Vertical,
    Diagonal,
    Null,
}

#[derive(Debug, Eq, PartialEq)]
struct Line {
    start: (isize, isize),
    end: (isize, isize),
    length_squared: isize,
}

impl FromStr for Line {
    type Err = Error;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        // e.g. "728,451 -> 524,247"
        let normalised = s.replace(" -> ", ",");
        let mut spliterator = normalised.split(',');
        let start_x = spliterator
            .next()
            .ok_or_else(|| eyre!("insufficient numbers: {}", s))?
            .parse()?;
        let start_y = spliterator
            .next()
            .ok_or_else(|| eyre!("insufficient numbers: {}", s))?
            .parse()?;
        let end_x = spliterator
            .next()
            .ok_or_else(|| eyre!("insufficient numbers: {}", s))?
            .parse()?;
        let end_y = spliterator
            .next()
            .ok_or_else(|| eyre!("insufficient numbers: {}", s))?
            .parse()?;
        Ok(Self {
            start: (start_x, start_y),
            end: (end_x, end_y),
            length_squared: (start_x - end_x).pow(2) + (start_y - end_y).pow(2),
        })
    }
}

impl Line {
    pub fn orientation(&self) -> Orientation {
        use Orientation::*;
        match (self.start.0, self.start.1, self.end.0, self.end.1) {
            (x, y, a, b) if x == a && y == b => {
                // Start and end at the same point => null line
                Null
            }
            (x, _, a, _) if x == a => {
                // x coords match => vertical
                Vertical
            }
            (_, y, _, b) if y == b => {
                // y coords match => horizontal
                Horizontal
            }
            _ => {
                // coords all different => diagonal
                Diagonal
            }
        }
    }

    pub fn is_intersect(&self, (a, b): (isize, isize)) -> bool {
        const EPSILON: f32 = 10e-5;
        // distance from start to point + point to end ==? start to end
        let start_to_point =
            ((a - self.start.0).pow(2) + (b - self.start.1).pow(2)) as f32;
        let point_to_end =
            ((a - self.end.0).pow(2) + (b - self.end.1).pow(2)) as f32;

        //println!(
        //    "start to point: {start_to_point}, point to end: {point_to_end}"
        //);

        (start_to_point.sqrt() + point_to_end.sqrt()
            - (self.length_squared as f32).sqrt())
            < EPSILON
    }
}

#[derive(Debug)]
struct Lines {
    inner: Vec<Line>,
}

impl FromStr for Lines {
    type Err = Error;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let inner = s
            .lines()
            .map(|l| l.parse::<Line>())
            .collect::<Result<Vec<_>, _>>()?;
        Ok(Self { inner })
    }
}

impl Lines {
    pub fn bounds(&self) -> ((isize, isize), (isize, isize)) {
        let min = self
            .inner
            .iter()
            .map(|l| (l.start.0.min(l.end.0), l.start.1.min(l.end.1)))
            .reduce(|a, b| (a.0.min(b.0), a.1.min(b.1)))
            .unwrap_or_default();
        let max = self
            .inner
            .iter()
            .map(|l| (l.start.0.max(l.end.0), l.start.1.max(l.end.1)))
            .reduce(|a, b| (a.0.max(b.0), a.1.max(b.1)))
            .unwrap_or_default();
        (min, max)
    }

    pub fn intersection_count<F>(
        &self,
        pt: (isize, isize),
        constraint: F,
    ) -> usize
    where
        F: Fn(Orientation) -> bool,
    {
        self.inner
            .iter()
            .filter(|l| constraint(l.orientation()))
            .filter(|l| l.is_intersect(pt))
            .count()
    }
}

fn part_one<F>(lines: &Lines, constraint: F) -> usize
where
    F: Fn(Orientation) -> bool + Copy,
{
    // Iterate over each point, counting how many lines intersect. Count
    // the number of points which are intersected by more than one line
    //
    // but only horizontal or vertical lines
    let mut count = 0;

    let (lower, upper) = lines.bounds();

    for x in lower.0..=upper.0 {
        #[cfg(debug_assertions)]
        print!("{} ", x.green());
        for y in lower.1..=upper.1 {
            let intersections = lines.intersection_count((x, y), constraint);
            match intersections {
                n if n >= 2 => {
                    #[cfg(debug_assertions)]
                    print!("{}", n.white().on_blue().bold());
                    count += 1;
                }
                0 => {
                    #[cfg(debug_assertions)]
                    print!(".");
                }
                _n => {
                    #[cfg(debug_assertions)]
                    print!("{}", _n.white());
                }
            }
        }
        #[cfg(debug_assertions)]
        println!();
    }

    count
}

fn main() {
    use Orientation::*;
    println!("Hello, world!");
    let input = include_str!("../input.txt");
    let lines: Lines = input.parse().unwrap();

    let ans = part_one(&lines, |o| matches!(o, Horizontal | Vertical));
    println!("part one: {ans}");

    let ans = part_one(&lines, |_o| true);
    println!("part two: {ans}");
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"#;

    #[test]
    fn test_intersect() {
        let line: Line = "0,0 -> 0,5".parse().unwrap();
        println!("Line: {:?}", line);
        assert!(line.is_intersect((0, 2)));
        assert!(line.is_intersect((0, 0)));
        assert!(line.is_intersect((0, 5)));
        assert!(matches!(
            line.orientation(),
            Orientation::Horizontal | Orientation::Vertical
        ));
    }

    #[test]
    fn test_part_one() {
        use Orientation::*;
        let lines: Lines = TEST_DATA.parse().unwrap();
        assert_eq!(
            lines.inner[1],
            Line {
                start: (8, 0),
                end: (0, 8),
                length_squared: 128,
            }
        );
        let bounds = lines.bounds();
        assert_eq!(bounds, ((0, 0), (9, 9)));

        let ans = part_one(&lines, |o| matches!(o, Horizontal | Vertical));
        assert_eq!(ans, 5);
    }

    #[test]
    fn test_part_two() {
        let lines: Lines = TEST_DATA.parse().unwrap();

        let ans = part_one(&lines, |_o| true);
        assert_eq!(ans, 12);
    }
}
