package com.example.monkeyjava;

/**
 * Created by Marcus Therkildsen on 27-10-2015.
 */
public class MonkeyJava {

    // This is the main, equivalent to if __name__ == '__main__': in python
    public static void main(String[] args) {

        // Creating some start variables
        int sailors = 5;
        int monkeys = 1;
        int coconuts_tot = 0;

        // Go through the number of coconuts
        while (0 == 0){
            coconuts_tot += 1;
            int coconuts = coconuts_tot;

            // Go through the number of sailors
            for (int j=0; j<sailors;j++){

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

        System.out.println("Solution: " + coconuts_tot + " coconuts to begin with");
    }
}
