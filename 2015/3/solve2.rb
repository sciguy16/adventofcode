#!/usr/bin/env ruby

def main()
  visited = Hash.new(0)
  pos = [0, 0]
  robopos = [0, 0]
  version = "santa"

  # Deliver two presents to the starting house
  visited["#{pos}"] += 2

  directions = File.new("input.txt").readlines[0].chomp
  #directions = File.new("test.txt").readlines[0].chomp
  directions.chars.each do |dir|
    #puts "Direction is: #{dir}, version is {{#{version}}}" +
      #"Pos is #{pos}, robopos is #{robopos}"
    case dir
    when '^'
      if version == "santa" then
        pos[1] += 1
      else
        robopos[1] += 1
      end
    when 'v'
      if version == "santa" then
        pos[1] -= 1
      else
        robopos[1] -= 1
      end
    when '>'
      if version == "santa" then
        pos[0] += 1
      else
        robopos[0] += 1
      end
    when '<'
      if version == "santa" then
        pos[0] -= 1
      else
        robopos[0] -= 1
      end
    else
      raise "A bad has happened"
    end
    
    if version == "santa"
      visited["#{pos}"] += 1
      version = "robo"
    else
      visited["#{robopos}"] += 1
      version = "santa"
    end
    
    #p visited
  end

  puts "The answer is: #{visited.values.length}"
end

main
