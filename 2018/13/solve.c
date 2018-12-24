#include<stdio.h>
#include<stdlib.h>
#include<string.h>

//#define TEST
//#define DEBUG
//#define TEST2

#ifdef TEST2
#define INFILE "testinput2"
#else
#ifdef TEST
#define INFILE "testinput"
#else
#define INFILE "input"
#endif
#endif

#define MAXCARTS 20

enum directions { UP, DOWN, LEFT, RIGHT };
enum juncDirections { LEFTj, STRAIGHTj, RIGHTj };

struct coord {
	int x;
	int y;
};

struct mineCart {
	struct coord position;
	enum directions direction;
	enum juncDirections junction;
	int destroyed;
};

struct coord load_map(char* map, size_t mapLen);

void print_map(char* map, struct coord mapSize,
		struct mineCart* carts, size_t maxCarts);

size_t new_cart( struct mineCart* carts, size_t numCarts, size_t maxCarts,
		enum directions direction, int x, int y);

size_t strip_carts(char* map, struct coord mapSize, size_t mapLen,
		struct mineCart* carts, size_t maxCarts);

size_t step( char* map, struct coord mapSize, struct mineCart* carts,
		size_t numCarts );

void sort_carts( struct mineCart* carts, size_t numCarts,
		struct coord mapSize, int* cartOrder );

size_t delete_carts( struct mineCart* carts, size_t numCarts,
		int x, int y );

int main(void)
{
	/* Strategy:
	 * - read map into a 2d array
	 * - read mine carts out of the array into an array of structs
	 *   (each struct has a position, a direction, and a junction choice
	 * - clear the mine carts out of the map
	 * - write a sorting function to produce a sorted array of pointers to
	 *   mine cart structs based on reading them top to bottom, left to
	 *   right
	 * - step through the simulation
	 * - cart += position in its direction
	 *   > if another bit of track in the same direction then yay
	 *   > if a curve then resolve its effects (rotate but stay on the curve)
	 *   > if a junction then resolve its effects (rotate in place)
	 * - if cart intersects another cart then abort as that's the game end
	 *   condition
	 */

	struct coord mapSize;

	// load in the map
	size_t mapLen = 22501;
	char* map = malloc(mapLen * sizeof(char));
	mapSize = load_map(map, mapLen);
	if( mapSize.x <= 0 )
	{
		// something bad happened, let's run away
		fprintf(stderr, "Something bad happened when trying to load the map :("
				"\nwidth: %d, height: %d\n", mapSize.x, mapSize.y);
		exit(1);
	}


	// load in the carts
	size_t numCarts = 0;
	const size_t maxCarts = MAXCARTS;
	struct mineCart carts[maxCarts];
	numCarts = strip_carts(map, mapSize, mapLen, carts, maxCarts);
#ifdef DEBUG
	printf(" [+] Loaded %ld carts\n", numCarts);
#endif

	if( numCarts == 0 )
	{
		free(map);
		fprintf(stderr, "Error loading carts\n");
		exit(3);
	}

	// print the map
#ifdef DEBUG
	print_map(map, mapSize, carts, numCarts);
#endif


	printf(" [+] starting simulation\n");

	while( numCarts > 1 )
	{
		numCarts = step( map, mapSize, carts, numCarts );
#ifdef DEBUG
		print_map( map, mapSize, carts, numCarts );
#endif
	}


	free(map);


	return 0;
}


size_t new_cart( struct mineCart* carts, size_t numCarts, size_t maxCarts,
		enum directions direction, int x, int y)
{
	// adds a new cart, returning the new number of carts

	if( numCarts == maxCarts )
	{
		fprintf(stderr, "Too many carts\n");
		return 0;
	}
	carts[numCarts].position.x = x;
	carts[numCarts].position.y = y;
	carts[numCarts].direction = direction;
	carts[numCarts].junction = LEFTj;
	carts[numCarts].destroyed = 0;

	return numCarts + 1;
}


size_t strip_carts(char* map, struct coord mapSize, size_t mapLength,
		struct mineCart* carts, size_t maxCarts)
{
	// returns the number of carts extracted
	size_t numCarts = 0;

#ifdef DEBUG
	printf(" [+] stripping the carts\n");
#endif
	int i, j;
	int added;

