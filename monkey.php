//Code can be tested at http://sandbox.onlinephpfunctions.com/

// Creating some start variables
$sailors = 5;
$monkeys = 1;
$coconuts_tot = 0;

// Go through the number of coconuts  
while($monkeys > 0) {
	$coconuts_tot++;
	$coconuts = $coconuts_tot;

	// Go through the number of sailors
	for ($j = 1; $j <= $sailors; $j++) {
		
		// One for each monkey
		$coconuts = $coconuts - $monkeys;
		
		// Divide equally among sailors
		if ($coconuts % $sailors != 0) {
			break;
		}
		
		$coconuts = $coconuts - ($coconuts / $sailors);
		}
		if ($coconuts % $sailors == 0) {
		  
		break;
	}
} 
echo "Solution: $coconuts_tot coconuts to begin with";