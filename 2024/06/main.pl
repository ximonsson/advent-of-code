% Day 06: Guard Gallivant
% https://adventofcode.com/2024/day/6
% ---
%
% 1. walk to stop.
% 1.a. if end of map goto 3.
% 2. rotate map, go to 1.
% 3. stop
%

%
% '^' = 94
% '>' = 62
% '<' = 60
% 'v' = 118
% '#' = 35
% '.' = 46
% -----------

:- [utils].

appendnl(L, L0) :- append(L, "\n", L0).

print_map(M) :- apply(appendnl, M, M0), flatten(M0, M1), string_codes(M2, M1), writeln(M2).

flip_map(M, M0) :- apply(reverse, M, M0).
rotate_map(M, M0) :- transpose(M, M1), flip_map(M1, M0).

% For simplicity we only handle going right. Rotating the board when an obstacle is hit.

% Grammar
% ---

walk(N, false) --> ignore, ">", step(X), "#", ignore, { length(X, N) }.
walk(N, true) --> ignore, ">", step(X), { length(X, N) }. % out of map

step([]) --> [].
step([H|T]) --> [H], step(T).


patrol(M, Row, Acc, N) :-
	writeln("start"),
	print_map(M),
	nth0(Row, M, L),
	nth0(Col, L, 62),

	% guard walks
	phrase(walk(N0, Out), L),
	Acc0 = Acc + N0,

	% move guard
	% - replace the line with the guard moved forward
	select(62, L, 46, L0),
	take(Col + N0, L0, L1), drop(Col + N0 + 1, L0, L2), append([L1, ">", L2], L3),
	take(Row, M, Ls0), drop(Row + 1, M, Ls1), append([Ls0, [L3], Ls1], M1),

	writeln("end"),
	print_map(M1),

	% is the guard ?
	% - yes: return
	% - no: rotate map & patrol more
	(
		Out -> N = Acc0 ;
		(rotate_map(M1, M2), patrol(M2, Row, Acc0, N))  % TODO re-calculate Row!!!
	).


guard_row(Acc, R) --> ignore, "\n", { Acc0 is Acc + 1 }, guard_row(Acc0, R).
guard_row(R, R) --> ignore, "^", ignore.

guard_up(Map, Map1) :-
	memberchk(94, Map), select(94, Map, 62, M2), phrase(lines(M3), M2), rotate_map(M3, Map1).

init(Map, Map1, Row) :- guard_up(Map, Map1), phrase(guard_row(0, Row), Map).

guard_gallivant(F, N) :-
	read_file_to_codes(F, M, []), init(M, Map, Row), print_map(Map), patrol(Map, Row, 0, N).
