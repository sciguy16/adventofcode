.PHONY : clean

solve2: solve2.c input.c
	gcc -Wall -o solve2 solve2.c

input.c: inputToC.sh input.txt
	./inputToC.sh

clean:
	rm solve2 input.c
