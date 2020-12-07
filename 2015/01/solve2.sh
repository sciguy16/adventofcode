#!/bin/bash

FILE="input.txt"

floor=0
position=0
while read INSTRUCTION ; do
	case $INSTRUCTION in
		'(' )
	   		floor=$(( $floor + 1 ))
			;;
		')' )
			floor=$(( $floor - 1 ))
			;;
		*)
			echo "An error has occurred"
			exit
			;;
	esac
	position=$(( $position + 1 ))
	if [ $floor -lt 0 ] ; then
		echo "FLOOR IS NEGATIVE!!!!!!!!!!"
		echo "floor is $floor, position is $position"
		exit
	fi
done < <(fold -w1 $FILE)

echo "floor is $floor"
