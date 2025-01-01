% Day 3
% https://adventofcode.com/2024/day/3

%:- consult('utils').

% grammar

muls([Mul|Muls]) --> mul_(Mul), muls(Muls).
muls(Muls) --> [_], muls(Muls).
muls([]) --> [].

mul_(mul(X, Y)) --> "mul(", integer(X), ",", integer(Y), ")", { X < 1000, Y < 1000 }.

% part one

prod(mul(X, Y), Z) :- Z is X * Y.

prod_list([H|T], [X|Y]) :- prod(H, X), prod_list(T, Y).
prod_list([], []).

mul_it_over(F, N) :-
	read_input(F, Data), phrase(muls(Muls), Data), prod_list(Muls, P), sum_list(P, N).

% part two
% ---
% we solve it by removing everything that is between "don't()....do()", and then
% run the solution from part one on the result.

dos(X) --> do(Y), "don't()", dont, !, dos(Z), { append(Y, Z, X) }.
dos(X) --> do(X).

do([]) --> [].
do([H|T]) --> [H], do(T).

dont --> "do()".
dont --> [_], dont.
dont --> [].

mul_it_over_2(F, N) :-
	read_input(F, Data),
	phrase(dos(X), Data),
	phrase(muls(Muls), X),
	prod_list(Muls, P),
	sum_list(P, N).
