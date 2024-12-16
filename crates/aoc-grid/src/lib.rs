mod coord;
mod grid;

pub use coord::*;
pub use grid::*;

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum Direction {
    Up,
    Left,
    Down,
    Right,
}

impl Direction {
    pub fn vector(self) -> Vector {
        match self {
            Self::Up => (0, 1).into(),
            Self::Left => (-1, 0).into(),
            Self::Down => (0, -1).into(),
            Self::Right => (1, 0).into(),
        }
    }
}
