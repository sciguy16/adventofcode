#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdint.h>


#define DEBUG
#define TEST

#define TESTNUM 1

#ifdef TEST
#define INFILE "testinput"
#else
#define INFILE "infile"
#endif

#define  EMPTY_MASK 0b10000000
#define   WALL_MASK 0b01000000
#define GOBLIN_MASK 0b00100000
#define    ELF_MASK 0b00010000
#define     HP_MASK 0xFF

// enums are for pros
enum blocks {
	GOBLIN, ELF, WALL, EMPTY
};
enum combatStates {
	COMBAT_END, COMBAT_NOT_END
};
enum directions {
	UP, LEFT, RIGHT, DOWN, NONE
};

// structs are good
struct coord {
	int x;
	int y;

};

// yay globals (of doom)
 // map
size_t maplength;
uint16_t* map;
struct coord mapsize;

/* map is an array of uint16_t
 * : lower byte is for the hit points
 * : uppwe 8 bytes are a mask for the type of block
 * : 1000 0000 = empty
 * : 0100 0000 = wall
 * : 0010 0000 = goblin
 * : 0001 0000 = elf
 */

 // combatants
size_t numelves;
size_t numgoblins;

// functions
void error( char* message );
void load_map( char infile[] );
enum blocks char_to_block( char block );
enum blocks uint16_to_block( uint16_t block );
uint8_t block_to_mask( enum blocks block );
char block_to_symbol( enum blocks block );
void print_map( void );
enum combatStates battle(void);
void find_enemies( enum blocks enemy,
		struct coord* enemies, size_t numenemies );
enum directions adjacent( enum blocks enemy, struct coord unitcoord );
size_t get_turn_order( struct coord* allunits, size_t maxunits );

int main( void )
{
	printf(" [+] Loading goblin combat simulation...\n");

	// put aside some memory
	maplength = 200;
	map = malloc( maplength * sizeof(uint16_t) );

	load_map(INFILE);

	print_map();

	battle();

	print_map();

	/*
	while( units_alive() > 0 )
	{
		battle();
		print_map();
	}
	*/

	return 0;
}


enum combatStates battle(void)
{

#ifdef DEBUG
	printf( " [+] Entering the battle...\n" );
#endif

	/* during each round, each unit that is still alive takes a turn and
	* resolves all of its actions
	*
	* a turn consists of two actions:
	*  - try to move in range of an enemy
	*  - attack if in range
	*
	* - no diagonal attacks or movements
	* - ties are broken in reading order
	* 
	* turn structure:
	*  - identify all enemy units
	*    * if no targets remain then combat ends
	*  - identify all open squares in range of each target
	*    * adjacent to any target (up, down, left, right)
	*    * not wall or other unit
	*    * if not in range of target and there are no open squares in range
	*      of a target then the unit ends its turn
	*  - if in range of a target, do not move, do attack
	*    * otherwise move
	*  - move:
	*    * choose closest in range square (manhatten)
	*    * if cannot reach a square then end turn
	*    * break ties in reading order
	*    * take a single step towards the chosen square
	*  - attack:
	*    * determine all enemy units adjacent
	*    * if none then end turn
	*    * choose target with fewest hit points
	*    * deal damage equal to attack power to target
	*      - if target's hit points are reduced to 0 or below then target dies
	*        and its square becomes '.' (it takes no further turns)
	*
	* each unit (goblin or elf) has 3 attack power and starts with 200 hit points
	*/

	// variables
	enum blocks block, enemy;
	//int row, col;
	int unit;

	size_t numenemies;
	size_t numunits;
	size_t maxenemies = numgoblins > numelves?
		numgoblins: numelves;

	struct coord enemies[maxenemies];
	struct coord allunits[ numgoblins + numelves ];
	struct coord unitcoord;

	numunits = get_turn_order(allunits, numgoblins + numelves);

#ifdef DEBUG
	printf(" [+] Generated a turn order for %zu units\n", numunits);
#endif

	// Assume that there is at least one unit alive, as that is the condition
	// on the while loop in main()
	
