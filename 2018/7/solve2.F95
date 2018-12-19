!#define TEST
!#define DEBUG

#ifdef TEST
#define INFILE "testinput.csv"
#define NUMEDGES 7
#define NUMVERTICES 6
#define NUMWORKERS 2
#define TASKTIME 0
#else
#define INFILE "input.csv"
#define NUMEDGES 101
#define NUMVERTICES 26
#define NUMWORKERS 5
#define TASKTIME 60
#endif


! Strategy:
! * make two integer arrays:
!  - workerTimes: how long each worker has left on their current task
!  - workerJobs: which job each worker is doing (0 for no job)
! * at each step, if a worker is zero and there is a valid task available then
!   make that worker do the task (set workerJobs(worker) = task and set time)
! * at the start of each step, check to see whether all tasks are complete
! * Decrement every nonzero worker
! * exit at some point (maybe if all tasks are complete)
program solve
      implicit none

        ! variables
        logical, dimension(NUMVERTICES,NUMVERTICES) :: graph
		logical, dimension(NUMVERTICES) :: completedTasks
		logical, dimension(NUMVERTICES) :: inProgressTasks
		
		integer, dimension(NUMWORKERS) :: workerTimes
		integer, dimension(NUMWORKERS) :: workerJobs

		integer :: currentTime, stepSize

		integer :: source, dest

        integer :: i
		integer :: worker, task

        ! functions

        open(1, FILE=INFILE, status="old")

        ! initialise the graph
        graph = .false.

        ! read in the file and convert it to an adjacency matrix
        do i=1, NUMEDGES
                read(1,*) source, dest
                graph(source, dest) = .true.
        end do

#ifdef DEBUG
        call printGraph(graph)
#endif

		! Initialise worker arrays
		workerTimes = 0
		workerJobs = 0
		currentTime = 0
		completedTasks = .false.
		inProgressTasks = .false.

		do while (.true.)
#ifdef DEBUG
			print*, " [+] Starting loop ", currentTime
#endif
			! if any job has just completed (i.e. job is in workerJobs but
			! workerTime is zero) then mark job as complete and release worker
			do i = 1, NUMWORKERS
				if ( workerJobs(i) /= 0 .and. workerTimes(i) == 0 ) then
#ifdef DEBUG
					print*,"Worker ", i, " just completed ", workerJobs(i)
#endif
					completedTasks(workerJobs(i)) = .true.
					inProgressTasks(workerJobs(i)) = .false.
					workerJobs(i) = 0
				end if
			end do

			! if all jobs completed then quit
			if ( all( completedTasks(:) ) ) then
					print*, " [+] All tasks completed in time ", currentTime
					stop
			end if

			! if a worker is available
			do worker = 1, NUMWORKERS
				if (workerTimes(worker) .eq. 0) then
					! if there is a valid task available
					! a task is valid if all incoming edges are from completed nodes
					! that is, if NOT any( incoming) AND NOT completed )
#ifdef DEBUG
					print*, " [+] Worker ", worker, " is available"
#endif
					do task = 1, NUMVERTICES
						if ( .not. any( graph(:,task) .and. .not. completedTasks(:) ) .and. &
								.not. inProgressTasks(task) .and. .not.completedTasks(task) ) then
							! assign that task to the worker
#ifdef DEBUG
							print*, " [+] assiging task ", task, " to worker ", worker, "..."
#endif
							workerTimes(worker) = TASKTIME + task
							workerJobs(worker) = task
							inProgressTasks(task) = .true.

							! exit inner do loop and look for another available worker
							exit
						end if
					end do
				end if
			end do

#ifdef DEBUG
			print*," [+] Maybe we have assigned some jobs to workers"
			print*, "Workerjobs:  ", workerJobs
			print*, "Workertimes: ", workerTimes
			print*, "inProgress:  ", inProgressTasks
			print*, "completed:   ", completedTasks
#endif


			! find minimum nonzero worker time so that we can skip some steps
			stepSize = 1

			! decrement nonzero workers
			do i = 1, NUMWORKERS
				if ( workerTimes(i) .gt. 0 ) then
					workerTimes(i) = workerTimes(i) - stepSize
				end if
			end do
			! increment step counter
			currentTime = currentTime + stepSize
		end do

! we apparently don't need printGraph outside of debug mode
#ifdef DEBUG
contains


	subroutine printGraph(graph)
		implicit none

		logical, intent(in), dimension(NUMVERTICES, NUMVERTICES) :: graph

		integer :: i

		do i = 1, NUMVERTICES
			print*, i, graph(i,:)
		end do
	end subroutine printGraph
#endif
	
end program solve

