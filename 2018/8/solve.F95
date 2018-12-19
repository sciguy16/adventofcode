#define TEST
#define DEBUG

#ifdef TEST
#define INFILE "testinput.vertical"
#else
#define INFILE "input.vertical"
#endif

program solve
	  implicit none

	  integer :: instruction
	  integer :: IOstatus


	  open(1, FILE=INFILE, status="old")
	  instruction = getInstruction()
	  do while (instruction /= -1)
		  print*, instruction
		  instruction = getInstruction()
	  end do
	  print*," [+] Finished processing file!"
	  close(1)

	contains

	! make a recursive function to do the following:
	! function ProcessChild(accumulator) returns accumulator
	! * getInstruction() to get the number of child nodes
	! * getInstruction() to get the metadata and add to accumulator
	! * do i = 1, numChildNodes
	!   - accumulator += ProcessChild(accumulator)
	! win!
	
	function getInstruction()
			implicit none
			! gets the next instruction, or -1 if we reached the end
	
			integer :: getInstruction

			read(1,*, IOSTAT=IOstatus) getInstruction
			if ( IOstatus == 0 ) then
					return
			else
					getInstruction = -1
					return
			end if
	end function getInstruction
end program solve



