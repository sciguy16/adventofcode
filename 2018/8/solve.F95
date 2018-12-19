#define TEST
#define DEBUG

#ifdef TEST
#define INFILE "testinput.vertical"
#else
#define INFILE "input.vertical"
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

	  totalMeta = processChild(0)
	  print*," [+] Finished processing file!"
	  print*, " [+] total meta is ", totalMeta
	  close(1)

	contains

	! make a recursive function to do the following:
	! function ProcessChild(accumulator) returns accumulator
	! * getInstruction() to get the number of child nodes
	! * getInstruction() to get the metadata and add to accumulator
	! * do i = 1, numChildNodes
	!   - accumulator += ProcessChild(accumulator)
	! win!
	
	recursive function processChild(accumulatorInput) result(accumulator)
			implicit none

			! inputs
			integer, intent(in) :: accumulatorInput

			! variables
			integer :: accumulator
			integer :: i
			integer :: numChildNodes, metadata

			accumulator = accumulatorInput

			numChildNodes = getInstruction()
			metadata = getInstruction()
			if ( numChildNodes == -1 .or. metadata == -1 ) then
					print*, "Error error. Very bad :("
					stop
			end if

			print*, "numchild:", numChildNodes, "meta:",metadata


			accumulator = accumulator + metadata
			if( numChildNodes == 0 ) then
					! we have reached the end, skip to end of the function
					goto 100
			end if

			do i = 1, numChildNodes
					accumulator = accumulator + processChild(accumulator)
			end do
			100 return
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



