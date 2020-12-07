#!/bin/bash

FILE="input.txt"
readarray COUNTS < <(fold -w1 < input.txt | sort | uniq -c | awk '{ print $1 }')

echo $(( ${COUNTS[0]} - ${COUNTS[1]} ))
