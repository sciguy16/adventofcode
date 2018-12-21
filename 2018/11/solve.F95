!#define DEBUG
!#define TEST

#ifdef TEST
#define PUZZLEINPUT 42
#else
#define PUZZLEINPUT 9110
#endif

!#ifdef DEBUG
!#define GRIDSIZE 5
!#else
#define GRIDSIZE 300
!#endif

program solve
	implicit none
	
	! variables
	integer, parameter :: RegInt_K = selected_int_kind(30)
	integer(kind=RegInt_K), dimension(GRIDSIZE,GRIDSIZE) :: cells
	integer(kind=RegInt_K), dimension(GRIDSIZE,GRIDSIZE) :: summedArea

	integer(kind=RegInt_K), parameter :: three = 3
	integer(kind=RegInt_k), parameter :: puzzlin = PUZZLEINPUT

	print*," [+] Verifying cell generator..."

	call verifyGridGenerator()

	! generate fuel cell grid
	print*," [+] Generating cell grid for puzzle...", PUZZLEINPUT
	cells = createFuelCellGrid(puzzlin)

	! want to find 3x3 subgrid with largest sum

	! start by generating a summed area table
	summedArea = generateSummedArea(cells)

#ifdef TEST
	print*, calcGridSum(summedArea, 21, 61, 3, 3)
#endif
	print*, findLargestGridSum(summedArea, three, three)

