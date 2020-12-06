%
% Day 2: Password Philosophy
% https://adventofcode.com/2020/day/2
%

% count occurrences in list/string
count(_, [], 0).
count(C, [C|T], N) :- count(C, T, M), N is M + 1.
count(C, [_|T], N) :- count(C, T, N).

% check if password applies the policy
policy(Min, Max, Ch, Pwd) :- count(Ch, Pwd, N), N =< Max, N >= Min.

% read password and policy
% TODO i hate this, is it not possible with grammar?
read_pwd(Min, Max, C, Pwd) :-
	read_token(Min),
	read_token(_),
	read_token(Max),
	read_token(C),
	read_token(_),
	read_token(Pwd).

write_pwd(Min, Max, C, Pwd) :- write(Min), write('-'), write(Max), write(' '), write(C), write(':'), write(Pwd), nl.

valid_pwd(end_of_file, _, _, _, _).
valid_pwd(Min, Max, C, Pwd, 0) :- \+ policy(Min, Max, C, Pwd), write_pwd(Min, Max, C, Pwd).
valid_pwd(Min, Max, C, Pwd, 1) :- policy(Min, Max, C, Pwd).

% read a password and policy and add if valid
valid_pwd(0) :- at_end_of_stream, !.
valid_pwd(N) :-
	read_pwd(Min, Max, C, Pwd),
	valid_pwd(Min, Max, C, Pwd, N),
	valid_pwd(M), N is M + N.

main :- see('input'), valid_pwd(N), write(N), nl, seen.
