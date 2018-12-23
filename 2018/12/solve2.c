#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define OFFSET 7
#define STATUS
//#define TEST
//#define DEBUG
//#define NUM_CYCLES 300
#define NUM_CYCLES 50000000000

enum isPlant { PLANT, NOPLANT };

// function prototypes
enum isPlant decideGrowth(char subState[]);
long int evolve( char state[], size_t stateLength, long int shift );
long int shiftPots( char state[], size_t stateLength, long int shiftOffset );
size_t checkRealloc( char state[], size_t stateLength );

int main()
{
		printf(" [+] Loading plant simulation...\n");
		const char initialState[] = 
#ifdef TEST
				"#..#.#..##......###...###..........."
#else
				"##.##.#.#...#......#..#.###..##...##.#####..#..###.########.##.....#...#...##....##.#...#.###...#.##........."
#endif
				;
		const size_t initialStateLength = sizeof(initialState) / sizeof(char);

		// variables
		// make a state variable with enough space for the inital state as well
		// as some preceding empty plant pots
		size_t stateLength = initialStateLength + OFFSET;
		//char state[ stateLength ];
		char* state = malloc( stateLength * sizeof(char) );
		if( state == NULL ) return -1;
		long int i;
		long int evolveOutput;
		long int shiftOffset = 0;
		long int diff;
		long int prevOut = 0;

		
		printf("size of initial state is %lu\n", initialStateLength);
		printf("Initial state:\n%s\n", initialState);

		// Load up the initial state
		for( i = 0; i < stateLength; i++) {
				state[i] = 0;
		}
		for( i = 0; i < OFFSET; i++ ) {
				strcat(state, ".");
		}
		strncat( state, initialState, stateLength - OFFSET);
		printf("State is now:\n%s\n", state);

		// chooch through a number of stages of evolution:
		printf("%02d: %s\n", 0, state);
		for( i = 1; i < NUM_CYCLES + 1; i++ )
		{
			evolveOutput = evolve( state, stateLength, shiftOffset );
#ifndef STATUS
			if( i > NUM_CYCLES - 10 )
#endif
			{
			  diff = evolveOutput - prevOut;
			  printf("%02ld: %s = %ld (%ld)\n",
				 i, state, evolveOutput, diff );
			  prevOut = evolveOutput;
			}

			// periodically shift the pots to the left so
			// that we don't run out of space
			shiftOffset = shiftPots(
				state, stateLength, shiftOffset );

			// make sure our array is long enough
			stateLength = checkRealloc(state, stateLength);


			// if we have done about 200 cycles then the output
			// probably has a fixed diff, so let's cheat and
			// use linear algebra
			if( i > 200 )
			{
				printf(" [+] Assuming a diff of %ld...\n",
						diff);
				prevOut = evolveOutput + 
					(NUM_CYCLES - i)*diff;
				printf( "[+] Answer is: %ld\n", prevOut);
				break;
			}
		}
		

		// don't forget to free the state
		free(state);

		return 0;
}


size_t checkRealloc( char state[], size_t stateLength )
{
	// check how many dots are at the end, and if there aren't enough we
	// increase the buffer size and add some more
	
	int i;
	char *newState; // needed in case realloc fails
	// noGood is a flag that will tell us to realloc
	int noGood = 0;

	for( i = stateLength - 5; i < stateLength; i++ )
	{
		if( state[i] != '.' )
		{
			noGood = 1;
			break;
		}
	}

	// if nogood then we have to make more memory
	if( noGood == 1 )
	{
		printf("Boost!\n");
		// time to realloc
		newState = realloc(state, sizeof(char) * (stateLength + 5) );
		
		// check whether it worked
		if ( newState == NULL )
		{
			// oh no! abort! abort!
			free(state);
			fprintf(stderr, "Error: out of memory\n");
			exit(255);
		}

		// if we got this far then it's safe to overwrite state
		state = newState;

		// stick an extra few dots on the end
		strcat( state, "....." );

		// return the new length so that we know where we are
		return stateLength + 5;
	}

	return stateLength;
}


