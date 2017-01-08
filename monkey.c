#include <stdio.h>      /* printf */

/* For best result, compile with gcc -O3 monkey.c
Or else the code can be tried out at 
http://codepad.org/
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
