.PHONY : all clean
all : solve 

solve : solve.F95
	gfortran -o solve -Wall -Wno-tabs solve.F95

clean : 
	rm -v solve *.csv
