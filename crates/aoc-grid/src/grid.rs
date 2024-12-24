use crate::{coord::Coord, Direction};
use std::fmt::Display;

#[cfg(test)]
#[path = "grid_test.rs"]
mod grid_test;

#[derive(Clone)]
pub struct Grid<T> {
    inner: Vec<T>,
    width: i64,
    height: i64,
}

impl<T: Default> Grid<T> {
    pub fn new_default(width: i64, height: i64) -> Self {
        let vec_len = usize::try_from(width)
            .unwrap()
            .checked_mul(usize::try_from(height).unwrap())
            .unwrap();
        Self {
            width,
            height,
            inner: (0..vec_len).map(|_| T::default()).collect(),
        }
    }
}

impl<T> Grid<T> {
    #[must_use]
    pub fn new(data: impl Into<Vec<T>>, width: i64) -> Self {
        assert!(width > 0);
        let data = data.into();
        let data_len: i64 =
            data.len().try_into().expect("Data len exceeds i64::MAX");
        assert_eq!(
            data_len % width,
            0,
            "Data length is not a multiple of width"
        );
        let height = data_len / width;

        Self {
            inner: data,
            width,
            height,
        }
    }

    pub fn width(&self) -> i64 {
        self.width
    }
    pub fn height(&self) -> i64 {
        self.height
    }

    pub fn get(&self, at: impl Into<Coord>) -> Option<&T> {
        let at = at.into();
        if at.x < 0 || at.y < 0 || at.x >= self.width || at.y >= self.height {
            return None;
        }

        let offset = at.x + self.height * (self.height - 1 - at.y);
        let offset: usize =
            offset.try_into().expect("Offest out of range for usize");
        self.inner.get(offset)
    }

    pub fn set(&mut self, at: impl Into<Coord>, new: T) {
        let at = at.into();
        if at.x < 0 || at.y < 0 || at.x >= self.width || at.y >= self.height {
            panic!(
                "Coordinate {} out of bounds in a grid of dimension ({}, {})",
                at, self.width, self.height
            );
        }

        let offset = at.x + self.height * (self.height - 1 - at.y);
        let offset: usize =
            offset.try_into().expect("Offest out of range for usize");
        self.inner[offset] = new;
    }

    pub fn rows(&self) -> impl Iterator<Item = &[T]> + '_ {
        let width = self.width.try_into().unwrap();
        self.inner.chunks(width)
    }

    pub fn get_neighbour(
        &self,
        at: impl Into<Coord>,
        direction: Direction,
    ) -> Option<(Coord, &T)> {
        let at = at.into() + direction.vector();
        self.get(at).map(|val| (at, val))
    }

    fn idx_to_coord(&self, idx: usize) -> Coord {
        let idx: i64 = idx.try_into().unwrap();
        let x = idx % self.width;
        let y = self.height - 1 - (idx / self.height);
        (x, y).into()
    }

    pub fn find<F>(&self, mut condition: F) -> Option<Coord>
    where
        F: FnMut(&T) -> bool,
    {
        self.inner
            .iter()
            .enumerate()
            .find(|(_idx, cell)| condition(cell))
            .map(|(idx, _)| self.idx_to_coord(idx))
    }

    pub fn iter_cardinal_neighbours(
        &self,
        at: impl Into<Coord>,
    ) -> impl Iterator<Item = (Coord, &T)> {
        let at = at.into();
        Direction::iter().filter_map(move |dir| self.get_neighbour(at, dir))
    }

    pub fn iter(&self) -> impl Iterator<Item = (Coord, &T)> {
        self.inner
            .iter()
            .enumerate()
            .map(|(idx, value)| (self.idx_to_coord(idx), value))
    }
}

impl<T> Display for Grid<T>
where
    T: Display,
{
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for row in self.rows() {
            for item in row {
                write!(fmt, "{item}")?;
            }
            writeln!(fmt)?;
        }
        Ok(())
    }
}
