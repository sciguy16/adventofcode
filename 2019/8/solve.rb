#!/usr/bin/env ruby

$infile = "input.txt"

def load(input, width, height)
  nlayers = input.length / (width * height)
  puts "Loading a #{3}x#{2} #{nlayers}-layer image"

  # Initialise the array
  layers = Array.new(nlayers){ Array.new(width) { Array.new(height, 0)}}
  input_digits = input.chars.map(&:to_i)
  (0...nlayers).each do |l|
    (0...width).each do |x|
      (0...height).each do |y|
        layers[l][x][y] = input_digits.delete_at 0
        #puts "x: #{x}; y: #{y}; l: #{l}, im: #{layers[l][x][y]}"
      end
    end
  end

  layers
end

def test()
  input = "123456789012"
  width = 3
  height = 2
  im = load(input, width, height)
  p im  
end

def count_number(layer, number)
  layer.flatten.filter{|x| x == number}.length
end

def main()
  test

  input = File.open($infile).read.chomp
  width = 25
  height = 6
  im = load(input, width, height)
  least_zeroes = 9999999
  layer_with_most = nil
  im.each do |layer|
    zeroes = count_number(layer, 0)
    #puts "Num zeroes is #{zeroes}"
    if zeroes < least_zeroes then
      least_zeroes = zeroes
      layer_with_most = layer
    end
  end
  #puts "The layer with most is: #{layer_with_most}"
  layer = layer_with_most
  puts "one: #{count_number(layer, 1)}; two: #{count_number(layer, 2)}"
  puts "prod: #{count_number(layer, 1) * count_number(layer, 2)}"
end

main