contains
	function findLargestGridSum(summedArea, width, height) result(pos)
		implicit none
		integer, parameter :: RegInt_K = selected_int_kind(30)

		! inputs
		integer(kind=RegInt_K), intent(in), dimension(GRIDSIZE,GRIDSIZE) :: summedArea
		integer(kind=RegInt_K), intent(in) :: width, height

		! outputs
		integer(kind=RegInt_K), dimension(2) :: pos

		! variables
		integer(kind=RegInt_K) :: x, y
		integer(kind=RegInt_K) :: curSum
		integer(kind=RegInt_K) :: bestSum, bestX, bestY

		bestSum = 0
		! iterate over the grid looking for a nice big sum
		do x = 1, GRIDSIZE - width
			do y = 1, GRIDSIZE - height
				curSum = calcGridSum(summedArea, x, y, width, height)
				if ( curSum .gt. bestSum ) then
					bestSum = curSum
					bestX = x
					bestY = y
				end if
			end do
		end do

		print*, " [+] Found a good one!", bestX, bestY, ":", bestSum

		pos = (/ bestX, bestY /)
	end function findLargestGridSum


	function calcGridSum(summedArea, x, y, width, height) result(gridSum)
		implicit none
		integer, parameter :: RegInt_K = selected_int_kind(30)

		! inputs
		integer(kind=RegInt_K), intent(in), dimension(GRIDSIZE,GRIDSIZE) :: summedArea
		integer(kind=RegInt_K), intent(in) :: x, y
		integer(kind=RegInt_K), intent(in) :: width, height

		! outputs
		integer(kind=RegInt_K) :: gridSum

		! variables

		! verify input
		if ( x + width - 1 .gt. GRIDSIZE .or. &
				y + height - 1 .gt. GRIDSIZE ) then
			print*,"Error: width or height is so so bad :("
			stop
		end if
		if ( x .lt. 1 .or. y .lt. 1 ) then
			print*,"Error: x or y is bad bad bad :("
			stop
		end if
		if ( width .lt. 1 .or. height .lt. 1 ) then
			print*,"Error: width or height is wrong :("
			stop
		end if

		! The sum of an area of the table is easy m8
		! https://en.wikipedia.org/wiki/Summed_area_table

		! Calculation is dependent on whether we are next to an edge or not :(

		! Possibilities:
		! x = y = 1: sum = summearea(1,1)
		! x = 1, y > 1: sum = area(1, y+height-1) - area(1, y-1)
		! x > 1, y = 1: sum = area( x+width-1, 1) - area(x-1, 1)
		! x > 1, y > 1: sum = area(x+width-1, y+height-1) - area(x+height-1, y-1)
		!                      - area(x-1, y+height-1) + area(x-1, y-1)
		! and of course check that everything is within gridsize.

		if ( x == 1 .and. y == 1 ) then
			gridSum = summedArea(1, 1)
		else if ( x == 1 .and. y .gt. 1 ) then
			gridSum = summedArea(1, y+height-1) - summedArea(1, y-1)
		else if ( x .gt. 1 .and. y == 1 ) then
			gridSum = summedArea(x+width-1, 1) - summedArea(x-1, 1)
		else if ( x .gt. 1 .and. y .gt. 1 ) then
			gridSum = summedArea(x+width-1, y+height-1) &
					- summedArea(x+width-1, y-1) &
					- summedArea(x-1, y+height-1) &
					+ summedArea(x-1, y-1)
		end if

	end function calcGridSum

	function generateSummedArea(grid) result(summedArea)
		implicit none
		integer, parameter :: RegInt_K = selected_int_kind(30)

		! inputs
		integer(kind=RegInt_K), intent(in), dimension(GRIDSIZE,GRIDSIZE) :: grid

		! outputs
		integer(kind=RegInt_K), dimension(GRIDSIZE,GRIDSIZE) :: summedArea

		! variables
		integer(kind=RegInt_K) :: x, y

		! walk over grid, calculating sums
		do x = 1, GRIDSIZE
			do y = 1, GRIDSIZE
				if ( x == 1 .and. y == 1 ) then
					! first square is easy
					summedArea(1,1) = grid(1,1)
				else
					! do stuff
					! value at (x,y) is:
					! grid(x,y) + summed(x-1, y) +
					! summed(x, y-1) - summed(x-1, y-1)
					if ( x == 1 ) then
						! in first column, so x-1 does not exist
						summedArea(x, y) = grid(x, y) + summedArea(x, y-1)
					elseif ( y == 1 ) then
						! in first row, so y-1 does not exist
						summedArea(x, y) = grid(x, y) + summedArea(x-1, y)
					else
						! standard method
						summedArea(x, y) = grid(x, y) + summedArea(x-1,y) &
								+ summedArea(x, y-1) - summedArea(x-1, y-1)
					end if

				end if
			end do
		end do
	end function generateSummedArea
	
	function createFuelCellGrid(serial) result(grid)
		implicit none
		integer, parameter :: RegInt_K = selected_int_kind(30)

		! inputs
		integer(kind=RegInt_K), intent(in) :: serial

		! outputs
		integer(kind=RegInt_K), dimension(GRIDSIZE,GRIDSIZE) :: grid

		! variables
		integer(kind=RegInt_K) :: x, y
		integer(kind=RegInt_K) rackID, powerLevel

		! rackID is x coordinate + 10
		! powerlevel = rackID * y coordinate
		! powerlevel += serial
		! powerlevel *= rackID
		! keep only the hundreds digit
		! subtract 5

		do x = 1, GRIDSIZE
			! rackID is constant for these y values
			rackID = x + 10
			do y = 1, GRIDSIZE
#ifdef DEBUG
				print*, "Coords:", x, y
				print*, "rackID:",rackID
#endif
				powerLevel = rackID * y
#ifdef DEBUG
				print*, "start power:", powerLevel
#endif
				powerLevel = powerLevel + serial
#ifdef DEBUG
				print*, "add serial:", powerLevel
#endif
				powerLevel = powerLevel * rackID
#ifdef DEBUG
				print*, "times rackid:", powerLevel
#endif

				! get hundreds digit of powerLevel
				powerLevel = (powerLevel - &
					( powerLevel / 1000 ) * 1000 ) &
					/ 100
#ifdef DEBUG
				print*, "hundreds:", powerLevel
#endif

				powerLevel = powerLevel - 5
#ifdef DEBUG
				print*, "subtract 5:", powerLevel
#endif
				! save it
				grid(x, y) = powerLevel
			end do
		end do
	end function createFuelCellGrid

	subroutine verifyGridGenerator()
		implicit none
		integer, parameter :: RegInt_K = selected_int_kind(30)

		! inputs
		integer(kind=RegInt_K), dimension(GRIDSIZE,GRIDSIZE) :: cells

		! Fuel cell at 3,5, grid serial number 8: power level 4.
		integer(kind=RegInt_K) :: eight = 8, fiftyseven=57,thirtynine=39,seventyone=71

		cells = createFuelCellGrid(eight)
		print*, "Serial 8, cell 3.5, power 4 = ", cells(3,5)
#ifndef DEBUG
		! Fuel cell at  122,79, grid serial number 57: power level -5.
		cells = createFuelCellGrid(fiftyseven)
		print*, "Serial 57, cell 122,79, power -5 = ", cells(122,79)
		
		! Fuel cell at 217,196, grid serial number 39: power level  0.
		cells = createFuelCellGrid(thirtynine)
		print*, "Serial 39, cell 217,196, power 0 = ", cells(217,196)

		! Fuel cell at 101,153, grid serial number 71: power level  4.
		cells = createFuelCellGrid(seventyone)
		print*, "Serial 71, cell 101,153, power 4 = ", cells(101,153)
#endif
	end subroutine verifyGridGenerator

end program solve
