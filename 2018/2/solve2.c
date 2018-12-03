#include<stdlib.h>
#include<stdio.h>
#include<string.h>

/* input.c contains a const char boxIDs[], which is an array of (you guessed
 * it...) box IDs */
#include "input.c"

/* DEBUG adds some extra prints */
#define DEBUG

int hamming(char* a, char* b) {
	size_t length = strlen(a);
	/* abort if the two strings are different lengths */
	if( length != strlen(b) )
		return -1;

	/* Compare the strings character by character */
	int dist = 0;
	for ( int index = 0; index < length; index++ ) {
		if( a[index] != b[index] )
			dist++;
	}
	return dist;
}

void printMatchingChars(char* a, char* b) {
	size_t length = strlen(a);
	if( length != strlen(b) )
		return;

	printf("Solution: ");
	for( int index = 0; index < length; index++ ) {
		if( a[index] == b[index] )
			printf("%c", a[index]);
	}
	printf("\n");
}

int main() {
#ifdef DEBUG
	printf("hello\n");
	printf("Test hamming with diff len: %d\n", hamming("abc", "cd"));
	printf("Test hamming(\"game\", \"gbme\"): %d\n", hamming("game", "gbme"));
#endif

	size_t length = sizeof(boxIDs) / sizeof(boxIDs[0]);
	printf("Length is %zu\n", length);

	/* Calculate all pairs of hamming distances, looking for a hamming of
	 * exactly one */
	int first = 0;
	int second = 0;
	for( first = 0; first < length; first++ ) {
		for( second = 0; second < length; second++ ) {
			int ham = hamming(boxIDs[first], boxIDs[second]);
			if( ham == -1 )
				printf("sad :(\n");
			else if( ham == 1 ) {
				/* We have found what we are looking for */
				goto OUTOFLOOP;
			}
		}
	}
	printf("None found :(\n");
	return -1;
OUTOFLOOP:
	printf("We have found a pair with hamming 1!!\n%d: %s\n%d: %s\n",
		first, boxIDs[first],
		second, boxIDs[second]);

	printMatchingChars(boxIDs[first], boxIDs[second]);

	return 0;
}
