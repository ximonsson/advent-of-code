% Day 07 : Bridge Repair
% https://adventofcode.com/2024/day/7

:- [utils].

eqs([E|Es]) --> eq_(E), "\n", eqs(Es).
eqs([]) --> [].

eq_(eq(Y, Xs)) --> integer(Y), ":", xs(Xs).

xs([X|Xs]) --> " ", integer(X), xs(Xs).
xs([]) --> [].

ones_zeros(0, []).
ones_zeros(N, [H|T]) :- N > 0, N0 is N - 1, member(H, [0, 1]), ones_zeros(N0, T).

inv([], []).
inv([1|T0], [0|T1]) :- inv(T0, T1).
inv([0|T0], [1|T1]) :- inv(T0, T1).

mask([], [], []).
mask([1|T0], [H|T1], [H|T2]) :- mask(T0, T1, T2).
mask([0|T0], [_|T1], [0|T2]) :- mask(T0, T1, T2).

oper(A, 0, Acc, Y) :- Y is Acc + A.
oper(0, B, Acc, Y) :- Y is Acc * B.

repair(eq(Y, [X0|Xs]), A, B) :-
	length(Xs, N), ones_zeros(N, A), inv(A, B),
	mask(A, Xs, AX), mask(B, Xs, BX), foldl(oper, AX, BX, X0, Y).

repair(E) :- repair(E, _, _).

sum_eqs([], N, N).
sum_eqs([eq(Y, _)|Es], Acc, N) :- Acc0 is Acc + Y, sum_eqs(Es, Acc0, N).

bridge_repair(F, N) :-
	phrase_from_file(eqs(Es), F), include(repair, Es, Evs), sum_eqs(Evs, 0, N).

% part two

combine(X, Y, Z) :-
	number_codes(X, Cx), number_codes(Y, Cy), append(Cx, Cy, Cz), number_codes(Z, Cz).

oper2(A, 0, 0, Acc, Y) :- Y is Acc + A.
oper2(0, B, 0, Acc, Y) :- Y is Acc * B.
oper2(0, 0, C, Acc, Y) :- combine(Acc, C, Y).

coefs(0, []).
coefs(N, [[1, 0, 0]|T2]) :- N > 0, N0 is N - 1, coefs(N0, T2).
coefs(N, [[0, 1, 0]|T2]) :- N > 0, N0 is N - 1, coefs(N0, T2).
coefs(N, [[0, 0, 1]|T2]) :- N > 0, N0 is N - 1, coefs(N0, T2).

mask([], [], [], [], []).
mask([X|Xs], [[1, 0, 0]|T0], [X|Ta], [0|Tb], [0|Tc]) :- mask(Xs, T0, Ta, Tb, Tc).
mask([X|Xs], [[0, 1, 0]|T0], [0|Ta], [X|Tb], [0|Tc]) :- mask(Xs, T0, Ta, Tb, Tc).
mask([X|Xs], [[0, 0, 1]|T0], [0|Ta], [0|Tb], [X|Tc]) :- mask(Xs, T0, Ta, Tb, Tc).

repair2(eq(Y, [X0|Xs]), A, B, C) :-
	length(Xs, N), coefs(N, Alpha), mask(Xs, Alpha, A, B, C), foldl(oper2, A, B, C, X0, Y).

repair2(E) :- repair2(E, _, _, _).

bridge_repair_2(F, N) :-
	phrase_from_file(eqs(Es), F), include(repair2, Es, Evs), sum_eqs(Evs, 0, N).
