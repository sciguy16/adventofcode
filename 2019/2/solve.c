#include<stdio.h>
#include<stdlib.h>

int arr[] = {
#include "input.txt"
};
size_t arr_len = sizeof(arr) / sizeof(int);

void print_arr(void);

int main(void) {
	printf("Starting intcode interpreter...\n");
	printf("Loaded %d instructions\n", arr_len);

	printf("Patching the program...\n");
	arr[1] = 12;
	arr[2] = 2;

	for(int idx = 0; ; idx += 4) {
		print_arr();
		printf("Next opcode: %d\n", arr[idx]);
		switch(arr[idx]) {
			case 1:
				printf("+");
				arr[arr[idx+3]] = arr[arr[idx+1]] + arr[arr[idx+2]];
				break;
			case 2:
				printf("*");
				arr[arr[idx+3]] = arr[arr[idx+1]] * arr[arr[idx+2]];;
				break;
			case 99:
				printf("term");
				printf("\nFinal value: %d\n", arr[arr_len]);
				goto END_OF_LOOP;
			default:
				printf("There has been an error\n");
				return -1;
		}
	}
END_OF_LOOP:

	print_arr();
	return 0;
}


void print_arr() {
	// We made it a global, so might as well commit
	printf("Arr is:\n[");
	for(int i = 0; i < arr_len; ++i)
		printf("%d, ", arr[i]);
	printf("]\n");
}