	// walk over the map, pulling out carts
	for( i = 0; i < mapSize.x; i++ )
	{
		for( j = 0; j < mapSize.y; j++ )
		{
			added = 0;
			switch( map[i + mapSize.x * j] )
			{
				case '<':
					// left cart
					numCarts = new_cart(carts, numCarts, maxCarts, LEFT,
							i, j);
					map[ i + j * mapSize.x ] = '-';
					added = 1;
					break;
				case '>':
					// right cart
					numCarts = new_cart(carts, numCarts, maxCarts, RIGHT,
							i, j);
					map[ i + j * mapSize.x ] = '-';
					added = 1;
					break;
				case '^':
					// up cart
					numCarts = new_cart(carts, numCarts, maxCarts, UP,
							i, j);
					map[ i + j * mapSize.x ] = '|';
					added = 1;
					break;
				case 'v':
					// down cart
					numCarts = new_cart(carts, numCarts, maxCarts, DOWN,
							i, j);
					map[ i + j * mapSize.x ] = '|';
					added = 1;
					break;
				default:
					break;
			}

			if( added == 1 && numCarts == 0 )
			{
				fprintf(stderr, "invalid carts\n");
				return 0;
			}

			if(added == 1 && numCarts - 1 >= 0)
			{
				// a new cart got added
				// gotta replace the map square with a piece of track
#ifdef DEBUG
				printf("Added a %d cart!\n", carts[numCarts-1].direction);
#endif
			}
		}
	}

	return numCarts;
}

struct coord load_map(char* map, size_t mapLength)
{
	// loads the map and returns its dimensions
	struct coord mapSize;
	FILE* f = fopen( INFILE, "r" );
	const size_t bufLen = 200;
	char buffer[bufLen];

	char* newMap;
	size_t newLength;

	int height = 0;
	int width = 0;

	// initialise map
	map[0] = '\0';

	while( fgets( buffer, bufLen, f ) )
	{
		// strip the newline
		buffer[strcspn(buffer, "\n")] = 0;
		width = strlen(buffer);
		height++;

		if( width * height + 1 > mapLength ) 
		{
			// out of space in map
			newLength = width * height + 1;
			newMap = realloc( map, newLength*sizeof(char) );
			if (newMap == NULL)
			{
				free(map);
				fprintf(stderr, "Error reallocating map\n");
				exit(2);
			}
			map = newMap;
			mapLength = newLength;
#ifdef DEBUG
			printf("Resizing map...\n");
#endif
		}

		strncat( map, buffer, width );

#ifdef DEBUG
		printf("buffer (%ld): %s\n", strlen(buffer), buffer);
#endif
	}

	fclose(f);
	mapSize.x = width;
	mapSize.y = height;
	return mapSize;
}


void print_map( char* map, struct coord mapSize,
		struct mineCart* carts, size_t numCarts )
{
	printf(" [+] printing the map...\n");
	printf(" [+] map size is %d, %d\n", mapSize.x, mapSize.y );

	int i, j;
	int cart;
	for( i = 0; i < mapSize.y; i++ )
	{
		for( j = 0; j < mapSize.x; j++ )
		{
			for( cart = 0; cart < numCarts; cart++ )
			{
				// stuff
				if( carts[cart].position.x == j &&
						carts[cart].position.y == i &&
						carts[cart].destroyed == 0 )
				{
					switch( carts[cart].direction )
					{
						case UP:
							printf("^");
							break;
						case DOWN:
							printf("v");
							break;
						case LEFT:
							printf("<");
							break;
						case RIGHT:
							printf(">");
							break;
					}
					goto OUTOFCARTLOOP;
				}
			}
			printf("%c", map[ j + mapSize.x * i ] );
OUTOFCARTLOOP:
			cart = 0;
		}
		printf("\n");
	}
}


