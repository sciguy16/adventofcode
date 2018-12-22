#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define OFFSET 5
#define TEST
#define DEBUG

enum isPlant { PLANT, NOPLANT };

// function prototypes
enum isPlant decideGrowth(char subState[]);
void evolve( char state[], size_t stateLength);

int main()
{
		printf(" [+] Loading plant simulation...\n");
		const char initialState[] = 
#ifdef TEST
				"#..#.#..##......###...###"
#else
				"##.##.#.#...#......#..#.###..##...##.#####..#..###.########.##.....#...#...##....##.#...#.###...#.##"
#endif
				;
		const size_t initialStateLength = sizeof(initialState) / sizeof(char);

		// variables
		// make a state variable with enough space for the inital state as well
		// as some preceding empty plant pots
		const size_t stateLength = initialStateLength + OFFSET;
		char state[ stateLength ];
		int i;

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

		evolve( state, stateLength );
		printf("State is now:\n%s\n", state);
		

		return 0;
}


void evolve( char state[], const size_t stateLength )
{

		printf(" [+] doin' me an evolve...\n");

		// initialise a new state
		char newState[ stateLength ];
		newState[0] = '\0';
		char subState[6];

		int i, j;

		// iterate over the old state to produce a new state
		for( i = 0; i < stateLength; i++ ) {
				// build a substate
				subState[0] = '\0'; // "empty" the string
				for( j = 0; j < 5; j++ ) {
					// if i is at the start or end then pre-/append some empty
					// pots, otherwise copy straight out of the state
					if( i <= 1 && j == 0 ) subState[j] = 'p'; // TODO: change from p to . when it works
					else if( i == 1 && j == 1 ) subState[j] = 'p';
					else if( i >= stateLength - 2 && j == 4 ) subState[j] = 'p';
					else if( i == stateLength - 2 && j == 3 ) subState[j] = 'p';
					else subState[j] = state[i+j-1];
					// probably need to rewrite this whole substate generator, yay...
					// simple hack: operate on a state that's two longer than
					// the input state on each end by empty pots and truncate at the end?
				}
				printf(" [+] Generated substate %s\n", subState);
		}
		printf(" [+] New state: %s\n", newState);

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
