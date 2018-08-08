typedef struct {
	int rows;
	int cols;
	float* elements;
} Matrix;

void printMatrix(Matrix A);
Matrix initMatrix(int rows, int cols, float* elements);
Matrix pAddMatrix(Matrix A, Matrix B);
Matrix pSubMatrix(Matrix A, Matrix B);
float* getRow(Matrix A, int i);
float* getCol(Matrix A, int j);
float getElm(Matrix A, int i, int j);