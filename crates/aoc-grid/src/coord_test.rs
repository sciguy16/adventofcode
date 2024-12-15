use super::*;

#[test]
fn coord_add_vector() {
    let coord = Coord::from((14, 5));
    let vector = Vector::from((13, -8));
    assert_eq!(coord + vector, Coord::from((27, -3)));
}

#[test]
fn vector_add_vector() {
    let vector1 = Vector::from((14, 5));
    let vector = Vector::from((13, -8));
    assert_eq!(vector1 + vector, Vector::from((27, -3)));
}
