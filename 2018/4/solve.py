#!/usr/bin/python
from parse import parse

f = open("input.sorted", "r")

def parseFile(f):
    """Returns a hashmap of guards and shifts"""
    guardTimes = {}
    currentGuard = -1
    for line in f.readlines():
        dat, tim, action = parse(
                "[{} {}] {}", line)
        print(dat, tim, action)
        if "Guard" in action:
            # line specifies a new guard
            currentGuard = parse(
                    "Guard #{:d} begins shift", action)
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
            print(actions)
            if actions[1] == "asleep":
                start = actions[0]
            elif actions[1] == "wakes":
                assert(start != -1)
                tim += actions[0] - start
                start = -1
        sleepTimes[guard] = tim
    return sleepTimes

guardTimes = parseFile(f)
print(guardTimes)

print(mostAsleep(guardTimes))
