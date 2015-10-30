% Test at http://www.tutorialspoint.com/matlab/try_matlab.php

% Creating some start variables
num_sailors = 5; 
search_to = 3499;
perc = (1-1/num_sailors);

% For a certain amount of coconuts to begin with
for i=0:search_to
    num_coc = i;
    
    % Go through the number of sailors
    for j=0:num_sailors - 1 % Remember, in MATLAB this means 0:4 = 0, 1, 2, 3, 4
    
        % Removing 1 coconut (for the monkey) and the amount that the certain
        % sailor takes for himself
		num_coc = (num_coc-1)*perc; 
	end 
    
	% Now each sailor has his own pile.
	% The monkey has 5 and there's a pile left.
	% Checking if there is an amount divisible by num_sailors left in the pile
	% and if the number of remaining is positive (of course)
	 
    if mod(num_coc, num_sailors) == 0 && num_coc >= 0
        % If the remaining (positive) number of coconuts is divisible between
        % the sailors, then we found the solution.
		
        disp('Solution: '), disp(i), disp(' coconuts to begin with')
    end
end