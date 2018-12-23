#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define OFFSET 7
//#define TEST
//#define DEBUG
#define NUM_CYCLES 20

enum isPlant { PLANT, NOPLANT };

// function prototypes
enum isPlant decideGrowth(char subState[]);
int evolve( char state[], size_t stateLength);

int main()
{
		printf(" [+] Loading plant simulation...\n");
		const char initialState[] = 
#ifdef TEST
				"#..#.#..##......###...###..........."
#else
				"##.##.#.#...#......#..#.###..##...##.#####..#..###.########.##.....#...#...##....##.#...#.###...#.##......................"
#endif
				;
		const size_t initialStateLength = sizeof(initialState) / sizeof(char);

		// variables
		// make a state variable with enough space for the inital state as well
		// as some preceding empty plant pots
		const size_t stateLength = initialStateLength + OFFSET;
		char state[ stateLength ];
		int i;
		int potSum = 0;
		int evolveOutput;

		
		printf("size of initial state is %lu\n", initialStateLength);

		printf("Initial state:\n%s\n", initialState);

		printf("Grow: %d, nogrow: %d\n",
						decideGrowth("##.##"),
						decideGrowth("....."));

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
			evolveOutput = evolve( state, stateLength );
			potSum += evolveOutput;
			printf("%02d: %s + %d = %d\n", i, state, evolveOutput,
					potSum);
		}
		

		return 0;
}


int evolve( char state[], const size_t stateLength )
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
		int potSum = 0;

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
					potSum += i - OFFSET - 2;
#ifdef DEBUG
					printf("pot %d gets a plant\n", i - OFFSET - 2);
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
