fn part_one(depths: &[usize]) -> usize {
    depths.windows(2).filter(|pair| pair[1] > pair[0]).count()
}

fn part_two(depths: &[usize]) -> usize {
    depths
        .windows(3)
        .map(|triple| triple.iter().sum())
        .collect::<Vec<usize>>() // eww, but apparently only slices have windows
        .windows(2)
        .filter(|pair| pair[1] > pair[0])
        .count()
}

fn main() {
    println!("Hello, world!");
    let depths_str = include_str!("../input.txt");
    let depths = depths_str
        .lines()
        .map(|line| line.parse::<usize>().unwrap())
        .collect::<Vec<_>>();

    let ans = part_one(&depths);
    println!("Part one: {ans}");

    let ans = part_two(&depths);
    println!("Part two: {ans}");
}

#[cfg(test)]
mod test {
    use super::*;

    fn test_depths() -> Vec<usize> {
        let depths_str = r#"199
200
208
210
200
207
240
269
260
263"#;
        depths_str
            .lines()
            .map(|line| line.parse::<usize>().unwrap())
            .collect()
    }

    #[test]
    fn test_part_1() {
        let depths = test_depths();
        let ans = part_one(&depths);
        assert_eq!(ans, 7);
    }

    #[test]
    fn test_part_2() {
        let depths = test_depths();
        let ans = part_two(&depths);
        assert_eq!(ans, 5);
    }
}
