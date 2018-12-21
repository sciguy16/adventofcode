.PHONY : all clean inputs
all : solve 

solve : solve.F95 inputs
	gfortran -o solve -Wall -Wno-tabs solve.F95

inputs : input.csv testinput.csv

input.csv : input
	sed 's/^[^>]*<//;s/>.*</,/;s/>//' input > input.csv

testinput.csv : testinput
	sed 's/^[^>]*<//;s/>.*</,/;s/>//' testinput > testinput.csv

clean : 
	rm -v solve *.csv
