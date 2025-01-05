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
	phrase(lines(Ls), Data),
	% horizontal
	xmas(Data, X0), samx(Data, X1),
	% vertical
	transpose(Ls, Lt),
	apply(add_nl, Lt, Lt1), flatten(Lt1, DataT), % add newline to not mess with grammar
	xmas(DataT, X2), samx(DataT, X3),
	% diagonal...
	findall(_, diag(Ls), Dia), length(Dia, X4),
	% sum
	N is X0 + X1 + X2 + X3 + X4.


% part two
% - similar solution as the diagonal.

x_mas_([
	[A, _, D|_],
	[_, B, _|_],
	[E, _, C|_]
]) :-
	([A, B, C] == "MAS"; [A, B, C] == "SAM"),
	([D, B, E] == "MAS"; [D, B, E] == "SAM").

x_mas_([[_|T0], [_|T1], [_|T2]]) :- x_mas_([T0, T1, T2]).

% scroll through lines
x_mas([L1, L2, L3|_]) :- x_mas_([L1, L2, L3]).
x_mas([_|T]) :- x_mas(T).

ceres_search_2(F, N) :-
	phrase_from_file(lines(Ls), F), findall(_, x_mas(Ls), X), length(X, N).
