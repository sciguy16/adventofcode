#!/usr/bin/env ruby

$:.push '.'
require 'arraytopgm'

GRID_SIZE=500

def taxicab(a, b)
	return (a[0] - b[0]).abs + 
		(a[1] - b[1]).abs
end

if __FILE__ == $0
	coordStrings = File.readlines("input")

	grid = Array.new(GRID_SIZE,
		 Array.new(GRID_SIZE, -1))

	coords = coordStrings.map{|coord| coord.split.map(&:to_i)}

	grid.each_with_index do |row, rownum|
		row.each_with_index do |ele, colnum|
			#puts "(#{rownum}, #{colnum}): #{ele}"
			# for each element work out the closest coordinate
			coordDistances = Array.new(coords.size)
			coords.each_with_index do |coord, coordnum|
				coordDistances[coordnum] = 
					taxicab(coord, [rownum, colnum])
			end
			mins = coordDistances.
					each_with_index.
					select {|e, i| e==coordDistances.min}.
					map(&:last)
			if mins.size == 1
					# we have a unique closest point
					grid[rownum][colnum] = mins[0]
			elsif mins.size > 1
					# more than once closest so we disregard the point
					grid[rownum][colnum] = -1
			else
					raise "am sad now :("
			end
		end
	end
	p grid

	grid.toPgm(GRID_SIZE, GRID_SIZE, coords.size, "grid.pgm")
	coords.each_with_index do |coordpair, index|
		# add each coordinate to the 
	end
end
