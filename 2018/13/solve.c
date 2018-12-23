#include<stdio.h>
#include<stdlib.h>
#include<string.h>

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

	return 0;
}
