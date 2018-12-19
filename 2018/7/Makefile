.PHONY : all clean
all : solve solve2

solve : solve.F95 testinput.csv
	gfortran -o solve -Wall -Wno-tabs solve.F95

solve2 : solve2.F95 input.csv
	gfortran -o solve2 -Wall -Wno-tabs solve2.F95

input.csv : parseToCSV
	./parseToCSV input

testinput.csv : parseToCSV
	./parseToCSV test

parseToCSV : parseToCSV.c
	gcc -o parseToCSV -Wall parseToCSV.c

clean : 
	rm -v solve solve2 parseToCSV *.csv
