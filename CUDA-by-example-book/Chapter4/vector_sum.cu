#include "../commom/book.h"

#define N 10

__global__
void add( int *a, int *b, int *c)
{
	int tid = blockIdx.x;
	if(tid < 10) {
		c[tid] = a[tid] + b[tid];
	}
}

int main(void)
{
	int a[N], b[N], c[N];
	int *dev_a, *dev_b, *dev_c;

	//allocate the memory on the GPU

	HANDLE_ERROR ( cudaMalloc ( (void**) &dev_a, N * sizeof(int) ) );
	HANDLE_ERROR ( cudaMalloc ( (void**) &dev_b, N * sizeof(int) ) );
	HANDLE_ERROR ( cudaMalloc ( (void**) &dev_c, N * sizeof(int) ) );

	for (int i=0; i <N; i++) {
		a[i] = -i;
		b[i] = i * i;
	}


	// copy the arrays a and b to the GPU
	HANDLE_ERROR ( cudaMemcpy ( dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice)) ;
	HANDLE_ERROR ( cudaMemcpy ( dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice) );

	add<<<N,1>>>(dev_a,dev_b,dev_c);

	HANDLE_ERROR ( cudaMemcpy ( c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost ) );

	for (int i =0; i < N; i++ ) {
		printf("%d + %d = %d \n",a[i],b[i],c[i]);
	}

	// free the memory allocated on the GPU
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	return 0;
}
