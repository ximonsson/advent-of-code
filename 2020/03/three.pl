%
% Day 3: Toboggan Trajectory
%

read_row(R) :- read_token(T), atom_chars(T, R), get0(_).

read_map([]) :- peek_code(C), C =:= -1, !.
read_map([R|Rows]) :- read_row(R), read_map(Rows).
read_map(F, M) :- see(F), read_map(M), seen.

path([H|T], [R|M], I) :- nth(I, R, H), I is I + 3, path(T, M, I).
path(P, M) :- path(P, M, 0).

main :- read_map('input', M), path(P, M), write(P).
