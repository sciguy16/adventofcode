fn main() {
    println!("Hello, world!");

    let start_time = 1000299;
    let buses_str = concat!(
        "41,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x",
        ",x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,971,x,x,x,x,x,x,x,x,",
        "x,x,x,x,x,x,x,x,17,13,x,x,x,x,23,x,x,x,x,x,29,x,487,x,",
        "x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,19"
    );

    let buses: Vec<usize> = buses_str
        .split(',')
        .filter_map(|s| s.parse().ok())
        .collect();

    let res = part_one(start_time, &buses);
    println!("Part one: {res}");

    let buses: Vec<Option<usize>> =
        buses_str.split(',').map(|s| s.parse().ok()).collect();

    let res = part_two(100000000000000, &buses);
    println!("Part two: {res}");
}

fn part_one(start_time: usize, buses: &[usize]) -> usize {
    for time in start_time..usize::MAX {
        // Check whether time mod each bus number is zero - if any are
        // zero then that is the first valid bus
        if let Some(id) = buses.iter().find(|b| time % **b == 0) {
            // got a valid bus ID
            println!("Found a valid bus ID `{id}` at time `{time}`!");
            return id * (time - start_time);
        }
    }
    panic!("Unable to find a bus :(");
}

fn part_two(start_time: usize, buses: &[Option<usize>]) -> usize {
    for time in start_time..usize::MAX {
        if !buses
            .iter()
            .enumerate()
            .filter(|x| x.1.is_some())
            .any(|(idx, bus)| (time + idx) % bus.unwrap() != 0)
        {
            // There are no buses which do not match the pattern, so we
            // win!
            return time;
        }
    }
    panic!("Unable to find a bus");
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part_one() {
        let start_time = 939;
        let buses: Vec<usize> = "7,13,x,x,59,x,31,19"
            .split(',')
            .filter_map(|s| s.parse().ok())
            .collect();

        let res = part_one(start_time, &buses);
        assert_eq!(res, 295);
    }

    #[test]
    fn test_part_two() {
        let buses: Vec<Option<usize>> = "7,13,x,x,59,x,31,19"
            .split(',')
            .map(|s| s.parse().ok())
            .collect();
        println!("buses: {buses:?}");

        let res = part_two(0, &buses);
        assert_eq!(res, 1068781);
    }
}
