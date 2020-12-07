#!/usr/bin/env ruby

def main()
  visited = Hash.new(0)
  pos = [0, 0]

  directions = File.new("input.txt").readlines[0].chomp
  directions.chars.each do |dir|
    puts "Direction is: #{dir}"
    case dir
    when '^'
      pos[1] += 1;
    when 'v'
      pos[1] -= 1;
    when '>'
      pos[0] += 1;
    when '<'
      pos[0] -= 1;
    else
      raise "A bad has happened"
    end
    puts "Position is: #{pos}"
    visited[pos] += 1;
  end

  puts "The answer is: #{visited.values.length}"
end

main