size_t step( char* map, struct coord mapSize, struct mineCart* carts,
		size_t numCarts )
{
	// run a step
	// returns the number of carts remaining
	//
	// * generate a sorting for the carts based on a left-to-right,
	//   top-to-bottom order
	// * resolve the movements and collisions

	int cartOrder[numCarts];
	int currentCart;

	struct coord newPosition;

	int i, j;
#ifdef DEBUG
	for( i = 0; i < numCarts; i++ )
	{
		printf("(%d, %d)\n", carts[i].position.x, carts[i].position.y);
	}

	printf(" [+] sorting carts\n");
#endif
	sort_carts( carts, numCarts, mapSize, cartOrder );
#ifdef DEBUG
	for( i = 0; i < numCarts; i++ )
	{
		printf("%2d: %d\n", i, cartOrder[i]);
	}
#endif

	for( i = 0; i < numCarts; i++ )
	{
		// resolve the movements
		currentCart = cartOrder[i];

		newPosition = carts[currentCart].position;
		switch( carts[currentCart].direction )
		{
			case UP:
				newPosition.y--;
				break;
			case DOWN:
				newPosition.y++;
				break;
			case LEFT:
				newPosition.x--;
				break;
			case RIGHT:
				newPosition.x++;
				break;
		}

		// check collisions
		for( j = 0; j < numCarts; j++ )
		{
			if( j != currentCart &&
					newPosition.x == carts[j].position.x &&
					newPosition.y == carts[j].position.y &&
					carts[currentCart].destroyed == 0 &&
					carts[j].destroyed == 0 )
			{
				// there is a collision
				printf(" [+] collision detected at (%d, %d)\n",
						newPosition.x, newPosition.y);

				// instead of returning, we delete the two crashed carts and
				// continue as if nothing had happened
				//return 1;
				// update the cart entry now so that it gets deleted properly
				carts[ currentCart ].position.x = newPosition.x;
				carts[ currentCart ].position.y = newPosition.y;
				numCarts = delete_carts(carts, numCarts,
						newPosition.x, newPosition.y);
#ifdef DEBUG
				print_map(map, mapSize, carts, numCarts);
#endif
				// count the non-deleted carts
				int activeCarts = 0;
				int k;
				for( k = 0; k < numCarts; k++ )
				{
					if( carts[k].destroyed == 0 )
					{
						activeCarts++;
					}
				}
#ifdef DEBUG
				printf(" [+] There are %d carts remaining.\n", activeCarts);
#endif
				// return if we are all out of carts
				if( activeCarts == 1 )
				{
					// find the active cart and then print it
					for( k = 0; k < numCarts; k++ )
					{
						if( carts[k].destroyed == 0 )
						{
							printf(" [+] Only one cart remaining!!\nCart is at "
									"position (%d, %d) facing in direction %d with "
									"junction choice %d\n",
									carts[k].position.x, carts[k].position.y,
									//newPosition.x, newPosition.y,
									carts[j].direction, carts[j].junction );

							// may need to shift the cart one more tick
							// (this is all a horrendous bodge, I'm sorry)
							switch( carts[k].direction )
							{
								case UP:
									carts[k].position.y--;
									break;
								case DOWN:
									carts[k].position.y++;
									break;
								case LEFT:
									carts[k].position.x--;
									break;
								case RIGHT:
									carts[k].position.x++;
									break;
							}

							printf( " [+] After moving it a bit it is at "
								"position (%d, %d)\n",
								carts[k].position.x,
								carts[k].position.y );
						}
					}
					return 1;
				}

				// having deleted the cart, let's jump to the end of the loop
				goto AFTERSWITCH;
			}
		}
#ifdef DEBUG
		printf(" [+] no collision, position is (%d, %d)\n",
				newPosition.x, newPosition.y);
#endif

		// check whether cart needs to rotate
		switch( map[ newPosition.x + mapSize.x * newPosition.y ] )
		{
			case '/':
				switch( carts[ currentCart ].direction )
				{
					case UP:
						carts[ currentCart ].direction = RIGHT;
						break;
					case DOWN:
						carts[ currentCart ].direction = LEFT;
						break;
					case LEFT:
						carts[ currentCart ].direction = DOWN;
						break;
					case RIGHT:
						carts[ currentCart ].direction = UP;
						break;
				}
				break;

			case '\\':
				switch( carts[ currentCart ].direction )
				{
					case UP:
						carts[ currentCart ].direction = LEFT;
						break;
					case DOWN:
						carts[ currentCart ].direction = RIGHT;
						break;
					case LEFT:
						carts[ currentCart ].direction = UP;
						break;
					case RIGHT:
						carts[ currentCart ].direction = DOWN;
						break;
				}
				break;

			case '+':
				// left, straight, right, loop
				switch( carts[ currentCart ].direction )
				{
					case UP:
						switch( carts[ currentCart ].junction )
						{
							case STRAIGHTj:
								carts[ currentCart ].direction = UP;
								carts[ currentCart ].junction = RIGHTj;
								break;
							case LEFTj:
								carts[ currentCart ].direction = LEFT;
								carts[ currentCart ].junction = STRAIGHTj;
								break;
							case RIGHTj:
								carts[ currentCart ].direction = RIGHT;
								carts[ currentCart ].junction = LEFTj;
								break;
						}
						break;

					case DOWN:
						switch( carts[ currentCart ].junction )
						{
							case STRAIGHTj:
								carts[ currentCart ].direction = DOWN;
								carts[ currentCart ].junction = RIGHTj;
								break;
							case LEFTj:
								carts[ currentCart ].direction = RIGHT;
								carts[ currentCart ].junction = STRAIGHTj;
								break;
							case RIGHTj:
								carts[ currentCart ].direction = LEFT;
								carts[ currentCart ].junction = LEFTj;
								break;
						}
						break;

					case LEFT:
						switch( carts[ currentCart ].junction )
						{
							case STRAIGHTj:
								carts[ currentCart ].direction = LEFT;
								carts[ currentCart ].junction = RIGHTj;
								break;
							case LEFTj:
								carts[ currentCart ].direction = DOWN;
								carts[ currentCart ].junction = STRAIGHTj;
								break;
							case RIGHTj:
								carts[ currentCart ].direction = UP;
								carts[ currentCart ].junction = LEFTj;
								break;
						}
						break;

					case RIGHT:
						switch( carts[ currentCart ].junction )
						{
							case STRAIGHTj:
								carts[ currentCart ].direction = RIGHT;
								carts[ currentCart ].junction = RIGHTj;
								break;
							case LEFTj:
								carts[ currentCart ].direction = UP;
								carts[ currentCart ].junction = STRAIGHTj;
								break;
							case RIGHTj:
								carts[ currentCart ].direction = DOWN;
								carts[ currentCart ].junction = LEFTj;
								break;
						}
						break;
				}
				break;
		}

AFTERSWITCH:
		// update the position in the table
		if( carts[currentCart].destroyed == 0 )
		{
			carts[ currentCart ].position.x = newPosition.x;
			carts[ currentCart ].position.y = newPosition.y;
		}
	}
	return numCarts;
}


