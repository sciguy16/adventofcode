use md5::{Digest, Md5};

fn main() {
    println!("Hello, world!");

    let key = "yzbqklnj";

    //let ans = solve_a(key);
    //println!("Answer is: {}", ans);

    let ans = solve_b(key);
    println!("Answer to 2 is: {ans}");
}

#[allow(unused)]
fn solve_a(input: &str) -> i32 {
    let mut secret: i32 = 0;
    loop {
        let mut hasher = Md5::new();
        hasher.input(format!("{input}{secret}"));
        let res = hasher.result();
        if res[0] == 0 && res[1] == 0 && res[2] < 0x10 {
            break;
        }
        secret += 1;
    }
    secret
}

fn solve_b(input: &str) -> i32 {
    let mut secret: i32 = 0;
    loop {
        let mut hasher = Md5::new();
        hasher.input(format!("{input}{secret}"));
        let res = hasher.result();
        if res[0] == 0 && res[1] == 0 && res[2] == 0 {
            break;
        }
        secret += 1;
    }
    secret
}

#[cfg(test)]
mod test {
    #[test]
    fn test_input() {
        let ans = super::solve_a("abcdef");
        assert_eq!(ans, 609043);
    }
}
