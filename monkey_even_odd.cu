#pragma once

#ifdef __INTELLISENSE__

#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define __CUDACC__

#include <device_functions.h>

#endif

//#include <cuda.h>
// CUDA runtime
//#include "cuda_runtime.h"
//#include "device_launch_parameters.h"

// nvcc does not seem to like variadic macros, so we have to define
// one for each kernel parameter list:
#ifdef __CUDACC__
#define KERNEL_ARGS2(grid, block) <<< grid, block >>>
#define KERNEL_ARGS3(grid, block, sh_mem) <<< grid, block, sh_mem >>>
#define KERNEL_ARGS4(grid, block, sh_mem, stream) <<< grid, block, sh_mem, stream >>>
#else
#define KERNEL_ARGS2(grid, block)
#define KERNEL_ARGS3(grid, block, sh_mem)
#define KERNEL_ARGS4(grid, block, sh_mem, stream)
#endif


#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "monkey_even_odd.h"
//#include <thrust/sort.h>

// Now launch your kernel using the appropriate macro:
//kernel KERNEL_ARGS2(dim3(nBlockCount), dim3(nThreadCount)) (param1);
//https://stackoverflow.com/a/27992604/5241172

/*
nvcc -O3 -arch=sm_30 -o even_odd_cuda_monkey monkey_even_odd.cu
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
void monkey(unsigned int *tot, unsigned long long int extra, unsigned int *the_solutions, unsigned int *found, unsigned int sailors, unsigned int monkeys, unsigned int n)
{
  if (found[0] == 0){

    for (unsigned int i = blockIdx.x * blockDim.x + threadIdx.x; i<n; i+=blockDim.x*gridDim.x){

	  unsigned char j;
	  const unsigned long long int rExtra = extra;
	  unsigned int rCoconuts = tot[i] + rExtra;
	  const unsigned int rSailors = sailors;
	  const unsigned int rMonkeys = monkeys;

      // Go through the number of sailors
      for (j=0; j<rSailors;j++){
        // One for each monkey
		  rCoconuts -= rMonkeys;
        if (rCoconuts % rSailors != 0){
          break;
        }     
		rCoconuts -= rCoconuts/ rSailors;
      }
      if (rCoconuts % rSailors == 0){
        found[0] = 1;
        the_solutions[i] = i;
/*
        printf("i=%d",i);
        for (j=0;j<6;j++){
          printf("tot[%u]+extra(=%llu)=%d\n", i+j, extra,tot[i+j]+extra);
        }


        //printf("extra=%llu\n", extra);

        // test om der kopieres eller de begge bliver talt ned. de bliver kopieret, dvs. tot ikke skal reinitialiseres.
        // og det skal coconuts heller ikke
        printf("coconuts[%d]=%llu, tot[%d]+extra = %llu\n", i, coconuts[i], i, tot[i]+extra);
*/
      }
    }
  }
}

