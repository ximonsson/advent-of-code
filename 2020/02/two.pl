%
% Day 2: Password Philosophy
% https://adventofcode.com/2020/day/2
%

% count occurrences in list/string
count(_, [], 0).
count(C, [H|T], N) :- C \= H, count(C, T, N).
count(C, [C|T], N) :- count(C, T, M), N is M + 1.

% check if password applies the policy
policy(Min, Max, Ch, Pwd) :- count(Ch, Pwd, N), N =< Max, N >= Min.

official_policy(I, J, C, P) :- nth(I, P, X), nth(J, P, Y), X \= Y, (X == C; Y == C).

% read password and policy
% TODO i hate this, is it not possible with grammar?
read_pwd(Min, Max, C, Pwd) :-
	read_token(Min),
	read_token(_),
	read_token(Max),
	get0(_),
	get0(C),
	read_token(_),
	read_token(P),
	atom_codes(P, Pwd),
	get_code(_). % newline

validate(Min, Max, C, P, 1) :- policy(Min, Max, C, P).
validate(_, _, _, _, 0).

% read a password and policy recursively, summing the valid ones.
valid_pwd(0) :- peek_code(C), C =:= -1, !.
valid_pwd(N) :-
	read_pwd(Min, Max, C, Pwd),
	validate(Min, Max, C, Pwd, X),
	valid_pwd(M),
	N is M + X.

main :- see('input'), valid_pwd(N), write(N), seen.
