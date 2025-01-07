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
rotate_map_cc(M, M0) :- transpose(M, M1), flip_map(M1, M0).
rotate_map_c(M, M0) :- transpose(M, M1), reverse(M1, M0).

map_width(M, W) :- head(M, L), length(L, W).

nlocs(M, N) :- flatten(M, M1), findall(_, phrase(match("X"), M1), X), length(X, N0), N is N0 + 1.

% For simplicity we only handle going right. Rotating the board when an obstacle is hit.

walk(N, false) --> ignore, ">", step(X), "#", ignore, { length(X, N) }.
walk(N, true) --> ignore, ">", step(X), { length(X, N) }. % out of map

step([]) --> [].
step([H|T]) --> [H], step(T).

% patrol the map
patrol(M, Row, Acc, N) :-
	% get current line and find which column the guard is on
	nth0(Row, M, L), nth0(Col, L, 62),
	%writeln(Row), writeln(Col),
	%string_codes(S_, L), writeln(S_),

	% guard walks
	phrase(walk(N0, Out), L), Acc0 is Acc + N0,
	%writeln(N0),

	% move guard
	% - replace the line with the guard moved forward
	replace0(Col, Col + N0, 88, L, L0),
	replace0(Col + N0, 62, L0, L1),
	replace0(Row, L1, M, M1),

	%string_codes(S, "walked ----"), write(S), write(' '), writeln(N0), print_map(M1),

	% is the guard ?
	% - yes: return
	% - no: rotate map & patrol more
	(
		Out -> nlocs(M1, N) ;
		(
			rotate_map_c(M1, M2),
			map_width(M2, W),
			Row0 is W - Col - N0 - 1,  % new row
			%print_map(M2),
			patrol(M2, Row0, Acc0, N))
	).

% which row is the guard on?
%guard_row(R, R) --> ignore, ">", rest(_).
%guard_row(R, R) --> ignore, "<", rest(_).
%guard_row(R, R) --> ignore, "v", rest(_).
guard_row(R, R) --> ignore, "^", rest(_).
guard_row(Acc, R) --> ignore, "\n", { Acc0 is Acc + 1 }, guard_row(Acc0, R).

guard_row([L|_], Row, Row) :- memberchk(94, L).
guard_row([_|Map], Acc, Row) :- Acc0 is Acc + 1, guard_row(Map, Acc0, Row).


% guard is facing up
% - fix map by rotating left.
guard_up(Map, Map1) :-
	memberchk(94, Map), select(94, Map, 62, M2), phrase(lines(M3), M2), rotate_map_cc(M3, Map1).

% initialize map by rotating/flipping based on direction of the guard.
init(Map, Map1, Row) :- guard_up(Map, Map1), guard_row(Map1, 0, Row).

guard_gallivant(F, N) :-
	read_file_to_codes(F, M, []), init(M, Map, Row), print_map(Map), writeln(Row), patrol(Map, Row, 0, N).