	// Iterate over all units
	for( unit = 0; unit < numunits; unit++ )
	//for( row = 0; row < mapsize.y; row++ )
	{
	//	for( col = 0; col < mapsize.x; col++ )
	//	{
			unitcoord = allunits[ unit ];
			block = uint16_to_block(
					map[ unitcoord.y * mapsize.x + unitcoord.x ] );
			if( block == EMPTY || block == WALL )
			{
				// empty blocks and walls probably don't need to take a turn at
				// combat
				continue;
			}
			
			// enemy is the opposite of what we are
			enemy = block == GOBLIN? ELF: GOBLIN;
			numenemies = block == GOBLIN? numelves: numgoblins;

			// check to see whether an adjacent square is an enemy - if this is
			// the case then we bypass movement and go straight to the attack
			// phase
			if( adjacent( enemy, unitcoord ) != NONE )
			{
				goto ATTACK;
			}

			// no one is adjacent, so let's look for someone to pick a fight
			// with
			find_enemies( enemy, enemies, numenemies );

ATTACK:
			// enter attack phase
#ifdef DEBUG
			printf( " [+] Entering attack phase...\n" );
#endif
	//	}
	}	
	
	// if no targets remain then end combat
	return COMBAT_END;
}

size_t get_turn_order( struct coord* allunits, size_t maxunits )
{
	// go through the map and write down the turn order for all units
	int row, col;
	size_t unitcount;
	enum blocks block;

	unitcount = 0;
	
	for( row = 0; row < mapsize.y; row++ )
	{
		for( col = 0; col < mapsize.x; col++ )
		{
			block = uint16_to_block( map[ row * mapsize.x + col ] );
			if( block == ELF || block == GOBLIN )
			{
				// it's the big unit! let's add its coords to our list
				allunits[unitcount].x = row;
				allunits[unitcount].y = col;
				unitcount++;
			}
		}
	}
	if( unitcount != maxunits )
	{
		// there is an inconsistency somewhere
		error( "There is an inconsistency in the number of big units" );
	}
	return unitcount;
}

void find_enemies( enum blocks enemy,
		struct coord* enemies, size_t numenemies )
{
	// finds the enemies
	int row, col;
	enum blocks block;
	size_t enemycount = 0;
	for( row = 0; row < mapsize.y; row++ )
	{
		for( col = 0; col < mapsize.x; col++ )
		{
			block = uint16_to_block(
				map[ row * mapsize.x + col ] );
			if( block == enemy )
			{
				enemies[ enemycount ].x = col;
				enemies[ enemycount ].y = row;
				enemycount++;

				// make sure we are not overflowing the array
				if( enemycount > numenemies )
				{
					error( "many an anemone has too many enemies, like the "
							"enemies we have just found :(" );
				}
			}
		}
	}
	if( enemycount != numenemies )
	{
		error( "did not find the right number of enemies" );
	}
}

enum directions adjacent( enum blocks enemy, struct coord unitcoord )
{
	// check to see whether there is an adjacent bloke of type "enemy"
	
	return NONE;
}

void error( char* message )
{
	// die gracefully in an error state
	free( map );
	fprintf(stderr, " [*] An exception has been raised: %s\n", message );
	exit(1);
}


