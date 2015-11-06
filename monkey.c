#include <stdio.h>      /* printf */

/* For this to work you need to compile it with the command 
gcc main.c -o demo -lm -pthread -lgmp -lreadline 2>&1
Can be tried out at 
http://www.tutorialspoint.com/c_standard_library/c_function_fmod.htm
Click "Try it" and paste this code
*/
int main()
{
    // Creating some start variables
    int sailors = 5;
    int monkeys = 1;
    int j;
    int coconuts_tot = 0;
    int coconuts;
	
    // Go through the number of coconuts
    while (0 == 0){
		coconuts_tot += 1;
        coconuts = coconuts_tot;
        
        // Go through the number of sailors
        for (j=0; j<sailors;j++){

            // One for each monkey
            coconuts -= monkeys;      
            if (coconuts % sailors != 0){
            break;
            }			
            coconuts -= coconuts/sailors;	
        }
		
        if (coconuts % sailors == 0){
            break;        
        } 
    }
    printf ( "Solution: %d coconuts to begin with\n",coconuts_tot);
    return 0;
}