#!/usr/bin/env python3

from z3 import *
from parse import parse

debug = True
# debug = False
#test = True
test = False

if test:
    steps = ["A","B","C","D","E","F"]
    inputfile = "testinput"
else:
    steps = ["A","B","C","D","E","F","G","H","I","J","K","L","M",
        "N","O","P","Q","R","S","T","U","V","W","X","Y","Z" ]
    inputfile = "input"

s = Solver()
stepVars = {}
for step in steps:
    stepVars[step] = Int(step)
    s.add( stepVars[step] > 0 )
    s.add( stepVars[step] <= len(steps) )

#s.add(Distinct([stepVars['A'], stepVars['B'], stepVars['D']]))
s.add(Distinct(
    [stepVars[sv] for sv in stepVars]
    ))

#if debug: print(stepVars)

# Read the input file and convert the input into z3 constraints
with open(inputfile, "r") as f:
    for line in f.readlines():
#        if debug: print(line.strip())
        prereq, step = parse(
                "Step {} must be finished before step {} can begin.",
                line)

        s.add( stepVars[prereq] < stepVars[step] )

while s.check() == sat:
    out = s.model()

    # Build a dict of the ordering
    print("making order")
    order = {}
    for stepVar in stepVars:
        order[stepVar] = out[stepVars[stepVar]].as_long()
    
    print(order)
    print("sorting...")
    ordered_order = sorted(order, key=lambda x: order[x])
    print( ''.join(ordered_order))

    notAgain = []
    for val in out:
        print(type(val))
        print(type(out[val]))
        notAgain.append( val != out[val] )
    print(notAgain)
    s.add(And(notAgain))
