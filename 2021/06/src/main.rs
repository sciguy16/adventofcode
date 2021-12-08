use eyre::Error;

struct Lanternfish {
    days: usize,
}

fn parse_lanternfish(inp: &str) -> Result<Vec<Lanternfish>, Error> {
    Ok(inp
        .split(',')
        .map(|n| n.parse::<usize>().map(|days| Lanternfish { days }))
        .collect::<Result<Vec<_>, _>>()?)
}

#[derive(Debug, Default, Eq, PartialEq)]
struct FishBuckets([usize; 9]);

impl FishBuckets {
    pub fn from_fish(fish: &[Lanternfish]) -> Self {
        let mut fish_buckets = Self::default();
        for f in fish {
            // hopefully all of the fish are in valid states
            fish_buckets.increment(f.days);
        }
        fish_buckets
    }

    pub fn increment(&mut self, position: usize) {
        self.0[position] += 1;
    }

    pub fn step(&mut self) {
        // rotate left, but then move everything from [8] forward to [6]
        // Then everything that just moved from [8] to [6] spawns a new
        // fish at [8]. This is equivalent to adding the number from [8]
        // to [6] and keeping the number at [8].
        self.0.rotate_left(1);
        self.0[6] += self.0[8];
    }
}

fn part_one(fish: &[Lanternfish], days: usize) -> usize {
    // * for each fish, work out how many days until it spawns a new one
    // * subtract that number from the total days
    // * apply the "how many lanternfish created after some time" formula
    //     to this number of days
    // * add to running total

    // forget all that, instead we make a bucket for each number of days:

    // each bucket holds a count of the number of fish at each stage of
    // the fishy cycle
    let mut fish_buckets = FishBuckets::from_fish(fish);

    for day in 1..=days {
        fish_buckets.step();
        #[cfg(debug_assertions)]
        println!("Day {:2}: {:?}", day, fish_buckets);
    }

    fish_buckets.0.iter().sum()
}

fn main() {
    println!("Hello, world!");
    let input = include_str!("../input.txt");

    let fish = parse_lanternfish(input).unwrap();

    let ans = part_one(&fish, 80);
    println!("part one: {}", ans);
    let ans = part_one(&fish, 256);
    println!("part two: {}", ans);
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = "3,4,3,1,2";

    #[test]
    fn test_step_function() {
        let fish = &[Lanternfish { days: 3 }];
        let mut fish_buckets = FishBuckets::from_fish(fish);
        assert_eq!(fish_buckets.0[3], 1);
        fish_buckets.step(); // 2
        fish_buckets.step(); // 1
        fish_buckets.step(); // 0
        assert_eq!(
            fish_buckets,
            FishBuckets::from_fish(&[Lanternfish { days: 0 }])
        );
        fish_buckets.step(); // 8 and 6
        assert_eq!(
            fish_buckets,
            FishBuckets::from_fish(&[
                Lanternfish { days: 6 },
                Lanternfish { days: 8 }
            ])
        );
    }

    #[test]
    fn test_part_one() {
        let lanternfish = parse_lanternfish(TEST_DATA).unwrap();
        let ans = part_one(&lanternfish, 18);
        assert_eq!(ans, 26);
        let ans = part_one(&lanternfish, 80);
        assert_eq!(ans, 5934);
    }

    #[test]
    fn test_part_two() {
        let lanternfish = parse_lanternfish(TEST_DATA).unwrap();
        let ans = part_one(&lanternfish, 256);
        assert_eq!(ans, 26984457539);
    }
}
