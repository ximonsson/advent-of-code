% I insist on using GNU prolog that has much less convenience functions
% than for example SWI prolog. I therefore need to create my own as good
% practice.

% Grammar helpers
% ---

% integer - list of digits.

integer(I) --> digit(D0), digits(D), { number_codes(I, [D0|D]) }.

digits([]) --> [].
digits([D|T]) --> digit(D), !, digits(T).

digit(D) --> [D], { between(48, 57, D) }.

% I/O
% ---

% read file content as list of chars
%read_input(X) :- get_code(C), ( =/=(C, 10) -> X = [C|T]; X = T ), read_input(T).

read_input([]) :- at_end_of_stream, !.
read_input([H|T]) :- get_code(H), read_input(T).
read_input(F, In) :- see(F), read_input(In), seen.

% apply phrase on file content

phrase_from_file(Ph, F) :- read_input(F, Chars), phrase(Ph, Chars).
phrase_from_file(Ph, F, Rest) :- read_input(F, Chars), phrase(Ph, Chars, Rest).

% Lists
% ---
% Some helpers for lists

% include items from list that satisfy Goal.
include(_, [], []).
include(Goal, [H|T], I) :- ( call(Goal, H) -> I = [H|I1]; I = I1 ), include(Goal, T, I1).

% exclude items that do not satisfy Goal.
exclude(_, [], []).
exclude(Goal, [H|T], I) :- ( call(Goal, H) -> I = I1; I = [H|I1] ), exclude(Goal, T, I1).
