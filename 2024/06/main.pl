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
:- use_module(library(clpfd)).


map_codes_list(M, Ls) :- phrase(lines(Ls), M).

flip_map(M, M0) :- apply(reverse, M, M0).

rotcc(M, M1) :-
	map_codes_list(M, Ls), reverse(Ls, Ls0), transpose(Ls0, Ls1), map_codes_list(M1, Ls1).

rotc(M, M1) :-
	map_codes_list(M, Ls), transpose(Ls, Ls0), reverse(Ls0, Ls1), map_codes_list(M1, Ls1).

rotn(0, M, M).
rotn(N, M, M0) :- N > 0, N0 is N - 1, rotc(M, M1), rotn(N0, M1, M0).

% we are in a loop when the entire path has been walked already.

obstacle("\n") --> "\n".
obstacle("#") --> "#".
obstacle("O") --> "O".

loop --> ignore, ">", string([Step|Steps]), obstacle(_), rest(_), { Step is 88, all([Step|Steps]) }.

walk(M) --> string(Pre), ">", string(Path), obstacle(O), !, rest(Rest),
	{
		length(Path, N),
		repeate(N, 88, PathX),
		( O == "\n" -> Icon = "X"; Icon = ">" ),
		append([Pre, PathX, Icon, O, Rest], M)
	}.

% guard is outside if we find it right before a newline (where it exited).
outside(M) :- \+ memberchk(62, M).

write_map(M) :- string_codes(S, M), writeln(S).

% we are in a loop
patrol(M, 0, true, M, Moves, Moves) :- phrase(loop, M), !.

% guard is not on the map, i.e. walked out
patrol(M, N, false, M, Moves, Moves) :- outside(M), findall(_, phrase(match("X"), M), X), length(X, N).

% guard walks
patrol(Map, N, Loop, Solution, Acc, Moves) :-
	phrase(walk(M1), Map), rotc(M1, M2), Acc0 is Acc + 1, patrol(M2, N, Loop, Solution, Acc0, Moves).

make_loop(M, Ml) :-
	nth0(I, M, 62),  % starting position for the guard
	% first solve the puzzle. then only try putting obstacles in the path of the guard.
	patrol(M, _, false, M1, 0, Moves), replace_all(88, 120, M1, M2),

	% TODO
	% place the guard in its original position.
	rotn(4 - Moves mod 4, M2, M3),
	replace0(I, 62, M3, M4),

	% add the obstacle and try to solve and see if the guard gets into a loop.
	char_code('O', C), select(120, M4, C, M0), patrol(M0, 0, true, Ml, 0, _).

init(M, M1) :- select(94, M, 62, M0), rotcc(M0, M1).

guard_gallivant(F, N) :-
	read_file_to_codes(F, M, []), init(M, Map), patrol(Map, N, false, M2, 0, _), write_map(M2).

guard_gallivant_2(F, N) :-
	read_file_to_codes(F, M, []), init(M, Map), findall(_, make_loop(Map, _), X), length(X, N).
