% Day 07 : Bridge Repair
% https://adventofcode.com/2024/day/7

:- [utils].

% Y = AX^T * BX
% A and B are only 1's and 0's.

ones_zeros(0, []).
ones_zeros(N, [H|T]) :- N > 0, N0 is N - 1, member(H, [0, 1]), ones_zeros(N0, T).

