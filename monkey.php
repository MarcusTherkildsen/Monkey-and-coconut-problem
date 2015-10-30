//Code can be tested at http://sandbox.onlinephpfunctions.com/

// Creating some start variables
$num_sailors = 5;
$search_to = 3500;
$perc = (1-1/$num_sailors);

// Go through the number of coconuts
for ($i=0;$i<$search_to;$i++){
    $num_coc = $i;

	// Go through the number of sailors
	for ($j=0; $j<$num_sailors;$j++){

		// Removing 1 coconut (for the monkey) and the amount that the certain sailor takes for himself
		$num_coc = ($num_coc - 1)*$perc;
	}
	
	/*
	Now each sailor has his own pile.
	The monkey has 5 and there's a pile left.
	Checking if there is an amount divisible by num_sailors left in the pile
	and if the number of remaining is positive (of course)
	 */
	
	if ((fmod($num_coc,$num_sailors) == 0) and ($num_coc >= 0)) {
		/* If the remaining (positive) number of coconuts is divisible between the sailors, then we found
		the solution.
		*/
		print ("Solution: $i coconuts to begin with");
	}
}