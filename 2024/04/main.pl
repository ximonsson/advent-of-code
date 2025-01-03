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

diag([A|T0], [_, B|T1], [_, _, C|T2], [_, _, _, D|T3]).

% solution part one

ceres_search(F, N) :- read_input(F, Data),
	% normal reading order
	phrase(xmas(0, X), Data),
	% reversed
	reverse(Data, Atad),
	phrase(xmas(0, Y), Atad),
	% vertical
	phrase(lines(Ls), Data),
	transpose(Ls, Lt),
	flatten(Lt, DataT),
	phrase(xmas(0, Z), DataT),
	% vertical reversed
	reverse(DataT, AtadT),
	phrase(xmas(0, V), AtadT),
	% diagonal...

	N is X + Y + Z + V.