void load_map( char infile[] )
{
	printf( " [+] Loading map from file %s...\n", infile );

	// set a buffer
	const size_t buflen = 200;
	char buffer[ buflen ];
	FILE* f = fopen( infile, "r" );

	uint16_t* newmap;

	int i;
	int width, height;

	enum blocks block_type;

	// initialise the global counters for the numbers of goblins and elves
	numelves = 0;
	numgoblins = 0;

	// initialise a counter for the height
	height = 0;

	while( fgets( buffer, buflen, f ) )
	{
		// strip the newline
		buffer[ strcspn( buffer, "\n" ) ] = '\0';
		width = strlen( buffer );
		height++;

		if( width * height +1 > maplength )
		{
			// out of space in map
#ifdef DEBUG
			printf( " [+] Reallocating map...\n" );
#endif
			maplength = width * ( height + 1 ) + 1;
			newmap = realloc( map, maplength * sizeof(uint16_t) );
			if( newmap == NULL )
			{
				free(map);
				fprintf(stderr, "Error reallocating map\n");
				exit(1);
			}
			map = newmap;
		}

		//strncat( map, buffer, width );
		// iterate over the width, setting the things in the thing
		for( i = 0; i < width; i++ )
		{
			// get the type
			block_type = char_to_block( buffer[ i ] );
			map[ (height - 1) * width + i ] =
				( block_to_mask( block_type ) << 8 ) + 200;
			if( block_type == GOBLIN )
			{
				numgoblins++;
			}
			else if ( block_type == ELF )
			{
				numelves++;
			}
		}
#ifdef DEBUG
		printf("buffer (%ld): %s\n", strlen(buffer), buffer );
#endif

	}

	mapsize.x = width;
	mapsize.y = height;
#ifdef DEBUG
	printf( " [+] Loaded %dx%d map!\n", mapsize.x, mapsize.y );
	printf( " [+] There are %zu goblins and %zu elves\n", numgoblins, numelves );
#endif

}

uint8_t block_to_mask( enum blocks block )
{
	char msg[30];
	switch( block )
	{
		case WALL:
			return WALL_MASK;
			break;
		case EMPTY:
			return EMPTY_MASK;
			break;
		case GOBLIN:
			return GOBLIN_MASK;
			break;
		case ELF:
			return ELF_MASK;
			break;
		default:
			break;
	}
	snprintf( msg, 29, "Unrecognised block: %d", block );
	error( msg );
	return EMPTY;
}

char block_to_symbol( enum blocks block )
{
	char msg[30];
	switch( block )
	{
		case WALL:
			return '#';
			break;
		case EMPTY:
			return '.';
			break;
		case GOBLIN:
			return 'G';
			break;
		case ELF:
			return 'E';
			break;
		default:
			snprintf( msg, 29, "Unrecognised block: %d", block );
			error( msg );
	}
	return '*';
}

enum blocks uint16_to_block( uint16_t block )
{
	char msg[30];
	if( block & EMPTY_MASK << 8 )
	{
		return EMPTY;
	} else if ( block & WALL_MASK << 8 ) {
		return WALL;
	} else if ( block & GOBLIN_MASK << 8 ) {
		return GOBLIN;
	} else if ( block & ELF_MASK << 8 ) {
		return ELF;
	} else {
		snprintf( msg, 29, "Unrecognised block: %hu", block );
		error( msg );
	}
	return EMPTY;
}

enum blocks char_to_block( char block )
{
	// takes a block and returns its type
	char msg[30];
	switch( block )
	{
		case '#':
			return WALL;
			break;
		case '.':
			return EMPTY;
			break;
		case 'G':
			return GOBLIN;
			break;
		case 'E':
			return ELF;
			break;
		default:
			snprintf( msg, 29, "unrecognised block: %c", block );
			error( msg );
	}
	return WALL;
}

void print_map( void )
{
	// prints the map
	
	// iterate over each row of the map, printing out the relevant symbols for
	// each type of square occupant. Also print the health points for goblins
	// and elves beside the rows for debugging purposes
	
	int row, col;
	size_t i;
	char symb;
	uint8_t hp;
	enum blocks block;

	size_t numDudes = 0;
	uint8_t rowHP[mapsize.x];

#ifdef DEBUG
	printf( " [+] Printing the map...\n" );
#endif

	for( row = 0; row < mapsize.y; row++ )
	{
		// yay rows
		// go over each column and print the correct character
		numDudes = 0;
		for( col = 0; col < mapsize.x; col++ )
		{
			// yay columns
			hp = map[ row * mapsize.x + col ] & HP_MASK;

			block = uint16_to_block(
						map[ row * mapsize.x + col ] );
			symb = block_to_symbol( block );
			printf("%c", symb);

			if( block == GOBLIN || block == ELF )
			{
				rowHP[numDudes] = hp;
				numDudes++;
			}
		}

		// print out the hitpoints after each row
		for( i = 0; i < numDudes; i++ )
		{
			printf(" %hhu", rowHP[i]);
		}

		// stick a newline on for luck
		printf("\n");
	}

}

