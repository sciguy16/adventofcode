#define TEST
#define DEBUG

#ifdef TEST
#define INFILE "testinput.csv"
#define NUMPOINTS 31
#else
#define INFILE "input.csv"
#define NUMPOINTS 295
#endif

program solve
	implicit none

	! variables
	integer, dimension(NUMPOINTS, 2) :: points, speeds
	integer :: i

	open(10, FILE=INFILE, status="old")
	do i = 1, NUMPOINTS
		read(10,*) points(i,:), speeds(i,:)
	end do
	close(10)

#ifdef DEBUG
	do i = 1, NUMPOINTS
		print "(I3, I3, I3, I3)", points(i,:), speeds(i,:)
	end do
#endif
	call printStars(points)

	do i = 1, 3
		call printStars( points + i*speeds )
	end do

contains

	function bounds(stars) result(boundsRes)
		implicit none

		! inputs
		integer, intent(in), dimension(:,:) :: stars

		! outputs
		integer,  dimension(4) :: boundsRes


		boundsRes = (/ 1, 2, 3, 4 /)
	end function bounds


	subroutine printStars(stars)
		implicit none
		
		! inputs
		integer, intent(in), dimension(NUMPOINTS,2) :: stars
		
		! variables
		integer :: minX, minY, maxX, maxY
		integer :: i, j
		integer, dimension(2) :: mins, maxs

		! find the boundary of the area
		mins = minval(stars, 1)
		maxs = maxval(stars, 1)
		minX = mins(1)
		maxX = maxs(1)

		minY = mins(2)
		maxY = maxs(2)

#ifdef DEBUG
		print*, "mins and maxes: ", minX, maxX, minY, maxY
#endif
		! iterate over the area, asking each point whether it has a star
		! write a # if there's a star, a space otherwise
		do j = minY, maxY
			do i = minX, maxX
				if( anyPoint( stars, (/ i, j /) ) ) then
					write (*,"(A1)",ADVANCE="no") "#"
				else
					write (*,"(A1)",ADVANCE="no") " "
				end if
			end do
			write (*,*) new_line('A')
		end do
		!print*,"stars", stars
	end subroutine printStars

	function anyPoint(array, point)
		! inputs
		integer, dimension(:,:) :: array
		integer, dimension(2) :: point

		! output
		logical :: anyPoint

		! variables
		integer i

		anyPoint = .false.
		do i = 1,size(array, 1)
			if ( all(array(i,:) .eq. point ) ) then
				!print*, " [+] got one:"
				!print*, array(i,:)
				!print*, point
				anyPoint = .true.
				return
			end if
		end do
	end function anyPoint
end program solve
