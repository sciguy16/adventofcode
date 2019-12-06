#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdbool.h>

#define SIZE 1000
void initialise(bool[SIZE][SIZE]);

int main(void)
{
	bool lights[SIZE][SIZE];
	initialise(lights);

	printf("Yay\n");
	printf("Lights[5][2] is %s\n", lights[5][2] ? "true" : "false");

	char instruction[50];
	int x1, x2, y1, y2;

	FILE* fp = fopen("input.txt", "r");
	if(fp == NULL) {
		fprintf(stderr, "Error opening file!\n");
		return -1;
	}

	char fmt[] = "%[^0-9] %d,%d through %d,%d\n";
	while(fscanf(fp, fmt, &instruction, &x1, &y1, &x2, &y2) == 5)
	{
		printf("%s - %d,%d - %d,%d\n", instruction, x1, y1, x2, y2);
		int minx = x1 < x2 ? x1 : x2;
		int maxx = x1 < x2 ? x2 : x1;
		int miny = y1 < y2 ? y1 : y2;
		int maxy = y1 < y2 ? y2 : y1;

		if(strncmp("turn on", instruction, 7) == 0) {
			printf("on\n");
		} else if(strncmp("turn off", instruction, 8) == 0) {
			printf("off\n");
		} else if(strncmp("toggle", instruction, 6) == 0) {
			printf("toggle\n");
		} else {
			fprintf(stderr, "Invalid instruction\n");
			fclose(fp);
			return -2;
		}
	}
	printf("End of file reached\n");
	fclose(fp);
}

void initialise(bool lights[SIZE][SIZE])
{
	for(int i = 0; i < SIZE; ++i) {
		for(int j = 0; j < SIZE; ++j) {
			lights[i][j] = false;
		}
	}
}
