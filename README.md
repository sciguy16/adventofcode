# adventofcode

Solutions to https://adventofcode.com/

To make a new day:
```bash
cargo generate --init aoc
```

Benchmark with (e.g.):
```bash
hyperfine --warmup 2 --shell=none --setup "cargo b --release" \
    "../../target/release/y22day01"
```
