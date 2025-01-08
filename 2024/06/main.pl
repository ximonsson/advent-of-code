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
patrol(M, 0, true, M) :- phrase(loop, M), !.

% guard is not on the map, i.e. walked out
patrol(M, N, false, M) :- outside(M), findall(_, phrase(match("X"), M), X), length(X, N).

% guard walks
patrol(Map, N, Loop, Solution) :- phrase(walk(M1), Map), rotc(M1, M2), patrol(M2, N, Loop, Solution).

make_loop(M, Ml) :-
	% first solve the puzzle. then only try putting obstacles in the path of the guard.
	patrol(M, _, false, M1), replace_all(88, 120, M1, M2),

	% TODO
	% place the guard in its original position.

	% add the obstacle and try to solve and see if the guard gets into a loop.
	char_code('O', C), select(120, M2, C, M0), patrol(M0, 0, true, Ml).

init(M, M1) :- select(94, M, 62, M0), rotcc(M0, M1).

guard_gallivant(F, N) :- read_file_to_codes(F, M, []), init(M, Map), patrol(Map, N, false, M2), write_map(M2).

guard_gallivant_2(F, N) :-
	read_file_to_codes(F, M, []), init(M, Map), findall(_, make_loop(Map, _), X), length(X, N).
