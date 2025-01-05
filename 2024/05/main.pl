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

% rules
% ---

% does the update respect the rule?

% if A comes before B.
% if we fail checking index it means that either A or B is not in the update and then
% the rule is valid.
respect_rule(U, rule(A, B)) :- (nth0(I0, U, A), nth0(I1, U, B)) -> I0 < I1; true.

% does the update respect all rules?
correct_order(Rs, U) :- maplist(respect_rule(U), Rs).

% print queue part I
% ---

% middle value, assuming length is odd
middle(U, M) :- length(U, L), I is L // 2 + 1, nth1(I, U, M).

print_queue(F, N) :-
	phrase_from_file(inputfile(Rs, Us), F),
	include(correct_order(Rs), Us, Ucs),
	apply(middle, Ucs, Xs),
	sum_list(Xs, N).


% part II
% ---

update_rule(U, rule(A, B)) :- memberchk(A, U), memberchk(B, U).

% elegant but very slow...
make_correct(Rs, U, Up) :- permutation(U, Up), correct_order(Rs, Up).

print_queue_2(F, N) :-
	phrase_from_file(inputfile(Rs, Us), F),
	exclude(correct_order(Rs), Us, Uis),
	apply(make_correct(Rs), Uis, Ucs),
	apply(middle, Ucs, Xs),
	sum_list(Xs, N).
