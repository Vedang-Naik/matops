#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "matops.h"

int main() {
	int rows = 5;
	int cols = 5;
	srand((unsigned int)time(NULL));

	Matrix A;
	A.rows = rows;
	A.cols = cols;
	A.elements = (float* )malloc(A.rows * A.cols * sizeof(float));
	for (int i = 0; i < A.rows; i++ ) {
		for (int j = 0; j < A.cols; j++) {
			*(A.elements + i*A.cols + j) = ((float)rand()/(float)(RAND_MAX)) * 10;
		}
	}
	printMatrix(A);

	int i; int j;
	scanf("%d", &i);
	scanf("%d", &j);
	printf("%.2f", getElm(A, i, j));
	return 0;
}