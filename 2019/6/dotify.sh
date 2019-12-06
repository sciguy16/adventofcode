#!/bin/bash

FILE="input.txt"
DOTFILE="orbit.dot"

echo "digraph D {" > $DOTFILE
sed 's/)/ -> /' $FILE | awk '{ print "\"" $1 "\" -> \"" $3 "\"" }' >> $DOTFILE
echo "}" >> $DOTFILE

dot -Tpng -O $DOTFILE
