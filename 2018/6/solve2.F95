!#define TEST
!#define DEBUG

#ifdef TEST

#define NUMCOORDS 6
#define INFILE "testinput"
#define GRIDSIZE 10
#define MAXDIST 32

#else

#define NUMCOORDS 50
#define INFILE "input"
#define GRIDSIZE 500
#define MAXDIST 10000

#endif


program solve
      implicit none

      ! function return types
      integer :: sumDistances

      ! variables
      integer, dimension(NUMCOORDS,2) :: coords
      !integer, dimension(GRIDSIZE, GRIDSIZE) :: grid
      integer :: area

      integer :: i,j
      integer :: distance

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


      area = 0
      do i = 1,GRIDSIZE
        do j = 1,GRIDSIZE
                ! iterate over each grid square

                ! Initialise the square to zero
                !grid(i, j) = 0

                distance = sumDistances(coords, (/ i, j /) )

                if (distance .lt. MAXDIST) then
                        area = area + 1
                end if

        end do
      end do

      ! get the largest area
      print *, "Area of region is: ", area
end program solve


function sumDistances(coords, point) result(totalDistance)
        implicit none

        ! Given a list of coordinates and a point we find the index of the
        ! closest coordinate to our point

        ! inputs
        integer, intent(in), dimension(NUMCOORDS, 2) :: coords
        integer, intent(in), dimension(2) :: point

        ! output
        integer :: totalDistance

        ! functions
        integer :: manhatten

        ! variables
        integer :: i
        integer :: distance

        totalDistance = 0
        do i = 1,NUMCOORDS
                distance = manhatten(coords(i,:), point)
                totalDistance = totalDistance + distance
        end do
        
        return
end function sumDistances


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
