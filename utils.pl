% I insist on using GNU prolog that has much less convenience functions
% than for example SWI prolog. I therefore need to create my own as good
% practice.

% Grammar helpers
% ---

% integer - list of digits.

integer(I) --> digit(D0), digits(D), { number_chars(I, [D0|D]) }.

digits([]) --> [].
digits([D|T]) --> digit(D), !, digits(T).

digit(D) --> [D], { char_code(D, C), between(48, 57, C) }.

% I/O
% ---

% read file content as list of chars

read_input([]) :- at_end_of_stream, !.
read_input([H|T]) :- get_char(H), read_input(T).
read_input(F, In) :- see(F), read_input(In), seen.

% apply phrase on file content

phrase_from_file(Ph, F) :- read_input(F, Chars), phrase(Ph, Chars).
