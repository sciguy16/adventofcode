.PHONY : all clean inputs
all : solve solve2

solve : solve.F95 inputs
	gfortran -o solve -Wall -Wno-tabs solve.F95

solve2 : solve2.F95 inputs
	gfortran -o solve2 -Wall -Wno-tabs solve2.F95

inputs : input.vertical testinput.vertical

input.vertical : input
	tr ' ' '\n' < input > input.vertical

testinput.vertical : testinput
	tr ' ' '\n' < testinput > testinput.vertical


clean : 
	rm -v solve solve2 *.vertical
