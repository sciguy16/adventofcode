#define test
#define debug

#ifdef test
#define INFILE "testinput.csv"
#define NUMEDGES 7
#define NUMVERTICES 6
#else
#define INFILE "input.csv"
#define NUMEDGES 101
#define NUMVERTICES 26
#endif

program solve
	implicit none

	logical, dimension(NUMVERTICES,NUMVERTICES) :: graph

	integer :: source, dest

	integer :: i

	open(1, FILE=INFILE, status="old")

	do i=1, NUMEDGES
		read(1,*) source, dest
	end do
	graph(1,1) = .true.

	print*, source, dest

end program solve
