.PHONY : run

run2 : solve2
	./solve2

run : solve
	./solve

solve : solve.c perms.txt
	gcc -o solve solve.c

solve2 : solve2.c perms2.txt
	gcc -o solve2 solve2.c

perms.txt : perms
	./perms > perms.txt

perms2.txt : perms2
	./perms2 > perms2.txt

perms : perms.c
	gcc -o perms perms.c

perms2 : perms.c
	gcc -o perms2 -D FEEDBACK perms.c
