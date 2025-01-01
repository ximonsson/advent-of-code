% Day 04
% https://adventofcode.com/2024/day/4

% count XMAS

xmas(N0, N) --> "XMAS", { N1 is N0 + 1 }, !, xmas(N1, N).
xmas(Acc, N) --> [_], xmas(Acc, N).
xmas(N, N) --> [].

% read as lines so we can read vertically

lines([L|Ls]) --> line(L), "\n", !, lines(Ls).
lines([]) --> [].

line([]) --> [].
line([H|T]) --> [H], line(T).

% TODO transpose
%
% TODO diagonal

% solution part one

ceres_search(Data, N) :-
	phrase(xmas(0, X), Data),  % normal reading order
	reverse(Data, Atad), phrase(xmas(0, Y), Atad),  % reversed
	phrase(lines(Ls), Data),
	N is X + Y.
