#!/usr/bin/env python
import math


# res = map(sum, zip(first, second))
def load_vectors(infile):
    # Input lines look like:
    #   R75,D30,R83,U83,L12,D49,R71,U7,L72
    #   U62,R66,U55,R34,D71,R55,D58,R83
    # Read them in and convert them into [x, y] vectors
    # - U = [0, 1]
    # - D = [0, -1]
    # - R = [1, 0]
    # - L = [-1, 0]
    vecs = []
    with open(infile, 'r') as f:
        for line in f.readlines():
            directions = line.rstrip().split(',')
            vecs.append(list(map(dir_to_vec, directions)))
    assert(len(vecs) == 2)
    return vecs


def dir_to_vec(direction):
    unitvecs = {
            'U': [0, 1],
            'D': [0, -1],
            'R': [1, 0],
            'L': [-1, 0],
    }
    unitvec = unitvecs[direction[0]]
    assert(unitvec is not None)
    scale = int(direction[1:])
    return mul_vec(scale, unitvec)


def mul_vec(scalar, vector):
    # Multiplies a vector by a scalar
    return list(map(lambda x: x * scalar, vector))


def add_vecs(v1, v2):
    return list(map(sum, zip(v1, v2)))


def sign(x):
    return int(math.copysign(1, x))


def points_on_path(p1, p2):
    points = []
    # Assume that p1 is the starting point and inc the steps counter
    # from there
    steps = p1[2]
    # print("Points on path FROM", p1, "TO", p2)
    if p1[0] == p2[0]:
        for i in range(p1[1], p2[1], sign(p2[1] - p1[1])):
            points.append([p1[0], i, steps])
            steps += 1
    elif p1[1] == p2[1]:
        for i in range(p1[0], p2[0], sign(p2[0] - p1[0])):
            points.append([i, p1[1], steps])
            steps += 1
    else:
        raise "An unspecified error has occurred"
    # print("The points on this path are:", points)
    return points


def vecs_to_points(vecs):
    points_hit = []
    # pos: [x, y, cumulative_steps]
    pos = [0, 0, 0]
    for vec in vecs:
        oldpos = pos
        v = vec.copy()
        # v.append(abs(v[0] - pos[0]) + abs(v[1] - pos[1]))
        v.append(max(abs(v[0]), abs(v[1])))
        # print("Distance change is", v[2])
        pos = add_vecs(pos, v)
        # pos[2] += abs(v[0] - pos[0]) + abs(v[1] - pos[1])
        points_hit += points_on_path(oldpos, pos)
    return points_hit


def check_in(v, points):
    for p in points:
        if v[:2] == p[:2]:
            return True
    return False


def intersect(points1, points2):
    intersection = []
    for p1 in points1:
        if check_in(p1, points2):
            # they intersect
            matching_point = [x for x in points2 if x[:2] == p1[:2]]
            if len(matching_point) != 0:
                matching_point = matching_point[0]
            # print("point:", p1, "matching:", matching_point)
            intersection.append([p1[0], p1[1], p1[2] + matching_point[2]])
    return intersection


def main(infile):
    line1, line2 = load_vectors(infile)
    # print("Line 1:", line1)
    # print("Line 2:", line2)

    points1 = vecs_to_points(line1)
    points2 = vecs_to_points(line2)

    # print("points1:", points1)
    # print("points2:", points2)

    intersection = intersect(points1, points2)
    distances = list(map(lambda x: x[2], intersection))

    print("Intersection:", intersection)
    print("Distances:", distances)
    distances.sort()
    print("Shortest is:", distances[1])


if __name__ == "__main__":
    main("test0.txt")
    main("test1.txt")
    main("test2.txt")
    main("input.txt")
