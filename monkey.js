// Creating some start variables
var sailors = 5;
var monkeys = 1;
var coconuts_tot = 0;

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

document.write("Solution: " + coconuts_tot + " coconuts to begin with");