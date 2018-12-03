#!/bin/sh

# checksum of the list is the number of box IDs that contain a letter appearing
# exactly twice multiplied by the number of box IDs that contain a letter
# appearing exactly three times.

TWICE=0
THRICE=0

while read BOXID ; do
	COUNTS=$(echo $BOXID | fold -w1 | sort | uniq -c)
	if [[ $(echo $COUNTS | grep -c '2' ) -gt 0 ]] ; then
		TWICE=$(($TWICE+1))
	fi
	if [[ $(echo $COUNTS | grep -c '3' ) -gt 0 ]] ; then
		THRICE=$(($THRICE+1))
	fi

done < input.txt

echo "Num twice: ${TWICE}; num thrice: ${THRICE}"
CHECKSUM=$(($TWICE * $THRICE))
echo "Checksum: ${CHECKSUM}"
