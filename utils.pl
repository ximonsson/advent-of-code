
:- set_prolog_flag(double_quotes, codes).
:- use_module(library(dcg/basics)).

% find pattern

ignore --> [].
ignore --> [_], ignore.

rest(L, L, []).

match(Pattern) --> ignore, string(Pattern), rest(_).

% lines

lines([L|Ls]) --> line(L), "\n", !, lines(Ls).
lines([]) --> [].

line([]) --> [].
line([H|T]) --> [H], line(T).

% all same

all([], _).
all([H|T], H) :- all(T, H).
all([H|T]) :- all(T, H).

% head - first

head([H|_], H).

% tail

tail([], []).
tail([_|T], T).

% take

take(0, _, []).
take(N, [H|T0], [H|T1]) :- N1 is N - 1, take(N1, T0, T1).

% drop

drop(0, L, L).
drop(N, [_|T0], T1) :- N1 is N - 1, drop(N1, T0, T1).

% apply function

apply(_, [], []).
apply(P, [H|T], [H1|T1]) :- call(P, H, H1), apply(P, T, T1).

% repeat element to make list

repeate(0, _, []).
repeate(N, E, [E|T]) :- N > 0, N0 is N - 1, repeate(N0, E, T).

% replace at index

replace0(I, E, L, L0) :- take(I, L, H), drop(I + 1, L, T), append(H, [E|T], L0).
% replace in range
replace0(I0, I1, E, X, Y) :-
	take(I0, X, X0),
	drop(I1, X, X1),
	N is I1 - I0,
	repeate(N, E, Es),
	append([X0, Es, X1], Y).

% transpose
% OBS not making sure all lists are the same length.
% TODO should try and do this using `foldl`.

transpose([H|_], []) :- length(H, 0).
transpose(Ls, [T|Ts]) :- apply(head, Ls, T), apply(tail, Ls, Ts0), transpose(Ts0, Ts).