void sort_carts( struct mineCart* carts, size_t numCarts,
		struct coord  mapSize, int* cartOrder )
{
	// sorts the carts
	int i;
	int x, y;
	int order = 0;
	for( y = 0; y < mapSize.y; y++ )
	{
		for( x = 0; x < mapSize.x; x++ )
		{
			for( i = 0; i < numCarts; i++ )
			{
				if( x == carts[i].position.x &&
						y == carts[i].position.y )
				{
					cartOrder[order] = i;
					order++;
				}
			}
		}
	}
}


size_t delete_carts( struct mineCart* carts, size_t numCarts,
		int x, int y )
{
	// delete the carts at the position (x, y)
	// returns the number of remaining carts

#ifdef DEBUG
	printf(" [+] deleteing carts at (%d, %d)\n",
			x, y);
#endif
	int i;
	//int cart;
	//struct mineCart cartsCopy[ numCarts ];
	/*for( i = 0; i < numCarts; i++ )
	  {
	  printf("copying %d\n", i);
	  cartsCopy[i] = carts[i];
	  }*/

	//cart = 0;
	// only copy non-these carts over
	for( i = 0; i < numCarts; i++ )
	{
		if( carts[i].position.x == x &&
				carts[i].position.y == y )
		{
			/* don't copy */
			//printf("not copying %d\n", i);
			// "delete" it
			carts[i].destroyed = 1;
		}
		/*else
		  {
		  printf("copying (%d, %d)\n",
		  cartsCopy[i].position.x,
		  cartsCopy[i].position.y);
		  carts[cart] = cartsCopy[i];
		  cart++;
		  }*/
	}
	//printf("%ld carts remaining\n", numCarts - 2);
	return numCarts;// - 2;
}



