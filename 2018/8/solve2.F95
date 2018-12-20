!#define TEST
!#define DEBUG

#ifdef TEST
#define INFILE "testinput.vertical"
#define MAXCHILDREN 5
#else
#define INFILE "input.vertical"
#define MAXCHILDREN 10
#endif

program solve
	  implicit none

	  integer :: totalMeta


	  open(1, FILE=INFILE, status="old")
	  !instruction = getInstruction()
	  !do while (instruction /= -1)
	!	  print*, instruction
	!	  instruction = getInstruction()
	
	 ! end do

#ifdef DEBUG
	  print*, "         depth    numChildren  numMeta       accum"
	  !       #           0           2           3           3
#endif
	  totalMeta = processChild(0)
	  print*," [+] Finished processing file!"
	  print*, " [+] total meta is ", totalMeta
#ifdef TEST
	  print*, " Correct answer is 66"
#endif
	  close(1)

	contains

	! make a recursive function to do the following:
	! function ProcessChild(accumulator) returns accumulator
	! * getInstruction() to get the number of child nodes
	! * getInstruction() to get the metadata and add to accumulator
	! * do i = 1, numChildNodes
	!   - accumulator += ProcessChild(accumulator)
	! win!
	
	recursive function processChild(depth) result(accumulator)
			implicit none

			! Structure:
			!  - Number of children (1)
			!  - Number of metadata entries (1)
			!  - Zero or more children
			!  - Zero or more metadata entries

			! inputs
			!integer, intent(in) :: accumulatorInput
			integer, intent(in) :: depth

			! variables
			integer :: accumulator
			integer :: i
			integer :: numChildNodes, numMetadata, metadata, childOutput
			integer, dimension(MAXCHILDREN) :: childValues

			accumulator = 0
			childValues(:) = 0
#ifdef DEBUG
			print*, "processChild called on ", accumulator, " at depth ", depth
#endif
			numChildNodes = getInstruction()
			numMetadata = getInstruction()
			if ( numChildNodes == -1 .or. numMetadata == -1 ) then
					print*, "Error error. Very bad :("
					stop
			end if

			!accumulator = accumulator + metadata
#ifdef DEBUG
			print*, depth, numChildNodes, numMetadata, accumulator
#endif
			if( numChildNodes /= 0 ) then
					! there are child nodes, let's process them
#ifdef DEBUG
				print*, " [+] got a child, current accumulator", accumulator
#endif
				if ( numChildNodes > MAXCHILDREN ) then
						print*, "Error!! Too many children (", numChildNodes, ")"
						stop
				end if
				do i = 1, numChildNodes
					childOutput = processChild(depth + 1)
					childValues(i) = childOutput
				end do
			end if

			! If a node has no children then its value is the sum of its metadata
			! Otherwise the metadata entries are indices into the children:
			! - value is the sum of the referenced children
			! - ignore metadata values of zero or greater than numChildNodes
			if( numMetadata /= 0 ) then
					! there is some metadata, let's fetch it
				do i = 1, numMetadata
					metadata = getInstruction()
					if( metadata == -1 ) then
							print*, "Error error :'("
							stop
					end if
					if( numChildNodes == 0 ) then
							! no children, sum the metadata
							accumulator = accumulator + metadata
					else
							! many children, let's use the metadata as indices instead
							if( 0 .lt. metadata .and. metadata .lt. numChildNodes + 1 ) then
									! it's a valid index, let's go go go
									accumulator = accumulator + childValues(metadata)
							end if
					end if
#ifdef DEBUG
					print*, "Add meta ", metadata, " to get ", accumulator
#endif
				end do
			end if

	end function processChild
			
	function getInstruction()
			implicit none
			! gets the next instruction, or -1 if we reached the end
	
			integer :: getInstruction
	  		integer :: IOstatus

			read(1,*, IOSTAT=IOstatus) getInstruction
			if ( IOstatus == 0 ) then
					return
			else
					getInstruction = -1
					return
			end if
	end function getInstruction
end program solve



