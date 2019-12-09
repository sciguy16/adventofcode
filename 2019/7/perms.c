// C program to print all permutations with duplicates allowed 
#include <stdio.h> 
#include <string.h> 

void swap(char*, char*);
void permute(char*, int, int);
void printperm(char*);

int main(void)
{
#ifdef FEEDBACK
	char str[] = "56789";
#else
	char str[] = "01234";
#endif
	int n = strlen(str);
	permute(str, 0, n-1);
	return 0;
}

/* Function to swap values at two pointers */
void swap(char *x, char *y) 
{ 
	char temp; 
	temp = *x; 
	*x = *y; 
	*y = temp; 
} 

/* Function to print permutations of string 
   This function takes three parameters: 
   1. String 
   2. Starting index of the string 
   3. Ending index of the string. */
void permute(char *a, int l, int r) 
{ 
	int i; 
	if (l == r) 
		printperm(a);
	else
	{ 
		for (i = l; i <= r; i++) 
		{ 
			swap((a+l), (a+i)); 
			permute(a, l+1, r); 
			swap((a+l), (a+i)); //backtrack 
		} 
	} 
} 

void printperm(char* perm)
{
	printf("{");
	for(int i = 0; i < 5; ++i) {
		printf("%c%s", perm[i], i == 4? "},\n" : ", ");
	}
}
