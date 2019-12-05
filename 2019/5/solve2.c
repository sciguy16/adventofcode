#include<stdio.h>
#include<stdlib.h>

#define OUT_HIGHLIGHT "\033[0;31m"
#define OUT_RESET "\033[0m"

int arr[] = {
#include "input.txt"
//#include "test.txt"
//#include "test2.txt"
//#include "test3.txt"
//#include "test4.txt"
};
size_t arr_len = sizeof(arr) / sizeof(int);

void print_arr(int);
int separate_instruction_mode(int, int*, size_t);
int num_params(int);
int resolve_params(int*, int*, int, int);

int main(void) {
	printf("Starting intcode interpreter...\n");
	printf("Loaded %d instructions\n", arr_len);

	for(int idx = 0; ;) {
		print_arr(arr_len > 10 ? 10 : arr_len);
		int opcode = arr[idx];
		printf("Next opcode: %d at index %d\n", opcode, idx);
		
		fprintf(stderr, "The relevant chunk is:\n");

		for(int i = idx; i < idx + 5; ++i) {
			fprintf(stderr, "\t[%d] %d\n", i, arr[i]);
		}

		int nparams = num_params(opcode);
		if(nparams < 0)
		{
			fprintf(stderr, "Invalid opcode\n");
			return -3;
		}
		fprintf(stderr, "Number of params is %d\n", nparams);

		int *mode = calloc(nparams, sizeof(int)); // made an array for the modes
		if(mode == 0)
		{
			fprintf(stderr, "Error allocating memory\n");
			return -4;
		}
		
		int instruction = separate_instruction_mode(opcode, mode, nparams);

		int* params = calloc(nparams, sizeof(int));
		if(resolve_params(params, mode, nparams, idx))
		{
			fprintf(stderr, "Error resolving params\n");
			return -5;
		}

		fprintf(stderr, "Parameters are:\n");
		for(int i = 0; i < nparams; ++i)
			fprintf(stderr, "\t%d mode: %d resolved: %d\n",
					idx + i + 1,
					mode[i],
					params[i]
					);
		fprintf(stderr, "Resolved instruction is: %d\n", instruction);

		switch(instruction) {
			case 1:
				printf("+");
				//fprintf(stderr, "  idx+1 = %d\n", idx + 1);
				//fprintf(stderr, "  arr[idx+1] = %d\n", arr[idx+1]);
				//fprintf(stderr, "  arr[arr[idx+1]] = %d\n", arr[arr[idx+1]]);
				arr[arr[idx+3]] = params[0] + params[1];
				break;
			case 2:
				printf("*");
				arr[arr[idx+3]] = params[0] * params[1];
				break;
			case 3:
				printf("s");
				printf("\nInput: ");
				int input;
				if(scanf("%d", &input) != 1)
				{
					fprintf(stderr, "Error reading input!\n");
					return -2;
				}
				// Parameter is arr[idx+1]; save input to that position
				fprintf(stderr, "Writing input to %d\n", arr[idx+1]);
				arr[arr[idx+1]] = input;
				break;
			case 4:
				printf("o");
				printf(OUT_HIGHLIGHT);
				printf("\nOutput: %d\n", params[0]);
				printf(OUT_RESET);
				break;
			case 5:
				// Jump if true
				printf("jnz\n");
				if(params[0] != 0) {
					idx = params[1];
					goto SKIP_INC;
				}
				break;
			case 6:
				// Jump if false
				printf("jz\n");
				if(params[0] == 0) {
					idx = params[1];
					goto SKIP_INC;
				}
				break;
			case 7:
				// Jump if less than
				printf("less\n");
				arr[arr[idx+3]] = (params[0] < params[1]) ? 1 : 0;
				break;
			case 8:
				// Jump if equal
				printf("eq\n");
				arr[arr[idx+3]] = (params[0] == params[1]) ? 1 : 0;
				break;
			case 99:
				printf("term\n");
				goto END_OF_LOOP;
			default:
				printf("There has been an error\n");
				return -1;
		}
		idx += 1 + nparams;
SKIP_INC:
		free(mode);
	}
END_OF_LOOP:

	//print_arr(arr_len);
	return 0;
}

int resolve_params(int* params, int* modes, int nparams, int idx)
{
	for(int i = 0; i < nparams; ++i)
	{
		if(modes[i] == 0)
		{
			// Position mode
			params[i] = arr[arr[idx + i + 1]];
		} else {
			// Immediate mode
			params[i] = arr[idx + i + 1];
		}
	}
	return 0;
}

int separate_instruction_mode(int opcode, int* modes_array, size_t len)
{
	int instruction = opcode % 100; // Take rightmost two digits
	int modes = opcode / 100; // Take all but rightmost two digits
	for(size_t i = 0; i < len; ++i)
	{
		modes_array[i] = modes % 10; // Get the rightmost digit
		modes /= 10; // Right-shift by one
	}
	return instruction;
}

int num_params(int opcode) {
	switch(opcode % 100)
	{
		case 1: return 3;
		case 2: return 3;
		case 3: return 1;
		case 4: return 1;
		case 5: return 2;
		case 6: return 2;
		case 7: return 3;
		case 8: return 3;
		case 99: return 0;
		default: return -1;
	}
}


void print_arr(int n) {
	// We made it a global, so might as well commit
	printf("Arr is:\n[");
	for(int i = 0; i < n; ++i)
		printf("%d, ", arr[i]);
	printf("...]\n");
}


