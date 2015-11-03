% Test at http://www.tutorialspoint.com/execute_matlab_online.php

% Creating some start variables
sailors = 5; 
monkeys = 1;
coconuts_tot = 0;

% For a certain amount of coconuts to begin with
while 0 == 0
	coconuts_tot += 1;
    coconuts = coconuts_tot;
    
    % Go through the number of sailors
    for j=1:sailors
    
        % One for each monkey
		coconuts -= monkeys;
		
		% Divide equally among sailors
		if mod(coconuts, sailors) != 0
			break
		end
	
	coconuts -= coconuts/sailors;
	
	end 

    if mod(coconuts, sailors) == 0
		break
    end
end
S=sprintf('Solution: %d coconuts to begin with',coconuts_tot);
disp(S)
