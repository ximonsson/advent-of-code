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

oper(Ax, Bx, Acc, Y) :- Y0 is (Acc + Ax), (Bx =\= 0 -> Y is Y0 * Bx; Y is Y0).

repair(eq(Y, [X0|Xs]), A, B) :-
	length(Xs, N), ones_zeros(N, A), ones_zeros(N, B),
	add(A, B, C), ones_zeros(N, C), all(C),
	mul(A, Xs, AX), mul(B, Xs, BX), foldl(oper, AX, BX, X0, Y).

repair(E) :- repair(E, _, _).

sum_eqs([], N, N).
sum_eqs([eq(Y, _)|Es], Acc, N) :- Acc0 is Acc + Y, sum_eqs(Es, Acc0, N).

bridge_repair(F, N) :-
	phrase_from_file(eqs(Es), F), include(repair, Es, Evs), sum_eqs(Evs, 0, N).
