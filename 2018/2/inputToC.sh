#!/bin/sh

(
	echo "char * boxIDs[] = {"
	sed 's/^/"/;s/$/",/' input.txt
	echo "};"
) > input.c
