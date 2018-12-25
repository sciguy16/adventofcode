#include<stdio.h>
#include<stdlib.h>
#include<string.h>

//#define DEBUG

#define NUM_ELVES 2

// eww globals
// makes the realloc routine a lot simpler though
size_t numScores, maxScores;
int* scoreboard;

// functions
void advanceUntil( int* elves, int target);
void printScores( int target);


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
	maxScores = 10;
	scoreboard = malloc(maxScores * sizeof( int ));
	if( scoreboard == NULL )
	{
		fprintf(stderr, "Error allocating %ld bytes for scoreboard\n",
				maxScores);
		exit(1);
	}
	// initialise the starting values
	numScores = 2;
	scoreboard[0] = 3;
	scoreboard[1] = 7;

	// initialise the elves
	int elves[NUM_ELVES] = {0, 1};

	// run the test cases
	advanceUntil( elves, 990941 );
	printScores( 5 );
	printScores( 9 );
	printScores( 18 );
	printScores( 2018 );
	printScores( 990941 );

	free(scoreboard);
	exit(0);
}


void advanceUntil( int* elves, int target )
{
	// build up the scoreboard until we have at least target + 10 scores
	int scoreSum, digit;
	int i;
	int* tempScoreboard;
	while( numScores < target + 10 )
	{
		// check that there is enough space on the scoreboard
		if( numScores + 10 > maxScores )
		{
#ifdef DEBUG
			printf( " [+] Growing the scoreboard...\n" );
#endif
			// allow a bit of room so that we're not reallocing each round
			tempScoreboard = realloc( scoreboard,
					(maxScores + 10) * sizeof( int ) );
			if( tempScoreboard == NULL )
			{
				free( scoreboard );
				fprintf(stderr, "Unable to grow the scoreboard to %ld ints\n",
						maxScores + 10 );
				exit(1);
			}
			scoreboard = tempScoreboard;
			maxScores+= 10;
		}


		// sum the scores at the elves' positions
		scoreSum = scoreboard[elves[0]] + scoreboard[elves[1]];

		// put the digits into the scoreboard
		if( scoreSum > 99 )
		{
			// this probably should never happen
			free(scoreboard);
			fprintf(stderr, "Something terrible has happened :(\n");
			exit(1);
		}
		if( scoreSum > 9 )
		{
			// there is something in the tens position
			digit = scoreSum / 10;
#ifdef DEBUG
			printf("Found tens digit: %d\n", digit);
#endif
			scoreboard[ numScores ] = digit;
			numScores++;
		}

		// there is probably always something in the ones position
		digit = scoreSum % 10; // this sneakily gets just the ones position
#ifdef DEBUG
		printf("Found ones digit: %d\n", digit);
#endif
		scoreboard[ numScores ] = digit;
		numScores++;

		// shift the elves
		for( i = 0; i < 2; i++ )
		{
			elves[i] = ( elves[i] + 1 + scoreboard[ elves[i] ] ) % numScores;
		}
#ifdef DEBUG
		// print the partial scoreboard
		for( i = 0; i < numScores; i++ )
		{
			printf(" %d", scoreboard[i] );
		}
		printf("\n");
#endif
	}
}


void printScores( int target )
{
	// print the ten scores following target
	int i;
#ifdef DEBUG
	printf(" [+] printing the winning scores...\n" );
	printf("Target is: %d, numscores is: %ld\n",
		 target, numScores );
	printf("Numscores + target is %ld\n", numScores + target);
#endif
	if( numScores < target + 10 )
	{
		free( scoreboard );
		fprintf(stderr, "Something bad happened and the scoreboard isn't "
				"actually long enough to get the answer out!\n");
		exit(1);
	}

	printf(" [+] Ten scores after target %d: ", target );
	for( i = 0; i < 10; i++ ) 
	{
		printf("%d", scoreboard[ i + target ]);
	}
	printf("\n");
}
