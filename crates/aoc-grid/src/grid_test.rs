use super::*;

#[test]
fn make_grid() {
    let data = [1_u8, 2, 3, 4];
    let grid = Grid::new(data, 2);
    assert_eq!(grid.height(), 2);
    assert_eq!(grid.width(), 2);
}

#[test]
#[should_panic(expected = "assertion `left == right` failed: Data length \
	is not a multiple of width\n  left: 1\n right: 0")]
fn invalid_width() {
    let data = [1_u8, 2, 3, 4];
    let _ = Grid::new(data, 3);
}

#[test]
fn grid_get() {
    #[rustfmt::skip]
    let grid = Grid::<u16>::new([
    	1, 2, 
    	3, 4,
    ], 2);
    assert_eq!(*grid.get((0, 0)).unwrap(), 3);
    assert_eq!(*grid.get((1, 0)).unwrap(), 4);
    assert_eq!(*grid.get((0, 1)).unwrap(), 1);
    assert_eq!(*grid.get((1, 1)).unwrap(), 2);
}

#[test]
fn grid_rows() {
    #[rustfmt::skip]
    let grid = Grid::<u16>::new([
    	1, 2, 
    	3, 4,
    ], 2);

    let mut rows = grid.rows();
    assert_eq!(rows.next().unwrap(), [1, 2]);
    assert_eq!(rows.next().unwrap(), [3, 4]);
    assert!(rows.next().is_none());
}

#[test]
fn grid_display() {
    #[rustfmt::skip]
    let grid = Grid::<u16>::new([
    	1, 2, 
    	3, 4,
    ], 2);
    assert_eq!(grid.to_string(), "12\n34\n");
}
