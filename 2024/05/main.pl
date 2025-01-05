:- [utils].

% grammar
% ---

% rules

rules([R|Rs]) --> rule_(R), "\n", !, rules(Rs).
rules([]) --> [].

rule_(rule(B, A)) --> integer(B), "|", integer(A).

% updates

updates([U|Us]) --> update(U), "\n", !, updates(Us).
updates([]) --> [].

update([P|Ps]) --> integer(P), ",", update(Ps).
update([P]) --> integer(P).

% entire file

inputfile(R, U) --> rules(R), "\n", updates(U).
