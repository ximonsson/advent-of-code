%
% Day 1. Calorie Couting
% https://adventofcode.com/2022/day/1
%

elf([], []).
elf([A|B], [H|T]) :- sum_list(A, H), elf(B, T).

%readint(X, 0, L, L) :- \+ number(X), !.
%readint(X, Acc, [T|Others], [[X|T]|Others]) :- number(X).

readint(Tok, Acc, L, 0, [Acc|L]) :- \+ number(Tok).
readint(Tok, Acc, L, X, L) :- number(Tok), X is Acc + Tok.

read_list(_, []) :- at_end_of_stream, !.
read_list(Acc, L) :- read_token(Tok), readint(Tok, Acc, T, X, L), read_list(X, T).

% read all lines into L from file F
calories(F, L) :- see(F), read_list(0, L), seen.

main(L) :- calories('input', L).
