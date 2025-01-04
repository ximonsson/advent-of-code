% Day 04
% https://adventofcode.com/2024/day/4
% --
% NOTE this is where I switch to SWI prolog for convenience.

:- [utils].
:- use_module(library(dcg/basics)).

match2(Pattern) -->
	string(_),
	string(Pattern),
	remainder(_).

% count XMAS

xmas(X, N) :- findall(_, phrase(match("XMAS"), X), Y), length(Y, N).
samx(X, N) :- findall(_, phrase(match("SAMX"), X), Y), length(Y, N).

% read as lines so we can read vertically

lines([L|Ls]) --> line(L), "\n", !, lines(Ls).
lines([]) --> [].

line([]) --> [].
line([H|T]) --> [H], line(T).

diag_([[A|_], [_, B|_], [_, _, C|_], [_, _, _, D|_]]) :- [A, B, C, D] == "XMAS"; [A, B, C, D] == "SAMX".
diag_([[_, _, _, A|_], [_, _, B, _|_], [_, C, _, _|_], [D|_]]) :- [A, B, C, D] == "XMAS"; [A, B, C, D] == "SAMX".
diag_([[_|T0], [_|T1], [_|T2], [_|T3]]) :- diag_([T0, T1, T2, T3]).

diag([L1, L2, L3, L4|_]) :- diag_([L1, L2, L3, L4]).
diag([_|T]) :- diag(T).

% solution part one

ceres_search(F, N) :- read_file_to_codes(F, Data, [access(read)]),
%reverse(Data, Atad),
	phrase(lines(Ls), Data),
	% normal reading order
	xmas(Data, X0),
	% reversed
	samx(Data, X1),
	% vertical
	transpose(Ls, Lt),
	flatten(Lt, DataT),
	xmas(DataT, X2),
	% vertical reversed
	samx(DataT, X3),
	% diagonal...
	findall(_, diag(Ls), Dia), length(Dia, X4),

	writeln(X0),
	writeln(X1),
	writeln(X2),
	writeln(X3),
	writeln(X4),

	N is X0 + X1 + X2 + X3 + X4.
