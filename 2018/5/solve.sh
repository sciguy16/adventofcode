#!/bin/bash

RegexToMatchPairsOfLettersOfDifferingCase=$(
while read LETTER ; do
	echo "${LETTER}${LETTER^^}|${LETTER^^}${LETTER}"
done < <( echo {a..z} | tr ' ' '\n' ) \
	| paste -sd"|" \
	| sed 's/|/\\|/g'
	)

sed ":loop s/${RegexToMatchPairsOfLettersOfDifferingCase}//; t loop" input | wc -c
