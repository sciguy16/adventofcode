#!/usr/bin/python3
from parse import parse

f = open("input.sorted", "r")
#f = open("testinput", "r")
#debug = True
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
                if debug: print("Start %d, stop %d. Adding %d"%(
                    start, minute, minute-start))
                start = -1
        sleepTimes[guard] = tim
    return sleepTimes

guardTimes = parseFile(f)


# build up a dict that looks like this:
# { 23: [ array of minutes and a tally of how many times the minute was hit ] }

if debug:
    print("Guard times:")
    print(guardTimes)

guardMinutes = {}
favouriteMinutes = {}
overallBestCount = 0
overallBestMinute = 0
overallBestGuardNum = 0

for guard in guardTimes:
    # tally the minutes
    guardMinutes[guard] = [0]*60

    state = "awake"
    start = -1
    for gt in guardTimes[guard]:
        if gt[1] == "asleep":
            assert(state == "awake")
            assert(start == -1)
            start = int(gt[0].split(":")[1])
            state = "asleep"
        elif gt[1] == "wakes":
            assert(state == "asleep")
            assert(start >= 0)
            stop = int(gt[0].split(":")[1])
            state = "awake"

            for minute in range(start, stop):
                guardMinutes[guard][minute] += 1
            start = -1

    bestMinuteCount = max(guardMinutes[guard])
    bestMinute = guardMinutes[guard].index(bestMinuteCount)
    favouriteMinutes[guard] = [bestMinute, bestMinuteCount]

    if bestMinuteCount > overallBestCount:
        overallBestMinute = bestMinute
        overallBestCount = bestMinuteCount
        overallBestGuardNum = guard

if debug:
    print("guard minutes:")
    print(guardMinutes)
    print("favouriteMinutes:")
    print(favouriteMinutes)
print("bestest guard is %d with minute %d count %d product %d"%(
        overallBestGuardNum, overallBestMinute,
        overallBestCount, overallBestGuardNum * overallBestMinute))

