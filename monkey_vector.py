# -*- coding: utf-8 -*-
"""
Created on Tue May 12 11:23:45 2015
@author: Marcus Therkildsen
"""
from __future__ import division
import numpy as np
from time import clock
from numba import vectorize
'''
Reason for making this script: https://www.youtube.com/watch?v=U9qU20VmvaU
5 sailors, a monkey and a giant pile of coconuts.
Each sailor wakes up one at a time.
The awoken sailor sorts the coconuts into 5 piles.
There is 1 coconut left over -> the monkey gets it.
Then the sailor takes his pile and stores it somewhere.
'''


def problem_single(N):
    monkeys = 1
    sailors = 8
    for coconuts_tot in xrange(N):
        coconuts = coconuts_tot
        for sailor in xrange(sailors):
            # One for each monkey
            coconuts -= monkeys
            # Divide equally among sailors
            if coconuts % sailors:
                break
            coconuts -= coconuts//sailors
        if not coconuts % sailors:
            break
    return coconuts_tot


def problem_vec(coconuts):
    monkeys = 1
    sailors = 8
    for sailor in xrange(sailors):
        coconuts -= monkeys
        coconuts = coconuts - coconuts/sailors
    return coconuts


@vectorize(["float64(float64)"], target='cpu')
def problem_vec_numba(coconuts):
    monkeys = 1
    sailors = 8
    for sailor in xrange(sailors):
        coconuts = (coconuts - monkeys) - (coconuts - monkeys)/sailors
    return coconuts


def main():

    N = 120000000  # Number of elements per array

    sailors = 8

    A = np.arange(N, dtype=np.float64)
    B = np.ones(N, dtype=np.float64)

    start = clock()
    C = problem_single(N)
    vectoradd_time = clock() - start
    print 'Interative solution: ' + str(C)
    print('Done in ' + str(round(vectoradd_time, 5)) + ' seconds\n')

    start = clock()
    B = problem_vec(A)
    modResult = B % sailors
    solutions = np.where(modResult == 0)[0][0]
    vectoradd_time = clock() - start
    print 'Vector solution: ' + str(solutions)
    print('Done in ' + str(round(vectoradd_time, 5)) + ' seconds\n')

    B = np.ones(N, dtype=np.float64)

    start = clock()
    B = problem_vec_numba(A)
    modResult = B % sailors
    solutions = np.where(modResult == 0)[0][0]
    vectoradd_time = clock() - start
    print 'Vector+numba solution: ' + str(solutions)
    print('Done in ' + str(round(vectoradd_time, 5)) + ' seconds\n')

if __name__ == '__main__':
    main()

    '''
    The trick to using vectorize is that the target function must be
    a scalar function.
    This means that all input and output parameters must be scalar values
    recognised by NumPy, such as float32, int32 and so on.
    '''
