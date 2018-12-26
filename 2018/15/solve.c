#include<stdio.h>
#include<stdlib.h>
#include<string.h>


#define DEBUG
#define TEST

#define TESTNUM 1

#ifdef TEST
#define INFILE "testinput"
#else
#define INFILE "infile"
#endif

// structs are good
struct coord {
	int x;
	int y;
};

// enums are for pros
enum blocks {
	GOBLIN, ELF, WALL, EMPTY
};


// yay globals (of doom)
size_t maplength;
char* map;
struct coord mapsize;

// functions
void error( char* message );
void load_map( char infile[] );
enum blocks block_type( char block );
void battle(void);

int main( void )
{
	printf(" [+] Loading goblin combat simulation...\n");

	// put aside some memory
	maplength = 200;
	map = malloc( maplength * sizeof(char) );

	load_map(INFILE);

	battle();

	return 0;
}


void battle(void)
{
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

	char* newmap;

	int width, height;

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
			newmap = realloc( map, maplength * sizeof(char) );
			if( newmap == NULL )
			{
				free(map);
				fprintf(stderr, "Error reallocating map\n");
				exit(1);
			}
			map = newmap;
		}

		strncat( map, buffer, width );
#ifdef DEBUG
		printf("buffer (%ld): %s\n", strlen(buffer), buffer );
#endif

	}
	mapsize.x = width;
	mapsize.y = height;
#ifdef DEBUG
	printf( " [+] Loaded %dx%d map!\n", mapsize.x, mapsize.y );
#endif
}


enum blocks block_type( char block )
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
