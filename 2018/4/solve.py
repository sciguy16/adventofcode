#!/usr/bin/python
from parse import parse

f = open("input.sorted", "r")
debug = True
debug = False

def parseFile(f):
    """Returns a hashmap of guards and shifts"""
    guardTimes = {}
    currentGuard = -1
    for line in f.readlines():
        dat, tim, action = parse(
                "[{} {}] {}", line)
        if debug: print(dat, tim, action)
        if "Guard" in action:
            # line specifies a new guard
            currentGuard = parse(
                    "Guard #{:d} begins shift", action)[0]
            if currentGuard not in guardTimes:
                guardTimes[currentGuard] = []
        elif "asleep" in action:
            assert(currentGuard != -1)
            guardTimes[currentGuard].append(
                    [tim, "asleep"])
        elif "wakes" in action:
            assert(currentGuard != -1)
            guardTimes[currentGuard].append(
                    [tim, "wakes"])
    return guardTimes

def mostAsleep(guards):
    """find the guard who spends the most minutes asleep.
    Guards start and end awake"""
    # all sleep times should be between midnight and 0100, so it is 
    # sufficient to drop the hour part and work with just the mins

    # use parse to pull out the minute and hour sections from tim and
    # then assert() that the hour is zero

    sleepTimes = {}
    for guard in guards:
        start = -1
        tim = 0
        for actions in guards[guard]:
            if debug: print(actions)
            hour, minute = parse("{:d}:{:d}", actions[0])
            if actions[1] == "asleep":
                assert(hour == 0)
                assert(start == -1)
                start = minute
            elif actions[1] == "wakes":
                assert(hour == 0)
                assert(start != -1)
                tim += minute - start
                start = -1
        sleepTimes[guard] = tim
    return sleepTimes

guardTimes = parseFile(f)

sleeeeep = mostAsleep(guardTimes)
if debug: print(sleeeeep)

bestGuard = max(sleeeeep, key=sleeeeep.get)

# now find the most sleepy minute for this guard
if debug: print(guardTimes[bestGuard])

# guard starts awake

minutes = [0]*60
state = None
start = -1
for gt in guardTimes[bestGuard]:
    if debug: print(gt)
    if gt[1] == 'asleep':
        assert(state != 'asleep')
        assert(start == -1)
        state = 'asleep'
        start = int(gt[0].split(':')[1])
        if debug: print("Entering sleep mode. New state {}, start {}".format(state,start))
    elif gt[1] == 'wakes':
        assert(state == 'asleep')
        assert(start != -1)
        state = 'wakes'
        stop = int(gt[0].split(':')[1])
        for tim in range(start,stop+1):
            minutes[tim] += 1
        start = -1

if debug: print(minutes)
maxx = max(minutes)
maxMin = minutes[maxx]
print("guard {} likes minute {} with product {}".format(maxx, maxMin, maxx*maxMin))
