.PHONY : all clean inputs
all : solve #solve2

solve : solve.F95 inputs
	gfortran -o solve -Wall -Wno-tabs solve.F95

#solve2 : solve2.F95 inputs
#	gfortran -o solve2 -Wall -Wno-tabs solve2.F95

inputs : input.csv testinput.csv

input.csv : input
	sed 's/^[^>]*<//;s/>.*</,/;s/>//' input > input.csv

testinput.csv : testinput
	sed 's/^[^>]*<//;s/>.*</,/;s/>//' testinput > testinput.csv

clean : 
	rm -v solve solve2 *.csv
