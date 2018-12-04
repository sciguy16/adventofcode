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

def loopy_loopy(fabric, lpos, tpos, width, height):
    for row in range(lpos, lpos+width):
        for col in range(tpos, tpos+height):
            if fabric[row*FABRIC_SIZE + col] >= 2:
                return "not this one"
    return "this one"

f = open("input.txt", "r")
for line in f.readlines():
    elf, lpos, tpos, width, height = parse('#{:d} @ {:d},{:d}: {:d}x{:d}', line)
    print("elf {}, lpos {}".format(elf, lpos))

    assert(lpos + width < FABRIC_SIZE)
    assert(tpos + height < FABRIC_SIZE)

    if loopy_loopy(fabric, lpos, tpos, width, height) == "this one":
        print("correct elf number is {}".format(elf))
        break

