:- [utils].


rules([R|Rs]) --> rule_(R), "\n", rules(Rs).
rules([]) --> "\n".

rule_(rule(B, A)) --> integer(B), "|", integer(A).

updates([U|Us]) --> update(U), "\n", updates(Us).

