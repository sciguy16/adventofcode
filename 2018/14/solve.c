#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define DEBUG

#define NUM_ELVES 2

// eww globals
// makes the realloc routine a lot simpler though
size_t numScores, maxScores;

// functions
void advanceUntil( int* scoreboard, int* elves, int target);
void printScores( int* scoreboard, int target);


int main(void)
{
	// start with recipe scores 3, 7
	// set elf positions to 0, 1
	// loop:
	// - sum the scores at the elf positions
	// - the digits of the sum are appended to the score list, in the order
	//   that they were in in the sum (e.g. 10 -> ..., 1, 0)
	// - each elf moves forward by 1 + the score of their current recipe
	//   spaces, modulo the size of the scoreboard
	// - continue until the scoreboard has at least ten plus the target scores
	// - return the ten scores immediately after the target number, as a single
	//   ten digit numeric string
	
	// scoreboard grows by one or two each time. it's probably best to start
	// small and realloc() as needed.
	numScores = 2;
	maxScores = 10;
	int* scoreboard = malloc(maxScores);
	if( scoreboard == NULL )
	{
		fprintf(stderr, "Error allocating %ld bytes for scoreboard\n",
				maxScores);
		exit(1);
	}
	// initialise the starting values
	scoreboard[0] = 3;
	scoreboard[1] = 7;

	// initialise the elves
	int elves[NUM_ELVES] = {0, 1};

	// run the test cases
	advanceUntil( scoreboard, elves, 9 );
	printScores( scoreboard, 9 );

	free(scoreboard);
	exit(0);
}
