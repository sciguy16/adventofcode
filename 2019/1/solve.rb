#!/usr/bin/env ruby

$tests = [
  [12, 2],
  [14, 2],
  [1969, 654],
  [100756, 33583]
]

def fuel(mass)
  (mass / 3) - 2
end

def main()
  # Verify the fuel calculator
  $tests.each do|m, f|
    raise unless fuel(m) == f
  end

  # Now do the real work
  s = 0
  File.foreach("input.txt") do |line|
    s += fuel(line.to_i)
  end

  puts "The answer is: #{s}"
end

main()
