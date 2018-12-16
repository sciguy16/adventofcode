#!/usr/bin/env ruby

class Array
		def toPgm(width, height, depth, filename)
				pgm = "P2
				# feep.pgm
				# 24 7
				# 15
				# 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0"
				pgm = "P2\n# #{filename}\n#{width} #{height}\n#{depth}\n"
				self.flatten.each_slice(70) do |slice|
						pgm << slice.join(' ') << "\n"
				end
				File.open(filename, "w") do |file|
						file.write(pgm)
				end
		end
end
