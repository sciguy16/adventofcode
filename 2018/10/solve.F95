!#define TEST
!#define DEBUG

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
	integer, parameter :: RegInt_K = selected_int_kind(30)

	integer(kind=RegInt_K), dimension(NUMPOINTS, 2) :: points, speeds
	integer(kind=RegInt_K) :: i
	integer(kind=RegInt_K) :: previousArea, newArea

	open(10, FILE=INFILE, status="old")
	do i = 1, NUMPOINTS
		read(10,*) points(i,:), speeds(i,:)
	end do
	close(10)

#ifdef DEBUG
	do i = 1, NUMPOINTS
		print "(I8, I8, I3, I3)", points(i,:), speeds(i,:)
	end do
#endif
	!call printStars(points)

	previousArea = area(points)
	i = 0
	do while ( .true. ) !i .lt. 10 )
		newArea = area( points + i*speeds )
#ifdef DEBUG
		print*, " [+] Time is now", i
		print*, " [+] New area is:", newArea
#endif
		if ( newArea > previousArea ) then
			call printStars( points + (i - 1)*speeds )
			print*," [+] Starfield migration simulation completed in", i-1, "seconds"
			exit
		end if
		previousArea = newArea
		i = i + 1
	end do

contains

	function area(stars)
		implicit none
		! computes the area of the smallest rectangle containing the
		! stars

		! inputs
		integer(kind=RegInt_K), intent(in), dimension(:,:) :: stars

		! outputs
		integer(kind=RegInt_K) :: area

		! variables
		integer(kind=RegInt_K) :: minX, minY, maxX, maxY
		integer(kind=RegInt_K), dimension(4) :: boundsArray

		boundsArray = bounds(stars)
		minX = boundsArray(1)
		minY = boundsArray(2)
		maxX = boundsArray(3)
		maxY = boundsArray(4)

		area = ( maxX - minX ) * ( maxY - minY )
	end function area

	function bounds(stars) result(boundsRes)
		implicit none

		! inputs
		integer(kind=RegInt_K), intent(in), dimension(:,:) :: stars

		! outputs
		! returns an array ( minX, minY, maxX, maxY )
		integer(kind=RegInt_K),  dimension(4) :: boundsRes

		! variables
		integer(kind=RegInt_K) :: minX, minY, maxX, maxY
		integer(kind=RegInt_K), dimension(2) :: mins, maxs

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

		boundsRes = (/ minX, minY, maxX, maxY /)

	end function bounds


	subroutine printStars(stars)
		implicit none
		
		! inputs
		integer(kind=RegInt_K), intent(in), dimension(NUMPOINTS,2) :: stars
		
		! variables
		integer(kind=RegInt_K) :: minX, minY, maxX, maxY
		integer(kind=RegInt_K) :: i, j
		integer(kind=RegInt_K), dimension(2) :: mins, maxs

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
		integer(kind=RegInt_K), dimension(:,:) :: array
		integer(kind=RegInt_K), dimension(2) :: point

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
