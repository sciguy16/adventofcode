.PHONY : run

run : solve
	./solve

solve : solve.c perms.txt
	gcc -o solve solve.c

perms.txt : perms
	./perms > perms.txt

perms : perms.c
	gcc -o perms perms.c
