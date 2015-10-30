#include <stdio.h>      /* printf */
#include <math.h>       /* fmod */

/* For this to work you need to compile it with the command 
gcc main.c -o demo -lm -pthread -lgmp -lreadline 2>&1
Can be tried out at 
http://www.tutorialspoint.com/c_standard_library/c_function_fmod.htm
Click "Try it" and paste this code
*/
int main()
{
    // Creating some start variables
    float num_sailors = 5;
    int search_to = 3500;
    int i, j;
    float num_coc;
	float perc = (1 - 1/num_sailors); 
    
    // Go through the number of coconuts
    for (i=0; i<search_to;i++){
        num_coc = i;
        
        // Go through the number of sailors1
        for (j=0; j<num_sailors;j++){

            /* Removing 1 coconut (for the monkey) and the amount that the 
            certain sailor takes for himself */
            num_coc = (num_coc - 1)*perc;
        
		}
		
		/*
        Now each sailor has his own pile.
        The monkey has 5 and there's a pile left.
        Checking if there is an amount divisible by num_sailors left in the pile
        and if the number of remaining is positive (of course)
         */
		
		
		if (fmod(num_coc, num_sailors) == 0 & (num_coc >= 0)){
            /* If the remaining (positive) number of coconuts is divisible
            between the sailors, then we found the solution.*/
	        printf ( "Solution: %i coconuts to begin with\n",i);
		} 
    }
    return 0;
}