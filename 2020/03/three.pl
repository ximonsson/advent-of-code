%
% Day 3: Toboggan Trajectory
%

read_row(R) :- read_token(T), atom_chars(T, R), get0(_).

read_map([]) :- peek_code(C), C =:= -1, !.
read_map([R|Rows]) :- read_row(R), read_map(Rows).

read_map(F, M) :- see(F), read_map(M), seen.

main :- read_map('input', M), write(M).
