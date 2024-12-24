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
fn grid_get_set() {
    #[rustfmt::skip]
    let mut grid = Grid::<u16>::new([
    	1, 2,
    	3, 4,
    ], 2);
    assert_eq!(*grid.get((0, 0)).unwrap(), 3);
    assert_eq!(*grid.get((1, 0)).unwrap(), 4);
    assert_eq!(*grid.get((0, 1)).unwrap(), 1);
    assert_eq!(*grid.get((1, 1)).unwrap(), 2);
    grid.set((0, 0), 200);
    assert_eq!(*grid.get((0, 0)).unwrap(), 200);
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

#[test]
fn grid_get_neigh() {
    #[rustfmt::skip]
    let grid = Grid::<u16>::new([
        1, 2, 
        3, 4,
    ], 2);

    assert_eq!(
        grid.get_neighbour((0, 0), Direction::Right).unwrap(),
        ((1, 0).into(), &4)
    );
    assert!(dbg!(grid.get_neighbour((0, 0), Direction::Left)).is_none());
}

#[test]
fn grid_get_find() {
    #[rustfmt::skip]
    let grid = Grid::<u16>::new([
        1, 2,
        3, 4,
    ], 2);

    assert_eq!(grid.find(|cell| *cell == 4).unwrap(), Coord::from((1, 0)));
    assert!(grid.find(|cell| *cell == 10).is_none());
}

#[test]
fn grid_iter_cardinals() {
    #[rustfmt::skip]
    let grid = Grid::<u16>::new([
        1, 2,
        3, 4,
    ], 2);

    let neigh = grid.iter_cardinal_neighbours((0, 0)).collect::<Vec<_>>();
    assert_eq!(neigh, [((0, 1).into(), &1), ((1, 0).into(), &4)]);
}
