/**
 * 01. Repair Report
 * https://adventofcode.com/2020/day/1
 */

% only append if it is an int
readint(H, T, T) :- \+ number(H).
readint(H, T, [H|T]) :- number(H).

% reads all lines of a file
read_report([]) :- at_end_of_stream, !.
read_report(L) :- read_token(H), readint(H, T, L), read_report(T).

% read all lines into L from file F
report(L, F) :- see(F), read_report(L), seen.

% find the two expenses that add to 2020 and give their product.
expenses(Z, X, Y, Rep) :- member(X, Rep), member(Y, Rep), X \= Y, X+Y =:= 2020, Z is X*Y.

% find the three expenses that add to 2020 and give their product.
expenses(Z, X, Y, S, Rep) :-
	member(X, Rep), member(Y, Rep), member(S, Rep),
	X \= Y, X \= S, S \= Y,
	X+Y+S =:= 2020,
	Z is X*Y*S.

% main function to read the input and find the value
main :-
	report(L, 'input'),
	expenses(X2, _, _, L), write(X2), nl,
	expenses(X3, _, _, _, L), write(X3), nl, !.
