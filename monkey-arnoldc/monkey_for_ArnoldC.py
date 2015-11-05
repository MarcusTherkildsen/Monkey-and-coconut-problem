# -*- coding: utf-8 -*-
"""
Created on Tue May 12 11:23:45 2015

@author: Marcus Therkildsen
"""
from __future__ import division
import itertools

'''
Reason for making this script: https://www.youtube.com/watch?v=U9qU20VmvaU

5 sailors, a monkey and a giant pile of coconuts.
Each sailor wakes up one at a time.
The awoken sailor sorts the coconuts into 5 piles.
There is 1 coconut left over -> the monkey gets it.
Then the sailor takes his pile and stores it somewhere.
'''

sailors = 5
monkeys = 1
coconuts_tot = 0
coconut_loop = 1

while coconut_loop == 1:
    coconuts_tot += 1
    coconuts = coconuts_tot

    sailor_loop = 1
    for sailor in xrange(sailors):

        if sailor_loop == 1:
            # One for each monkey
            coconuts -= monkeys
            # Divide equally among sailors
            if coconuts % sailors:
                sailor_loop = 0
            else:
                coconuts -= coconuts//sailors

    if coconuts % sailors == 0:
        coconut_loop = 0


print('Solution: ' + str(coconuts_tot) + ' coconuts to begin with')
