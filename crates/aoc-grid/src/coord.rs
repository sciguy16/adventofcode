use std::{
    fmt::{Display, Formatter},
    ops::Add,
};

#[cfg(test)]
#[path = "coord_test.rs"]
mod coord_test;

#[derive(Copy, Clone, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Coord {
    pub x: i64,
    pub y: i64,
}

impl From<(i64, i64)> for Coord {
    fn from((x, y): (i64, i64)) -> Self {
        Self { x, y }
    }
}

impl Display for Coord {
    fn fmt(&self, fmt: &mut Formatter) -> std::fmt::Result {
        write!(fmt, "({}, {})", self.x, self.y)
    }
}

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub struct Vector {
    pub x: i64,
    pub y: i64,
}

impl From<(i64, i64)> for Vector {
    fn from((x, y): (i64, i64)) -> Self {
        Self { x, y }
    }
}

impl Add<Vector> for Coord {
    type Output = Self;
    fn add(self, vector: Vector) -> Self {
        Self {
            x: self.x + vector.x,
            y: self.y + vector.y,
        }
    }
}

impl Add<Vector> for Vector {
    type Output = Self;
    fn add(self, vector: Vector) -> Self {
        Self {
            x: self.x + vector.x,
            y: self.y + vector.y,
        }
    }
}
