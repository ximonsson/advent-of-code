% Day 04
% https://adventofcode.com/2024/day/4
% --
% NOTE this is where I switch to SWI prolog for convenience.

:- [utils].

% count XMAS

xmas(X, N) :- findall(_, phrase(match("XMAS"), X), Y), length(Y, N).
samx(X, N) :- findall(_, phrase(match("SAMX"), X), Y), length(Y, N).

% diagonal

% diagonal upper left down right
diag_([[A|_], [_, B|_], [_, _, C|_], [_, _, _, D|_]]) :-
	[A, B, C, D] == "XMAS"; [A, B, C, D] == "SAMX".

% diagonal upper right down left
diag_([[_, _, _, A|_], [_, _, B, _|_], [_, C, _, _|_], [D|_]]) :-
	[A, B, C, D] == "XMAS"; [A, B, C, D] == "SAMX".

% continue the current rows one token to the right
diag_([[_|T0], [_|T1], [_|T2], [_|T3]]) :- diag_([T0, T1, T2, T3]).

% scroll through lines
diag([L1, L2, L3, L4|_]) :- diag_([L1, L2, L3, L4]).
diag([_|T]) :- diag(T).

add_nl(L, L1) :- append(L, "\n", L1).

% solution part one

ceres_search(F, N) :- read_file_to_codes(F, Data, [access(read)]),
%reverse(Data, Atad),
	phrase(lines(Ls), Data),
	% horizontal
	xmas(Data, X0), samx(Data, X1),
	% vertical
	transpose(Ls, Lt),
	apply(add_nl, Lt, Lt1), flatten(Lt1, DataT), % add newline to not mess with grammar
	xmas(DataT, X2), samx(DataT, X3),
	% diagonal...
	findall(_, diag(Ls), Dia), length(Dia, X4),

	writeln(X0),
	writeln(X1),
	writeln(X2),
	writeln(X3),
	writeln(X4),

	N is X0 + X1 + X2 + X3 + X4.
