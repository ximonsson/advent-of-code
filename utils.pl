
% find pattern

ignore --> [_], ignore.
ignore --> [].

match(Pattern) --> ignore, Pattern, ignore.

% all same

all([], _).
all([H|T], H) :- all(T, H).
all([H|T]) :- all(T, H).

% head - first

head([H|_], H).

% tail

tail([], []).
tail([_|T], T).

% apply function

apply(_, [], []).
apply(P, [H|T], [H1|T1]) :- call(P, H, H1), apply(P, T, T1).

% transpose
% OBS not making sure all lists are the same length.
% TODO should try and do this using `foldl`.

transpose([H|_], []) :- length(H, 0).
transpose(Ls, [T|Ts]) :- apply(head, Ls, T), apply(tail, Ls, Ts0), transpose(Ts0, Ts).

