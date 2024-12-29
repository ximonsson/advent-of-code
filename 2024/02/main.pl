% https://adventofcode.com/2024/day/2
%
% read file

%add_loc(_, L, L) :- at_end_of_stream.
%add_loc(X, L, [X|L]).

%read_locs([]) :- at_end_of_stream.
%read_locs(L) :- read_token(H), add_loc(H, T, L), read_locs(T).

read_line([]) :- at_end_of_stream, !.
read_line([H|T]) :- get(H), read_line(T).

reports(F, L) :- see(F), read_line(L), seen.

report --> levels.

