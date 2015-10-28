package com.example.monkeyjava;

/**
 * Created by Marcus Therkildsen on 27-10-2015.
 */
public class MonkeyJava {

    // This is the main, equivalent to if __name__ == '__main__': in python
    public static void main(String[] args) {

        // Creating some start variables
        int num_sailors = 5;
        int search_to = 3500;

        // For a certain amount of coconuts to begin with
        for (int i=0; i<search_to; i++) {
            // Since taking the modulo can result in non-integer fractions we declare the number of coconuts to float
            float num_coc = i;

            // Go through the number of sailors
            for (int j=0; j<num_sailors;j++){

                // Removing 1 coconut (for the monkey) and the amount that the certain sailor takes for himself
                num_coc = num_coc - 1 - (num_coc-1)/num_sailors;
            
			}

            /*
            Now each sailor has his own pile.
            The monkey has 5 and there's a pile left.
            Checking if there is an amount divisible by num_sailors left in the pile
            and if the number of remaining is positive (of course)
             */

            if ((num_coc % num_sailors == 0) & (num_coc >= 0)) {
                /* If the remaining (positive) number of coconuts is divisible between the sailors, then we found
                the solution.
                */
                System.out.println("Solution: " + i + " coconuts to begin with");
            }
        }

    }
}
