#!/usr/bin/env ruby

$tests = [
  [14, 2],
  [1969, 966],
  [100756, 50346]
]

def fuel(mass)
  (mass / 3) - 2
end

def recursive_fuel(mass)
  f = fuel(mass)
  puts "Fuel needed for #{mass} is #{f}"
  if f <= 0 then
    return 0
  end
  return f + recursive_fuel(f)
end

def main()
  # Verify the method
  $tests.each do |m, f|
    raise unless recursive_fuel(m) == f
  end
  puts "All tests passed"

  # Do the real work
  s = 0
  File.foreach("input.txt") do |line|
    s += recursive_fuel(line.to_i)
  end
  puts "The answer is: #{s}"

end

main()
