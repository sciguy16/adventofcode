!#define TEST
!#define DEBUG

#ifdef TEST
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

	! variables
	logical, dimension(NUMVERTICES,NUMVERTICES) :: graph
	logical, dimension(NUMVERTICES) :: availableVertices
	logical, dimension(NUMVERTICES) :: completedVertices

	integer, dimension(NUMVERTICES) :: sorted
	integer, dimension(NUMVERTICES) :: theOrder

	integer, dimension(1) :: minlocResult

	integer :: source, dest
	integer :: orderCount
	integer :: i

	! functions

	open(1, FILE=INFILE, status="old")

	! initialise the graph
	graph(:,:) = .false.

	! read in the file and convert it to an adjacency matrix
	do i=1, NUMEDGES
		read(1,*) source, dest
		graph(source, dest) = .true.
	end do


	call printGraph(graph)

	! initialise ordercount
	orderCount = 1

	! Start by getting a list of vertices with no incoming edges
	availableVertices(:) = .false.
	completedVertices(:) = .false.
	do i = 1, NUMVERTICES
		if( .not. any( graph(:, i) .eqv. .true. ) ) then
			! there are no incoming edges
			availableVertices(i) = .true.
		end if
	end do
#ifdef DEBUG
	print*, availableVertices
#endif
	! Mark those vertices as complete and write down their sorted positions
	do i = 1, NUMVERTICES
		if (availableVertices(i) .eqv. .true. ) then
			! this vertex should be next in the sort
			sorted(i) = orderCount
			completedVertices(i) = .true.
#ifdef DEBUG
			print*, "Sorted ", i, "at ", orderCount
#endif
			orderCount = orderCount + 1
		end if
	end do

	do while ( .true. )
		! update availableVertices based on previousVertices
		availableVertices(:) = .false.

		do i = 1, NUMVERTICES
			! if node is not completed...
			if ( completedVertices(i) .eqv. .false. ) then
				! ... and if all incoming edges are from completed nodes
				! IF NOT any( incoming AND NOT completed ) should work...
#ifdef DEBUG
				print*, "graph(:,i) is ", graph(:,i)
				print*, "completed  is ", completedVertices(:)
#endif
				if ( .not. any( graph(:, i) .and. .not. completedVertices(:) ) ) then
					! let's make it available
#ifdef DEBUG
					print*, "Making ", char(i + 64), " available"
#endif
					availableVertices(i) = .true.
				end if
			end if
		end do


#ifdef DEBUG
		print*, "Available vertices: ", availableVertices
#endif

		! stop of availableVertices is empty
		if ( .not. any( availableVertices(:) .eqv. .true. ) ) then
#ifdef DEBUG
			print*, sorted
#endif
			! jump to where we print the answer in the correct order
			goto 100
		end if

		! sort availableVertices
		do i = 1, NUMVERTICES
			if ( availableVertices(i) .eqv. .true. ) then
				sorted(i) = orderCount
				completedVertices(i) = .true.

#ifdef DEBUG
				print*, "Sorting vertex ", i, "at position ", orderCount
#endif

				orderCount = orderCount + 1
				! now break out of this loop and recalculate the lists
				exit
			end if
		end do

	end do

100	print*, " [+] Topological sorting complete!"
	! print them out
	do i = 1, NUMVERTICES
		minlocResult = minloc(sorted)
		theOrder(i) = minlocResult(1)
		sorted(minlocResult(1)) = 99999
	end do
	print*, "Sorted order:", theOrder

	print*, "Result: ",  CHAR(theOrder(:) + 64)
#ifdef TEST
	print*, "Correct answer is: CABDFE"
#endif

contains


	subroutine printGraph(graph)
		implicit none

		logical, intent(in), dimension(NUMVERTICES, NUMVERTICES) :: graph

		integer :: i

		do i = 1, NUMVERTICES
			print*, i, graph(i,:)
		end do
	end subroutine printGraph


end program solve
