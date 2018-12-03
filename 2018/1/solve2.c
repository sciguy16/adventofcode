#include<stdlib.h>
#include<stdio.h>

/* input.c declares the const int array 'numbers' which has all of
 * the frequency shifts in it */
#include "input.c"

/* NUM_TRIES is the number of times we will loop over the input file
 * looking for repetitions */
#define NUM_TRIES 500

/* Debug mode has some extra prints */
// #define DEBUG

int indexOf(int* array, size_t size, int target) {
	int index = 0;
	while( (index < size) && (array[index] != target) )
		index++;
	return (index < size) ? index : -1;
}

int main(void) {
	size_t length = sizeof(numbers)/sizeof(numbers[0]);

	printf("Length of array is: %zu\n", length);
	printf("Fifth element is: %d\n", numbers[4]);

	printf("The size of an int is: %zu\n", sizeof(int));

	int total = 0;

	int (*outputs) = malloc(length * NUM_TRIES * sizeof(int));

	int index = 0;
	for( ; index < length * NUM_TRIES; index++) {
		total = total + numbers[ index % length ];
		if( indexOf(outputs, length, total) != -1 ) {
			/* Number we have seen before! */
			printf("We have seen this number already: %d\n",
					total);
			printf("This took us %d tries, and we hit it on the %zu"
					"th loop through the list\n",
					index, index % length);
			break;
		}
		outputs[index] = total;
#ifdef DEBUG
		printf("Running total: %d\n", total);
#endif
	}

	return 0;
}
