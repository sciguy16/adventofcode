#include<stdlib.h>
#include<stdio.h>
#include "linkedlist.c"

#define INFO
//#define DEBUG
//#define MEGADEBUG


struct marble* playMarbleGame(struct marble* startingMarble, int numPlayers, int maxMarble)
{
		// next marble value is always current->value + 1
		// if next marble value is NOT a multiple of 23 then:
		//  - move to next marble
		//  - addAfter
		// otherwise:
		//  - score the marble that would have been placed
		//  - move to 7 prev
		//  - delete current
		//  - move next
		struct marble* current = startingMarble;
		int nextMarbleNumber = 1;
		int i;
		long int scores[numPlayers];
		int winningPlayer;
		long int winningScore;
		
		// initialise the player scores
		for( i = 0; i < numPlayers; i++ )
		{
				scores[i] = 0;
		}

		for( ; nextMarbleNumber < maxMarble ; nextMarbleNumber++ )
		{
#ifdef DEBUG
				printf(" [+] Starting round %d...\n", nextMarbleNumber);
#endif
				if( nextMarbleNumber % 23 != 0 )
				{
						// Marble is not a multiple of 23, so insert it
						current = current->next;
						current = addAfter(current, nextMarbleNumber);
				}
				else
				{
						// Marble is a multiple of 23, so score it, move back
						// and delete
#ifdef DEBUG
						printf("Scoring marble %d\n", nextMarbleNumber);
#endif
						scores[ nextMarbleNumber % numPlayers ] += nextMarbleNumber;

						// move to 7 previous
						for(i = 0; i < 7; i++)
						{
								current = current->prev;
						}
						// add the marble to current player's score and then delete it
						scores[ nextMarbleNumber % numPlayers ] += current->value;
						current = deleteCurrent(current);
						// move one step forward
						current = current->next;
				}

#ifdef MEGADEBUG
				printList(current);
#endif
		}

		// let's print out the scores and also work out who won
		winningScore = 0;
		winningPlayer = -1;
		for( i = 0; i < numPlayers; i++ )
		{
				if( scores[i] > winningScore )
				{
						winningScore = scores[i];
						winningPlayer = i;
				}
#ifdef DEBUG
			printf("Player %d scored %d!\n", i, scores[i]);
#endif
		}
		// check that we actually found something
		if( winningPlayer == -1 )
		{
				// something very bad has happened
				printf("Something very bad has happened :(\n");
				printf("score zero is: %ld\n", scores[0]);
		}
		else
		{
				printf("***DRUM ROLL***\n");
				printf("The winner is player %d with score %ld!!\n", winningPlayer, winningScore);
		}

		return current;
}


int main(int argc, char* argv[])
{
		int numPlayers, numMarbles;
		int challengeNum;

		const int numChallenges = 7;
		const int challenges[][3] = {
				// Players, marbles, winner (if known)
				{ 10, 1618, 8317 },
				{ 13, 7999, 146373 },
				{ 17, 1104, 2764 },
				{ 21, 6111, 54718 },
				{ 30, 5807, 37305 },
				{ 463, 71787, 0 },
				{ 463, 7178700, 0}
		};

		for( challengeNum = 0; challengeNum < numChallenges; challengeNum++ )
		{
			numPlayers = challenges[challengeNum][0];
			numMarbles = challenges[challengeNum][1];
#ifdef INFO
			printf(" [+] Starting marble game with %d players and %d marbles...\n",
						numPlayers, numMarbles);
			if( challenges[challengeNum][2] != 0 )
					printf(" [+] Winner should have a score of %d\n",
								   	challenges[challengeNum][2]);
#endif

			struct marble* current = malloc(sizeof(struct marble));
			if( current == NULL ) exit(1);
			current->value = 0;
			current->position = 0;
			current->next = current;
			current->prev = current;
			//printf("Current marble value is: %d\n", current->value);
			//printList(current);

			current = playMarbleGame(current, numPlayers, numMarbles);
#ifdef MEGADEBUG
			printList(current);
#endif

			deleteAllMarbles(current);
		}
		return 0;
}
