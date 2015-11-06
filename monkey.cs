using System;
/**
 * Created by Marcus Therkildsen on 27-10-2015.
 * Using http://www.tutorialspoint.com/compile_csharp_online.php 
 * to check if working
 */
public class MonkeyCSharp {
    
    // This is the main, equivalent to if __name__ == '__main__': in python
    public static void Main(String[] args) {
        
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
    Console.Write("Solution: " + coconuts_tot + " coconuts to begin with");		
    }
}
