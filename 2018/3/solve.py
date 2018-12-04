#!/usr/bin/env python
from parse import parse

FABRIC_SIZE = 1001

fabric = [0] * FABRIC_SIZE * FABRIC_SIZE

f = open("input.txt", "r")
for line in f.readlines():
    elf, lpos, tpos, width, height = parse('#{:d} @ {:d},{:d}: {:d}x{:d}', line)
    print("elf {}, lpos {}".format(elf, lpos))

    assert(lpos + width < FABRIC_SIZE)
    assert(tpos + height < FABRIC_SIZE)

    for row in range(lpos, lpos+width):
        for col in range(tpos, tpos+height):
            fabric[row*FABRIC_SIZE + col] += 1

#print(fabric)
twoOrMoreCount = 0
for square in fabric:
    if square >= 2:
        twoOrMoreCount += 1

print("Number is: {}".format(twoOrMoreCount))
