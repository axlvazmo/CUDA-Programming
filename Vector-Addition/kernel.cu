/*
* Assignment 4
* Vector addition using cuda device
* Axel Vazquez Montano
*/

#include <stdio.h>
#define N	1024

__global__ void vectorAddi(int *a, int *b, int *c, int n){
	int i = threadIdx.x; //identifying each thread
	if(i < n){	//making sure that we don't go over the needed threads
		c[i] = a[i] + b[i];
	}
}

int main(){
	int *a, *b, *c;		//initializing vectors
	cudaMallocManaged(&a, N * sizeof(int));	//allocationg memory in cuda device
	cudaMallocManaged(&b, N * sizeof(int));
	cudaMallocManaged(&c, N * sizeof(int));

	for (int i = 0; i < N; ++i) {	//assigning values to vectors
		a[i] = i;	//vector calue will be the same as index value
		b[i] = i;
		c[i] = 0;
	}

	vectorAddi <<<1, N>>> (a, b, c, N);		//specifying launch config for kernel <<<1 thread block, number of threads>>> **Note that the number of threads must equal number of elements in the vector to avoid delay in computation

	cudaDeviceSynchronize();	//blocking any opperations until cuda device is done computing

	for (int i = 0; i < 20; ++i) {
		printf("c[%d] = %d\n", i, c[i]);
	}

	cudaFree(a); // free memory space of the vectors
	cudaFree(b);
	cudaFree(c);

	return 0;
}