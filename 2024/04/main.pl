% Day 04
% https://adventofcode.com/2024/day/4
% --
% NOTE this is where I switch to SWI prolog for convenience.

:- [utils].

% count XMAS

xmas(X, N) :- findall(_, phrase(match("XMAS"), X), Y), length(Y, N).

% read as lines so we can read vertically

lines([L|Ls]) --> line(L), "\n", !, lines(Ls).
lines([]) --> [].

line([]) --> [].
line([H|T]) --> [H], line(T).

diag([[A|_], [_, B|_], [_, _, C|_], [_, _, _, D|_]]) :-  [A, B, C, D] == "XMAS".
diag([[_|T0], [_|T1], [_|T2], [_|T3]]) :- diag([T0, T1, T2, T3]).

% solution part one

ceres_search(F, N) :- read_file_to_codes(F, Data, [access(read)]),
	% normal reading order
	xmas(Data, X0),
	% reversed
	reverse(Data, Atad),
	xmas(Atad, X1),
	% vertical
	phrase(lines(Ls), Data),
	transpose(Ls, Lt),
	flatten(Lt, DataT),
	xmas(DataT, X2),
	% vertical reversed
	reverse(DataT, AtadT),
	xmas(AtadT, X3),
	% diagonal...

	N is X0 + X1 + X2 + X3.
