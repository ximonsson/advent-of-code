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

% part two

