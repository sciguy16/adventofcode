#!/usr/bin/env ruby

def main()
  graph = Array.new

  File.foreach("input.txt") do |line|
    start, stop = line.chomp.split(')')
    puts "Start: #{start}, stop: #{stop}"
    graph.push [start, stop]
  end

  # Start at COM and count the distances
  prev_depth = ["COM"]
  depth = 0
  total_dist = 0
  # find all the nodes at each depth
  while true do
    # edges is a list of edges that start at a node in the previous level
    edges = graph.filter{|e| prev_depth.include? e[0]}
    #p edges
    if edges.empty?
      break
    end
    new_depth = Array.new
    edges.each do |edge|
      p edge
      new_depth.push edge[1]
    end
    puts "New depth is: #{new_depth}"
    depth += 1
    total_dist += depth * new_depth.length
    prev_depth = new_depth
  end
  puts "Total depth is: #{total_dist}"
end

main
