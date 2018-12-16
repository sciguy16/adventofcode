#!/bin/bash

INPUT="input"
#INPUT="testinput"
#INPUTTEXT=$(cat $INPUT)

RegexToMatchPairsOfLettersOfDifferingCase=$(
while read LETTER ; do
	echo "${LETTER}${LETTER^^}|${LETTER^^}${LETTER}"
done < <( echo {a..z} | tr ' ' '\n' ) \
	| paste -sd"|" \
	| sed 's/|/\\|/g'
	)

function reduce() {
	printf $1 | sed ":loop s/${RegexToMatchPairsOfLettersOfDifferingCase}//; t loop"
}

#remainder=$(reduce $INPUTTEXT)

# iterate over possibly removable letters:
while read LETTER ; do
	echo $LETTER
	TextWithoutLetter=$( tr -d "${LETTER}${LETTER^^}" < $INPUT )
	#echo $TextWithoutLetter
	Reacted=$(reduce $TextWithoutLetter)
	ReactedLength=$(printf $Reacted | wc -c)
	echo "Length is:" $ReactedLength
done < <( tr '[:upper:]' '[:lower:]' < $INPUT | fold -w1 | sort -u )
