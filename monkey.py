# -*- coding: utf-8 -*-
"""
Created on Tue May 12 11:23:45 2015

@author: Marcus Therkildsen
"""
from __future__ import division
import numpy as np
import matplotlib.pyplot as plt

# Reason for making this script: https://www.youtube.com/watch?v=U9qU20VmvaU

# 5 sailors, a monkey and a giant pile of coconuts. 
# Each sailor wakes up one at a time. 
# The awoken sailor sorts the coconuts into 5 piles. 
# There is 1 coconut left over -> the monkey gets it.
# Then the sailor takes his pile and stores it somewhere. 

num_sailors = 5
search_to = 3500

for_plot = []
solution_x = []
solution_y = []
# Answer is 3121
for sd in xrange(search_to):
    num_coc = np.copy(sd)
    for fd in xrange(num_sailors):
        
        # Removing 1 coconut (for the monkey) and the amount that the certain sailor takes for himself  
        num_coc = num_coc - 1 - (num_coc-1)/num_sailors
    
    for_plot.append((num_coc)%num_sailors)
    # Now each sailor has his own pile.
    # The monkey has 5
    # and there's a pile left.

    # Checking if there is an amount divisable by num_sailors left in the pile
    # and if the number of remaining is positive (of course)
    
    if (num_coc)%num_sailors == 0 and num_coc>=0:
        print 'Solution: ' + str(sd) + ' coconuts to begin with'
        #for_plot.append(num_coc)
        solution_x.append(sd)
        solution_y.append((num_coc)%num_sailors)
        
plt.figure()
plt.plot(np.arange(search_to),for_plot,lw=3)
plt.plot(solution_x,solution_y,'ro',zorder=10,markersize = 11)
plt.xlabel('Coconuts to begin with')
plt.ylabel('Check if zero left for monkey in the end')
plt.suptitle('Monkey and coconut problem',fontsize = 18)
plt.ylim([-0.004,0.1])
plt.axhline(0,color='k',lw=2)
plt.show()