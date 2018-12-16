!#define NUMCOORDS 6
!#define INFILE "testinput"
!#define GRIDSIZE 10

#define NUMCOORDS 50
#define INFILE "input"
#define GRIDSIZE 500

!#define DEBUG

program solve
      implicit none

      ! function return types
!      integer :: manhatten
      integer :: findClosest

      ! variables
      integer, dimension(NUMCOORDS,2) :: coords
!      integer, dimension(GRIDSIZE, GRIDSIZE) :: grid
      integer, dimension(NUMCOORDS) :: areas

      integer :: i,j
      integer :: closestIndex

      open(1, FILE=INFILE, status="old")

      do i = 1,NUMCOORDS
             read(1, *) coords(i,:)
      end do

      close(1)

#ifdef DEBUG
      call printCoords(coords)
#endif

      !print *,"Manhatten distance between (3,6) and (5,2) is:"
      !print *, manhatten( (/ 3,6 /), (/ 5,2 /) )


      do i = 1, NUMCOORDS
        areas(i) = 0
      end do

      do i = 1,GRIDSIZE
        do j = 1,GRIDSIZE
                ! iterate over each grid square
                ! Calculate the closest fixed point (or a tie)
                ! Tally up the areas as we go
                ! Set areas bordering the edge of the grid to a negative number

                ! Initialise the square to zero
 !               grid(i, j) = 0

                closestIndex = findClosest(coords, (/ i, j /) )
#ifdef DEBUG
                print *, closestIndex, ":", coords(closestIndex,:)
#endif        
                areas(closestIndex) = areas(closestIndex) + 1

                if ( i == 1 .or. i == GRIDSIZE .or. j == 1 .or. j == GRIDSIZE ) then
                        ! at the border
                        areas(closestIndex) = -9999
                end if
        end do
      end do
#ifdef DEBUG
      print*, areas
#endif

      ! get the largest area
      print *, "Maximum finite area is:", maxval(areas)
end program solve


function findClosest(coords, point) result(closestIndex)
        implicit none

        ! Given a list of coordinates and a point we find the index of the
        ! closest coordinate to our point

        ! inputs
        integer, intent(in), dimension(NUMCOORDS, 2) :: coords
        integer, intent(in), dimension(2) :: point

        ! output
        integer :: closestIndex

        ! functions
        integer :: manhatten

        ! variables
        integer :: i
        integer :: distance
        integer :: closestDistance

        closestIndex = 0
        closestDistance = 9999
        do i = 1,NUMCOORDS
                distance = manhatten(coords(i,:), point)
                if ( distance .lt. closestDistance ) then
                        closestDistance = distance
                        closestIndex = i
                endif
        end do
        
        return
end function findClosest


function manhatten(pointA, pointB) result(distance)
        implicit none

        ! Given two points, return the Manhatten distance between them

        ! Inputs
        integer, intent(in), dimension(2) :: pointA, pointB

        ! Output
        integer :: distance

        integer, dimension(2) :: difference

        difference = pointA - pointB

        distance = abs(difference(1)) + abs(difference(2))
        return
end function manhatten


subroutine printCoords(coords)
        implicit none
        integer, intent(in) :: coords(NUMCOORDS,2)

        integer :: i

        do i = 1,NUMCOORDS
                print *, coords(i,:)
        end do
end subroutine printCoords
