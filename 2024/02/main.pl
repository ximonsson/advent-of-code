% https://adventofcode.com/2024/day/2

% read file

read_input([]) :- at_end_of_stream, !.
read_input([H|T]) :- get_char(H), read_input(T).
read_input(F, In) :- see(F), read_input(In), seen.


% grammar for parsing

reports([]) --> [].
reports([R|Rs]) --> levels(R), ['\n'], reports(Rs).

levels([]) --> [].
levels([L|Ls]) --> level(L), [' '], levels(Ls).
levels([L|[]]) --> level(L).

level(L) --> digit(D0), digits(D), { number_chars(L, [D0|D]) }.

digits([]) --> [].
digits([D|T]) --> digit(D), !, digits(T).

digit(D) --> [D], { char_code(D, C), between(48, 57, C) }.


% valid report

dir([_|[]], _) :- !.
dir([A, B|T], Prev) :- X is sign(B - A), X =:= Prev, dir([B|T], X).
dir([A, B|T]) :- X is sign(B - A), dir([B|T], X).

step_size([_|[]]) :- !.
step_size([A, B|T]) :- X is abs(A - B), between(1, 3, X), step_size([B|T]).

valid(R) :- dir(R), step_size(R).

filter_reports([], []) :- !.
filter_reports([R|Rs], [R|Vs]) :- valid(R), filter_reports(Rs, Vs).
filter_reports([R|Rs], Vs) :- \+ valid(R), filter_reports(Rs, Vs).


% part one

partone(F, N) :- read_input(F, Data), reports(Rs, Data, []), filter_reports(Rs, Vs), length(Vs, N).


% dampener

% old implementation, which is not so elegant.
damp_(H, _, T) :- append(H, T, R), valid(R), !.
damp_(H0, X, [H|T]) :- append(H0, [H|T], R), \+ valid(R), append(H0, [X], H1), damp_(H1, H, T).
damp_([H|T]) :- damp_([], H, T).

damp(R, X) :- member(X, R), select(X, R, R1), valid(R1).

filter_damp_reports([], []) :- !.
filter_damp_reports([R|Rs], [R|Vs]) :- valid(R), filter_damp_reports(Rs, Vs).
filter_damp_reports([R|Rs], [R|Vs]) :- \+ valid(R), damp(R, _), filter_damp_reports(Rs, Vs).
filter_damp_reports([_|Rs], Vs) :- filter_damp_reports(Rs, Vs).

parttwo(F, N) :- read_input(F, Data), reports(Rs, Data, []), filter_damp_reports(Rs, Vs), length(Vs, N).
