#include <stdio.h>
extern "C" {
#include "matops.h"
}

void printMatrix(Matrix A) {
	for (int i = 0; i < A.rows; i++) {
		for (int j = 0; j < A.cols; j++) {
			printf("%.2f ", *(A.elements + i*A.cols + j));
		}
		printf("\n");
	}
	printf("\n");
}

Matrix initMatrix(int rows, int cols, float* elements) {
	if (rows <= 0 || cols <= 0) {
		printf("Please use positive values for rows and columns.\n");
		exit(0);
	}

	Matrix temp;
	temp.rows = rows;
	temp.cols = cols;
	temp.elements = (float *)malloc(rows * cols * sizeof(float));
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			*(temp.elements + i*cols + j) = *(elements + i*cols + j);
		}
	}

	return temp;
}

//================================================================================//

__global__ void pam(Matrix A_d, Matrix B_d, Matrix C_d) {
	int i = threadIdx.x;
	int j = threadIdx.y;
	*(C_d.elements + i*C_d.cols + j) = *(A_d.elements + i*A_d.cols + j) + *(B_d.elements + i*B_d.cols + j);
}

Matrix pAddMatrix(Matrix A, Matrix B) {
	if (A.rows != B.rows || A.cols != B.cols) {
		printf("Your input matrices do not have equal dimensions.\n");
		exit(0);
	}

	int numRows = A.rows;
	int numCols = A.cols;
	int sizeOfMatrix = numRows * numCols * sizeof(float);

	Matrix A_d;
	A_d.rows = numRows;
	A_d.cols = numCols;
	cudaMalloc(&A_d.elements, sizeOfMatrix);
	cudaMemcpy(A_d.elements, A.elements, sizeOfMatrix, cudaMemcpyHostToDevice);

	Matrix B_d;
	B_d.rows = numRows;
	B_d.cols = numCols;
	cudaMalloc(&B_d.elements, sizeOfMatrix);
	cudaMemcpy(B_d.elements, B.elements, sizeOfMatrix, cudaMemcpyHostToDevice);

	Matrix C_d;
	C_d.rows = numRows;
	C_d.cols = numCols;
	cudaMalloc(&C_d.elements, sizeOfMatrix);
	pam<<<1, dim3(numRows, numCols)>>>(A_d, B_d, C_d);

	Matrix C;
	C.rows = numRows;
	C.cols = numCols;
	C.elements = (float *)malloc(sizeOfMatrix);
	cudaMemcpy(C.elements, C_d.elements, sizeOfMatrix, cudaMemcpyDeviceToHost);

	cudaFree(A_d.elements);
	cudaFree(B_d.elements);
	cudaFree(C_d.elements);

	return C;
}

//================================================================================//

__global__ void psm(Matrix A_d, Matrix B_d, Matrix C_d) {
	int i = threadIdx.x;
	int j = threadIdx.y;
	*(C_d.elements + i*C_d.cols + j) = *(A_d.elements + i*A_d.cols + j) - *(B_d.elements + i*B_d.cols + j);
}

Matrix pSubMatrix(Matrix A, Matrix B) {
	if (A.rows != B.rows || A.cols != B.cols) {
		printf("Your input matrices do not have equal dimensions.\n");
		exit(0);
	}

	int numRows = A.rows;
	int numCols = A.cols;
	int sizeOfMatrix = numRows * numCols * sizeof(float);

	Matrix A_d;
	A_d.rows = numRows;
	A_d.cols = numCols;
	cudaMalloc(&A_d.elements, sizeOfMatrix);
	cudaMemcpy(A_d.elements, A.elements, sizeOfMatrix, cudaMemcpyHostToDevice);

	Matrix B_d;
	B_d.rows = numRows;
	B_d.cols = numCols;
	cudaMalloc(&B_d.elements, sizeOfMatrix);
	cudaMemcpy(B_d.elements, B.elements, sizeOfMatrix, cudaMemcpyHostToDevice);

	Matrix C_d;
	C_d.rows = numRows;
	C_d.cols = numCols;
	cudaMalloc(&C_d.elements, sizeOfMatrix);
	pam<<<1, dim3(numRows, numCols)>>>(A_d, B_d, C_d);

	Matrix C;
	C.rows = numRows;
	C.cols = numCols;
	C.elements = (float *)malloc(sizeOfMatrix);
	cudaMemcpy(C.elements, C_d.elements, sizeOfMatrix, cudaMemcpyDeviceToHost);

	cudaFree(A_d.elements);
	cudaFree(B_d.elements);
	cudaFree(C_d.elements);

	return C;
}

//================================================================================//

float* getRow(Matrix A, int i) {
	if (i > A.rows || i < 1) {
		printf("Your row number is out of bounds.\n");
		exit(0);
	}

	float* reqRowPtr = &*(A.elements + (i-1)*A.cols);
	return reqRowPtr;
}

float* getCol(Matrix A, int j) {
	if (j > A.cols || j < 1) {
		printf("Your column number is out of bounds.\n");
		exit(0);
	}

	float* reqColPtr = (float* )malloc(A.cols * sizeof(float));
	for (int i = 0; i < A.rows; i++) {
		*(reqColPtr + i) = *(A.elements + i*A.cols + (j-1));
	}
	return reqColPtr;
}

float getElm(Matrix A, int i, int j) {
	if (i > A.rows || i < 1 || j > A.cols || j < 1) {
		printf("Your row or column number is out of bounds.\n");
		exit(0);
	}

	return *(A.elements + (i-1)*A.cols + (j-1));
}