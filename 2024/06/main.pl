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

:- [utils].

appendnl(L, L0) :- append(L, "\n", L0).

print_map(M) :- apply(appendnl, M, M0), flatten(M0, M1), string_codes(M2, M1), writeln(M2).

flip_map(M, M0) :- apply(reverse, M, M0).
rotate_map(M, M0) :- transpose(M, M1), flip_map(M1, M0).

% For simplicity we only handle going right. Rotating the board when an obstacle is hit.

% Grammar
% ---

walk(N) --> ignore, ">", step(X), "#", ignore, { length(X, N) }.
walk(N) --> ignore, ">", step(X), { length(X, N) }. % out of map

step([]) --> [].
step([H|T]) --> [H], step(T).


%move(M, L, Acc, N) :- phrase(walk(N0), L), rotate_map(M, M1), Acc0 = Acc + N0, move(M1, L, Acc0, N).
