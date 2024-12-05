# advent-of-code-template

## Usage
```
cargo install cargo-generate
cargo generate https://github.com/sciguy16/advent-of-code-template --name dayxx
# or if cargo-generate.toml has been configured
cargo generate aoc --name dayxx
```

## Favourites
Put this into `$CARGO_HOME/cargo-generate.toml`:
```toml
[favorites.aoc]
git = "https://github.com/sciguy16/advent-of-code-template"
```