#!/usr/bin/env ruby

def main()
  graph = Array.new

  File.foreach("input.txt") do |line|
    start, stop = line.chomp.split(')')
    puts "Start: #{start}, stop: #{stop}"
    graph.push [start, stop]
  end

  you = walk(graph, "YOU")
  san = walk(graph, "SAN")

  # Find intersection between you and san
  intersection = you & san
  # distance from you to san is length(you) + length(san) - 2*intersection
  dist = you.length + san.length - 2 * intersection.length
  puts "The distance is: #{dist}"
end

def walk(graph, start)
  cur = start
  path = Array.new
  until cur == "COM" do
    parent = graph.filter{|e| e[1] == cur}
    if parent[0] == "COM"
      break
    end
    raise "Uh-oh" unless parent.length == 1
    path.append(parent[0][0])
    cur = parent[0][0]
  end

  path
end

main
