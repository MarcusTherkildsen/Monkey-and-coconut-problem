#!/bin/bash
sailors=5
monkeys=1

echo "Searching for solution"

while [[ $count -le 9 ]]; do
    (( coconuts_tot++ ))
    (( coconuts = coconuts_tot ))
    #echo "Checking $coconuts"

    sailor=1
    while [[ $sailor -le $sailors  ]];do
	(( sailor += 1 ))
	# One for each monkey
	(( coconuts -= monkeys  ))
	# Divide equally among sailors
	let "checkit = coconuts % sailors"
	if [ "$checkit" -ne 0 ]; then
	    #echo "Checkit is $checkit"
            break
	fi
	(( coconuts -= coconuts / sailors ))
    done

    let "check = coconuts % sailors"
    if [ "$check" -eq 0 ]; then
	break
    fi
done

echo "Solution: $coconuts_tot coconuts to begin with"
