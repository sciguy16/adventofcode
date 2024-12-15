use crate::coord::Coord;
use std::fmt::Display;

#[cfg(test)]
#[path = "grid_test.rs"]
mod grid_test;

pub struct Grid<T> {
    inner: Vec<T>,
    width: i64,
    height: i64,
}

impl<T> Grid<T> {
    #[must_use]
    pub fn new(data: impl Into<Vec<T>>, width: i64) -> Self {
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
        let offset = at.x + self.height * (self.height - 1 - at.y);
        let offset: usize =
            offset.try_into().expect("Offest out of range for usize");
        self.inner.get(offset)
    }

    pub fn rows(&self) -> impl Iterator<Item = &[T]> + '_ {
        let width = self.width.try_into().unwrap();
        self.inner.chunks(width)
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
