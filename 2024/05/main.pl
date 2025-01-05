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

% is rule relevant for the update?
update_rule(U, rule(A, B)) :- memberchk(A, U), memberchk(B, U).

rules_pages([], []).
rules_pages([rule(A, B)|Rs], Ps) :- rules_pages(Rs, X), append([A, B], X, Ps).

% elegant but very slow...
make_correct(Rs, U, Up) :- permutation(U, Up), correct_order(Rs, Up).

make_correct_(Rs_, U, Uc) :-
	% get rules that apply to this update
	include(update_rule(U), Rs_, Rs),
	% get rules that it fails on, and the ones that it respects
	exclude(respect_rule(U), Rs, Rx), include(respect_rule(U), Rs, Ri),

	% pages for the respective set of rules
	rules_pages(Rx, Px), rules_pages(Ri, Pi),
	list_to_set(Px, Psx), list_to_set(Pi, Psi),

	writeln(Psx),
	writeln(Psi),

	% make a permutation of the update that keeps the sequence of pages
	% for the rules that it respects and re-orders the pages it fails on.
	permutation(Psx, Psxc), correct_order(Rx, Psxc),

	writeln(Psxc),

	permutation(U, Uc),
	subseq(Uc, Psxc, _),
	subseq(Uc, Psi, _),
	correct_order(Rs, Uc).


print_queue_2(F, N) :-
	phrase_from_file(inputfile(Rs, Us), F),
	exclude(correct_order(Rs), Us, Uis),
	apply(make_correct(Rs), Uis, Ucs),
	apply(middle, Ucs, Xs),
	sum_list(Xs, N).
