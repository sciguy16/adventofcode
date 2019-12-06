#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdbool.h>

#define SIZE 1000
#define LIGHTS bool lights[SIZE][SIZE]

enum MODES {
	ON,
	OFF,
	TOGGLE,
};

void initialise(LIGHTS);
void set(LIGHTS, int, int, int, int, enum MODES);

int main(void)
{
	LIGHTS;
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

		enum MODES m;
		if(strncmp("turn on", instruction, 7) == 0) {
			printf("on\n");
			m = ON;
		} else if(strncmp("turn off", instruction, 8) == 0) {
			printf("off\n");
			m = OFF;
		} else if(strncmp("toggle", instruction, 6) == 0) {
			printf("toggle\n");
			m = TOGGLE;
		} else {
			fprintf(stderr, "Invalid instruction\n");
			fclose(fp);
			return -2;
		}
		set(lights, minx, maxx, miny, maxy, m);
	}
	printf("End of file reached\n");

	int c = count(lights);
	printf("The number of lights left on is: %d\n", c);
	fclose(fp);
}

void set(LIGHTS, int minx, int maxx, int miny, int maxy, enum MODES mode)
{
	for(int x = minx; x <= maxx; ++x) {
		for(int y = miny; y <= maxy; ++y) {
			switch(mode)
			{
				case ON:
					lights[x][y] = true;
					break;
				case OFF:
					lights[x][y] = false;
					break;
				case TOGGLE:
					lights[x][y] ^= true;
					break;
				default:
					fprintf(stderr, "A Badnyss Has B'fallen Thys Lande");
			}
		}
	}
}

int count(LIGHTS)
{
	int c = 0;
	for(int x = 0; x < SIZE; ++x) {
		for(int y = 0; y < SIZE; ++y) {
			c += (int) lights[x][y];
		}
	}
	return c;
}

void initialise(LIGHTS)
{
	for(int i = 0; i < SIZE; ++i) {
		for(int j = 0; j < SIZE; ++j) {
			lights[i][j] = false;
		}
	}
}
