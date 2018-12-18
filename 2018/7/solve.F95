#define TEST
#define DEBUG

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
	logical, dimension(NUMVERTICES) :: existingVertices

	integer, dimension(NUMVERTICES) :: sorted

	integer :: source, dest
	integer :: orderCount
	integer :: i, j

	! functions

	open(1, FILE=INFILE, status="old")

	do i = 1, NUMVERTICES
			do j=1, NUMVERTICES
					graph(i,j) = .false.
			end do
	end do

	do i=1, NUMEDGES
		read(1,*) source, dest
		graph(source, dest) = .true.
	end do


	call printGraph(graph)

	! initialise the list of available vertices. Entries will be true if a
	! vertex has at least one incoming edge (so it is not a valid choice) and
	! false otherwise (false => valid choice)
	orderCount = 1
	existingVertices(:) = .true.
	availableVertices = hasIncomingEdges(graph, existingVertices)
	do while (any( availableVertices(:) .eqv. .false. ) .and. any( existingVertices(:) .eqv. .true. ))
#ifdef DEBUG
		print*, "There are still available vertices:", availableVertices
		print*, "There are still existing vertices:", existingVertices
#endif
		! Iterate over the available vertices and write down the order in which
		! they appear and then delete then from the graph
		do i = 1, NUMVERTICES
			if (availableVertices(i) .eqv. .false. .and. existingVertices(i) .eqv. .true. ) then
				! valid vertex
#ifdef DEBUG
				print*, "Next vertex is:", i
#endif
				orderCount = orderCount + 1
				
				! delete i from graph
				!do j = 1, NUMVERTICES
				!		graph(i, j) = .false.
				!end do
				existingVertices(i) = .false.
			end if
		end do

		call printGraph(graph)
		availableVertices = hasIncomingEdges(graph, existingVertices)
	end do


	contains


	function hasIncomingEdges(graph, existingVertices)
		implicit none

		! Takes in a graph and returns a list specifying whether each vertex has
		! any incoming edges or not

		! inputs
		logical, intent(in), dimension(NUMVERTICES,NUMVERTICES) :: graph
		logical, intent(in), dimension(NUMVERTICES) :: existingVertices

		! outputs
		logical, dimension(NUMVERTICES) :: hasIncomingEdges

		! variables
		integer :: i

		! Determine vertices with no incoming edges
		! That is, take each vertex and look for any .true. in graph(:,vertex)
		do i = 1, NUMVERTICES
			if (any( graph(:, i) .eqv. .true. ) ) then
				! vertex has an incoming edge
#ifdef DEBUG
				print*, "Vertex", i, "has at least one incoming edge"
#endif
				hasIncomingEdges(i) = .true.
			else
#ifdef DEBUG
				print*, "Vertex", i, "does not have any incoming edges"
#endif
				if (existingVertices(i)) then
					hasIncomingEdges(i) = .false.
				else
					hasIncomingEdges(i) = .true.
				end if
			end if
		end do

	end function hasIncomingEdges



	subroutine printGraph(graph)
		implicit none

		logical, intent(in), dimension(NUMVERTICES, NUMVERTICES) :: graph

		integer :: i

		do i = 1, NUMVERTICES
			print*, i, graph(i,:)
		end do
	end subroutine printGraph

end program solve
