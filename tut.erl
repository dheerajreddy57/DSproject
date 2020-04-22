-module(tut).

-export([double/1]).
-export([fac/1,mult/2]).
-export([convert_length/1]).
-export([start/0, say_something/2]).

say_something(What, 0) ->
    done;
say_something(What, Times) ->
    io:format("~p~n", [What]),
    say_something(What, Times - 1).

start() ->
    spawn(tut, say_something, [hello, 3]),
    spawn(tut, say_something, [goodbye, 3]).
convert_length({centimeter, X}) ->
    {inch, X / 2.54};
convert_length({inch, Y}) ->
    {centimeter, Y * 2.54}.
fac(1) ->
    1;
fac(N) ->
    N * fac(N - 1).

double(X) ->
    2 * X.


mult(X, Y) ->
    X * Y.