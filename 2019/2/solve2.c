#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int* arr_ptr;

int arr_orig[] = {
#include "input.txt"
};
size_t arr_len = sizeof(arr_orig) / sizeof(int);

void print_arr(void);

int main(void) {
	printf("Starting intcode interpreter...\n");
	printf("Loaded %d instructions\n", arr_len);

	for(int n = 0; n <= 99; ++n) {
		for(int v = 0; v <= 99; ++v) {
			int *arr = malloc(arr_len * sizeof(int));
			memcpy(arr, arr_orig, arr_len * sizeof(int));
			arr_ptr = arr;
			arr[1] = n;
			arr[2] = v;

			for(int idx = 0; ; idx += 4) {
				//print_arr();
				//printf("Next opcode: %d\n", arr[idx]);
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
						printf("\nFinal value: %d\n", arr[0]);
						goto END_OF_LOOP;
					default:
						printf("There has been an error\n");
						return -1;
				}
			}
END_OF_LOOP:
			if(arr[0] == 19690720) {
				printf("Got it!\n");
				printf("n = %d, v = %d, ans = %d\n", n, v, 100*n + v);
				return 0;
			}
			free(arr);
		}
	}

	printf("Did not find solution :(\n");

	print_arr();
	return 0;
}


void print_arr() {
	// We made it a global, so might as well commit
	printf("Arr is:\n[");
	for(int i = 0; i < arr_len; ++i)
		printf("%d, ", arr_ptr[i]);
	printf("]\n");
}


