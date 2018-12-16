#include<string.h>
#include<stdlib.h>
#include<stdio.h>

#define TESTINFILE "testinput"
#define TESTOUTFILE "testinput.csv"

#define REALINFILE "input"
#define REALOUTFILE "input.csv"

//#define DEBUG

int main(int argc, char *argv[])
{
	FILE *infile, *outfile;
	char line[51];
	char source, dest;

	if( argc == 2 && strncmp(argv[1], "test", 4) == 0 )
	{
#ifdef DEBUG
		printf("got test on argv\n");
#endif
		infile = fopen(TESTINFILE, "r");
		outfile = fopen(TESTOUTFILE, "w");
	}
	else
	{
#ifdef DEBUG
		printf("didn't got no test :(\n");
#endif
		infile = fopen(REALINFILE, "r");
		outfile = fopen(REALOUTFILE, "w");
	}

	if( !infile || !outfile )
	{
		// something went wrong
		fprintf(stderr, "Error opening file :(\n");
		return -1;
	}

	while(fgets(line, 50, infile))
	{
#ifdef DEBUG
		printf("%s\n", line);
#endif
		source = '\x00';
		dest = '\x00';
		sscanf(line,
			"Step %c must be finished before step %c can begin.",
			&source, &dest);
#ifdef DEBUG
		printf("  source: %c, dest: %c\n", source, dest);
#endif
		fprintf(outfile, "%d, %d\n", source - 'A' + 1, dest - 'A' + 1);
	}

	fclose(infile);
	fclose(outfile);
	return 0;
}
