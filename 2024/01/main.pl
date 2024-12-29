lines([X|T1], [Y|T2]) --> line(X, Y), '\n', lines(T1, T2).

line(X, Y) --> n(X), '   ', n(Y).

n(N) --> integer(N).