// Main method
int main()
{

  clock_t start, diff;
  
  // Size of array.
  unsigned int SIZE = (unsigned int)pow(2, 21);// 65536;// 65025;// / 2;//(unsigned int)pow(2,25);
  //unsigned int SIZE = 1024;// (unsigned int)pow(2, 20);

  /*
  // Possibly used to automate the SIZE value. For now, I found 2^21 to give good results 
  size_t availableMemory, totalMemory, usedMemory;

  cudaMemGetInfo(&availableMemory, &totalMemory);
  usedMemory = totalMemory - availableMemory;
  */


  int blockSize;   // The launch configurator returned block size 
  int minGridSize; // The minimum grid size needed to achieve the 
				   // maximum occupancy for a full device launch 
  int gridSize;    // The actual grid size needed, based on input size 


  // Sailors and monkeys
  unsigned char monkeys = 1;
  unsigned char max_sailors = 9;

  // CPU memory pointers
  unsigned long long int *h_coc, da_solu=1;
  unsigned int *h_found, *h_solutions, *h_tot;

  // GPU memory pointers
  unsigned long long int extra = 0;
  unsigned int *d_found, *d_solutions, *d_tot;

  // Allocate the space, CPU
  h_coc = (unsigned long long int *)malloc(SIZE*sizeof(unsigned long long int));
  cudaHostAlloc((void**)&h_solutions, SIZE*sizeof(unsigned int), cudaHostAllocDefault);
  h_found = (unsigned int *)malloc(1*sizeof(unsigned int));
  h_tot = (unsigned int *)malloc(SIZE*sizeof(unsigned int));
  
  // Choose to run on secondary GPU
  cudaSetDevice(1);

  // Allocate the space, GPU
  //cudaMalloc(&d_coc, SIZE*sizeof(unsigned long long int));
  cudaMalloc(&d_found, 1*sizeof(unsigned int));
  cudaMalloc(&d_solutions, SIZE*sizeof(unsigned int));
  cudaMalloc(&d_tot, SIZE*sizeof(unsigned int));

  //cudamemset can be used for initializing data (say, all zeros). 10 times faster than cudaMemcpy zero array because it is done on the gpu directly.
  //cudaMemset(d_solutions, 0, SIZE*sizeof(unsigned int));

  // Initialise the data
  unsigned int i, j=0;
  
  if (monkeys%2){
    //printf("odd\n");
    //solution will be odd
    i=1;
  }
  else{
    //printf("even\n");
    //solution will be even
    i=2;
  }

  while (j < SIZE)
  {
    //h_coc[j] = i;
    h_tot[j] = i;
    j++;
    i+=2;
  }

/*
  for (i=0;i<6;i++){
    printf("h_coc[%u]=%llu\n", i, h_coc[i]);
  }

  printf("h_coc[SIZE-1]=%llu\n", h_coc[SIZE-1]);

*/
  /*
  for (i=0;i<6;i++){
    printf("h_tot[%u]=%d\n", i, h_tot[i]);
  }

  printf("h_tot[SIZE-1]=%d\n", h_tot[SIZE-1]);
*/


  /*
  Transfer this to gpu*/
 // cudaMemcpy(d_coc, h_coc, SIZE*sizeof(unsigned long long int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_tot, h_tot, SIZE*sizeof(unsigned int), cudaMemcpyHostToDevice);

  //cudamemset can be used for initializing data (say, all zeros). 10 times faster than cudaMemcpy zero array because it is done on the gpu directly.
  cudaMemset(d_solutions, 0, SIZE*sizeof(unsigned int));

  // Get some qualified guess as to how to choose gridsize and blocksize
  cudaOccupancyMaxPotentialBlockSize(&minGridSize, &blockSize,
	  monkey, 0, SIZE);
  // Round up according to array size 
  gridSize = (SIZE + blockSize - 1) / blockSize;


  // Start timer
  start = clock();

  // Run the loop 
  for (unsigned char sailors=2; sailors<max_sailors+1;sailors++){

    printf("Running %u sailors, %u monkeys\n", sailors, monkeys);

    // Send back that we want to look for a new solution
    h_found[0] = 0; 
    cudaMemset(d_found, 0, 1*sizeof(unsigned int));

    // Assume that result for 5 sailors is larger than for 4 sailors and so on.. 
    //extra += h_tot[da_solu]+1;
    //printf("extra = %llu\n", extra);
    // Run this loop until a solution is found for this sailor & monkey combination
    

    while (h_found[0] == 0){
/*
      for (i=0;i<6;i++){
      printf("h_tot[%u]=%llu\n", i, h_tot[i]+extra);
      }

      printf("h_tot[SIZE-1]=%llu\n", h_tot[SIZE-1]+extra);
  */    

      // Calling kernel (gridsize, blocksize found above)
	  monkey KERNEL_ARGS2(gridSize, blockSize)(d_tot, extra, d_solutions, d_found, sailors, monkeys, SIZE);

      // Copy back result (Device to Host). 
      cudaMemcpy(h_found, d_found, 1*sizeof(unsigned int), cudaMemcpyDeviceToHost);

      if (h_found[0] == 1){

        //printf("extra = %llu\n", extra);

        // Copy back result (Device to Host). This is pinned memory so +6 Gb/s
        cudaMemcpy(h_solutions, d_solutions, SIZE*sizeof(unsigned int), cudaMemcpyDeviceToHost);
        
        //cudaMemcpyAsync(h_solutions, d_solutions, SIZE*sizeof(unsigned int), cudaMemcpyDeviceToHost, 0);
        //cudaDeviceSynchronize();
        
        // Get second smallest in solutions array and recast
        // possibly do this on gpu as well
        da_solu = (unsigned long long int) print2Smallest(h_solutions, SIZE); 

        printf("Solution: %llu coconuts to begin with\n\n", h_tot[da_solu]+extra);

        if (sailors != max_sailors){
          // Set solution array to zero again
          cudaMemset(d_solutions, 0, SIZE*sizeof(unsigned int));   
        }
      }
      else{
        // should always be equal amount
        extra += 2*SIZE; // size is even times 2 since we only use hver anden
        //printf("."); 
      }
    }
    extra += h_tot[da_solu]+1;
  }
  
  // watch -n 0.5 "nvidia-settings -q GPUUtilization -q useddedicatedgpumemory"

  // Print execution time
  diff = clock() - start;
  double totalt = (double)diff/CLOCKS_PER_SEC;
  printf("Totalt: %f s\n", totalt);

  // Free the allocated memory
  free(h_coc);
  free(h_found);
  free(h_tot);
  //free(h_solutions);
  // Pinned memory needs to be released with the command
  cudaFreeHost(h_solutions);

  // Free GPU memory
  //cudaFree(d_coc);  
  cudaFree(d_tot);
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