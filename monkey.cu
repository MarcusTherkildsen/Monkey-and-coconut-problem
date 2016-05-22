#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

/*
nvcc -O3 -arch=sm_30 -o cuda_monkey monkey.cu
*/

unsigned int print2Smallest(unsigned int *arr, unsigned int arr_size)
{
  unsigned int i, first, second;

  /* There should be atleast two elements */
  if (arr_size < 2)
  {
    printf(" Invalid Input ");
    return 0;
  }

		// Error was here, before we had INT_MAX which is too low for >9 sailors
  first = second = UINT_MAX;
  for (i = 0; i < arr_size ; i ++)
  {
    /* If current element is smaller than first 
       then update both first and second */
    if (arr[i] < first)
    {
        second = first;
        first = arr[i];
    }

    /* If arr[i] is in between first and second 
       then update second  */
    else if (arr[i] < second && arr[i] != first)
      second = arr[i];
  }
  
  if (second == UINT_MAX)
  	return first;
  else 
		return second;
}


__global__
void monkey(unsigned long long int *coconuts, unsigned long long int extra, unsigned int *the_solutions, unsigned int *found, unsigned int sailors, unsigned int monkeys, unsigned int n)
{
	if (found[0] == 0){

		unsigned int j;
		for (unsigned int i = blockIdx.x * blockDim.x + threadIdx.x; i<n; i+=blockDim.x*gridDim.x){

			coconuts[i] = i + extra;

		  // Go through the number of sailors
		  for (j=0; j<sailors;j++){
	      // One for each monkey
	      coconuts[i] -= monkeys;      
	      if (coconuts[i] % sailors != 0){
	        break;
	      }			
	      coconuts[i] -= coconuts[i]/sailors;	  
		  }
		  if (coconuts[i] % sailors == 0){ 
	    	found[0] = 1;
	    	the_solutions[i] = i;   
		  }
		}
	}
}

// Main method
int main()
{

	clock_t start, diff;
	
	// Size of array.
	unsigned int SIZE = pow(2,25);

	// CPU memory pointers
	unsigned long long int *h_coc, da_solu=0;
	unsigned int *h_found, *h_solutions;

	// GPU memory pointers
	unsigned long long int *d_coc, extra = 0;
	unsigned int *d_found, *d_solutions;

	// Allocate the space, CPU
	h_coc = (unsigned long long int *)malloc(SIZE*sizeof(unsigned long long int));
	h_solutions = (unsigned int *)malloc(SIZE*sizeof(unsigned int));
	h_found = (unsigned int *)malloc(1*sizeof(unsigned int));
	
	// Choose to run on secondary GPU
	cudaSetDevice(1);

	// Allocate the space, GPU
	cudaMalloc(&d_coc, SIZE*sizeof(unsigned long long int));
	cudaMalloc(&d_found, 1*sizeof(unsigned int));
	cudaMalloc(&d_solutions, SIZE*sizeof(unsigned int));

	//cudamemset can be used for initializing data (say, all zeros). Basically same speed as cudaMemcpy but simpler.
	cudaMemset(d_solutions, 0, SIZE*sizeof(unsigned int));

	// Start timer
	start = clock();

	unsigned int monkeys = 1;

	// Run the loop	
	for (unsigned int sailors=1; sailors<11;sailors++){

		printf("Running %u sailors, %u monkeys", sailors, monkeys);

		// Send back that we want to look for a new solution
	  h_found[0] = 0; 
	  cudaMemset(d_found, 0, 1*sizeof(unsigned int));

	  // Assume that result for 5 sailors is larger than for 4 sailors and so on.. 
	  extra = da_solu+extra;

	  // Run this loop until a solution is found for this sailor & monkey combination
		while (h_found[0] == 0){

			// Calling kernel (gridsize, blocksize)
			monkey<<<(SIZE + 255) / 256, 256>>>(d_coc, extra, d_solutions, d_found, sailors, monkeys, SIZE);

			// Copy back result (Device to Host)
			cudaMemcpy(h_found, d_found, 1*sizeof(unsigned int), cudaMemcpyDeviceToHost);

			if (h_found[0] == 1){

				// Copy back result (Device to Host)
				cudaMemcpy(h_solutions, d_solutions, SIZE*sizeof(unsigned int), cudaMemcpyDeviceToHost);

			  // Get second smallest in solutions array and recast
			  da_solu = (unsigned long long int) print2Smallest(h_solutions, SIZE); 

			  printf("\nSolution: %llu coconuts to begin with\n\n", da_solu+extra);

			  // Set solution array to zero again
				cudaMemset(d_solutions, 0, SIZE*sizeof(unsigned int));

			}
			else{
				extra +=SIZE; 
				//printf(".");
			}
		}
	}
	
	// watch -n0.1 "nvidia-settings -q GPUUtilization -q useddedicatedgpumemory"

	// Print execution time
	diff = clock() - start;
  double totalt = (double)diff/CLOCKS_PER_SEC;
  printf("Totalt: %f s\n", totalt);

	// Free the allocated memory
	free(h_coc);
	free(h_found);
	free(h_solutions);

	// Free GPU memory
	cudaFree(d_coc);	
	cudaFree(d_found);
	cudaFree(d_solutions);

	// cudaDeviceReset causes the driver to clean up all state. While
  // not mandatory in normal operation, it is good practice.  It is also
  // needed to ensure correct operation when the application is being
  // profiled. Calling cudaDeviceReset causes all profile data to be
  // flushed before the application exits
  cudaDeviceReset();

	return 0;
}