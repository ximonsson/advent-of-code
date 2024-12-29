% https://adventofcode.com/2024/day/1

% read file

add_loc(_, L, L) :- at_end_of_stream.
add_loc(X, L, [X|L]).

read_locs([]) :- at_end_of_stream.
read_locs(L) :- read_token(H), add_loc(H, T, L), read_locs(T).

locations(F, L) :- see(F), read_locs(L), seen.

% separate list into two.

ls([], [], []).
ls([A|D], [B|E], [A, B|C]) :- ls(D, E, C).

% part one

% total distance.

total_distance([], [], 0).
total_distance([X|A], [Y|B], C) :-
	D is abs(X - Y), total_distance(A, B, E), C is D + E.

partone(F, D) :- locations(F, L), ls(X, Y, L), msort(X), msort(Y), total_distance(X, Y, D).

% part two

occurances(_, [], 0).
occurances(X, [X|T], Z) :- occurances(X, T, Y), Z is 1 + Y.
occurances(X, [_|T], Z) :- occurances(X, T, Z).

similarity(X, Y, Z) :- occurances(X, Y, A), Z is X * A.

similarity_score([], _, 0).
similarity_score([H|T], X, Z) :- similarity(H, X, C), similarity_score(T, X, D), Z is C + D.

parttwo(F, D) :- locations(F, L), ls(X, Y, L), similarity_score(X, Y, D).
