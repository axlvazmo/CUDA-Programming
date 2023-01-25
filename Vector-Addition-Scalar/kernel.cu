/*
* Assignment 6
* Task: Multipy a large vector with a scalar and ad another large vector
* Axel Vazquez Montano
*/

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

#define N	500


__global__ void kernelOpps(int *aHost, int *bHost, int *cHost, int scalar, int n) {
	int i = threadIdx.x;
	if (i < n) {
		cHost[i] = (aHost[i] * scalar) + bHost[i];		//computing output
	}
}

int main() {
	
	const int scalar = 2;
	int aHost[N];	//defining values on host device
	int bHost[N];
	int cHost[N];

	/*Assigning initial values to vectors on host*/
	for (int i = 0; i < N; i++) {
		aHost[i] = i;	//values on the vectors will be the value of their index
		bHost[i] = i;
		cHost[i] = 0;
	}

	/*Declaring pointers to cuda Device*/
	int *aDev, *bDev, *cDev;

	/*Allocating memory on cuda device*/
	cudaMalloc(&aDev, N * sizeof(int));
	cudaMalloc(&bDev, N * sizeof(int));
	cudaMalloc(&cDev, N * sizeof(int));

	/*Copying data from host to cuda device*/
	cudaMemcpy(aDev, aHost, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(bDev, bHost, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(cDev, cHost, N * sizeof(int), cudaMemcpyHostToDevice);

	/*Launching Kernel*/
	kernelOpps <<<1, N>>> (aDev, bDev, cDev, scalar, N);

	cudaDeviceSynchronize();	//blocking any opperations until cuda device is done computing

	/*Copying data from cuda device to host*/
	cudaMemcpy(cHost, cDev, N * sizeof(int), cudaMemcpyDeviceToHost);

	/*Printing first 20 results*/
	for (int i = 0; i < 5; ++i) {
		printf("c[%d] = %i\n", i, cHost[i]);
	}

	/*Free cuda device memory*/
	cudaFree(aDev);
	cudaFree(bDev);
	cudaFree(cDev);

	return 0;
}