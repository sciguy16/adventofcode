#!/bin/sh

(
	echo "const int numbers[] = {"
	sed 's/$/,/' input.txt
	echo "};"
) > input.c