long int shiftPots( char state[], const size_t stateLength, long int shiftOffset )
{

	int i;

	// if there are enough dots at the start then chop them and add to 
	// shiftOffset and return it.
	
	if( strncmp( state, ".............", 9 ) == 0 )
	{
#ifdef STATUS
		printf("Shifting the window!\n");
#endif
		// there are lots of dots at the start, so we'll chop five and
		// add five to the offset

		// iterate over the state, shifting everything left by 5
		for( i = 0; i < stateLength - 5; i++ )
		{
			state[i] = state[ i + 5 ];
		}
		// add five dots to the end to compensate
		for( i = stateLength - 5; i < stateLength; i++ )
		{
			state[i] = '.';
		}

		// return the new offset, which has grown by 5
		return shiftOffset + 5;
	}

	// otherwise we leave it be
	return shiftOffset;
}

long int evolve( char state[], const size_t stateLength, long int shiftOffset )
{

#ifdef DEBUG
		printf(" [+] doin' me an evolve...\n");
#endif

		// make a slightly longer state as a bit of a bodge so that
		// there are two "virtual" empty plant pots at each end
		char extendedState[ stateLength + 4 ];

		// initialise a new state
		char newState[ stateLength ];
		newState[0] = '\0';
		char subState[6];

		int i, j;
		long int potSum = 0;

		// extend the state by prepending an appending two empty pots
		extendedState[0] = '\0'; // ensure that it is a proper string
		strcat( extendedState, ".." );
		strncat( extendedState, state, stateLength ) ;
		strcat( extendedState, ".." );

#ifdef DEBUG
		printf( "Original state is:   %s\n"
			"Extended state is: %s\n",
			state, extendedState);
#endif


		// iterate over the old state to produce a new state
		// add an offset of 2 to account for the state extension
		for( i = 0 + 2; i < stateLength + 2; i++ ) {
				// build a substate
				subState[5] = '\0'; // "empty" the string
				for( j = 0; j < 5; j++ ) {
					// to generate the substate
					// corresponding to position i of the
					// state, we need i-2, i-1, i, i+1, i+2
					// from the extended state
					subState[j] = extendedState[ i+j-2 ];
				}
#ifdef DEBUG
				printf(" [+] Generated substate %s\n", subState);
#endif
				// determine whether the substate evolves to a
				// plant or not
				if( decideGrowth(subState) == PLANT )
				{
					// a new plant is born!
					strcat(newState, "#");
					// -OFFSET accounts for the offset
					// prepended at the start of the program
					// -2 accounts for the state extension
					// shiftOffset accounts for the shifting
					// of our window into the world of the
					// planomaton
					potSum += i - OFFSET - 2 + shiftOffset;
#ifdef DEBUG
					printf("pot %d gets a plant\n",
							i - OFFSET - 2 + shiftOffset);
#endif
				} else {
					// no plant today :(
					strcat(newState, ".");
				}
		}


#ifdef DEBUG
		printf(" [+] New state: %s\n", newState);
#endif
		for( i = 0; i < stateLength; i++ )
		{
			state[i] = newState[i];
		}
		// apparently the null termination got messed up
		state[stateLength] = '\0';

		return potSum;
}


enum isPlant decideGrowth(char subState[])
{
		// Takes in a 5 character substate and returns:
		// * 1 if the result is a plant
		// * 0 if the result is not a plant

		// constant list of rules for the automaton
		const char plantOutputtingState[][6] = {
#ifdef TEST
			"...##",
			"..#..",
			".#...",
			".#.#.",
			".#.##",
			".##..",
			".####",
			"#.#.#",
			"#.###",
			"##.#.",
			"##.##",
			"###..",
			"###.#",
			"####."
#else
			".###.",
			"###.#",
			"#..#.",
			".#..#",
			"...##",
			".#.##",
			"#.##.",
			"#.#..",
			".#...",
			".##.#",
			"##...",
			"###..",
			"##..#",
			"..#.#",
			".#.#.",
			"####."
#endif
		};
		// hopefully we know how many rules there are
		const int numRules = sizeof(plantOutputtingState) /
				( 6 * sizeof(char) );

		// other variables
		int i;

		for( i = 0; i < numRules; i++ )
		{
				if( strcmp(subState, plantOutputtingState[i]) == 0 )
				{
						// we got a match! Return PLANT
						return PLANT;
				}
		}
		// If we reached here then we did not get a plant :(
		return NOPLANT;
}
