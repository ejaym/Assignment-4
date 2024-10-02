-module(server).
-export([start/0, main_loop/1, serv1/1, serv2/1, serv3/1, serv3/0]).

start() ->
    Serv3 = spawn(?MODULE, serv3, []),
    Serv2 = spawn(?MODULE, serv2, [Serv3]),
    Serv1 = spawn(?MODULE, serv1, [Serv2]),
    io:format("Servers started~n"),
    main_loop(Serv1).

main_loop(Serv1) ->
    timer:sleep(1000),
    io:format("Enter your Arguments:~n"),
    case io:read('') of
        {ok, all_done} ->
            Serv1 ! halt,
            io:format("Exiting main loop.~n"),
            ok;
        {ok, Term} ->
            Serv1 ! Term,
            main_loop(Serv1);
        eof ->
            io:format("End of file. Exiting.~n"),
            ok;
        {error, Reason} ->
            io:format("Error reading input: ~p~n", [Reason]),
            main_loop(Serv1)
    end.

serv1(Serv2) ->
    receive
        halt ->
            Serv2 ! halt,
            io:format("(serv1) Stopping.~n");
        {Op, X, Y} when Op == 'add', is_number(X), is_number(Y) ->
            Result = X + Y,
            io:format("(serv1) add(~p, ~p) = ~p~n", [X, Y, Result]),
            serv1(Serv2);
        {Op, X, Y} when Op == 'sub', is_number(X), is_number(Y) ->
            Result = X - Y,
            io:format("(serv1) sub(~p, ~p) = ~p~n", [X, Y, Result]),
            serv1(Serv2);
        {Op, X, Y} when Op == 'mult', is_number(X), is_number(Y) ->
            Result = X * Y,
            io:format("(serv1) mult(~p, ~p) = ~p~n", [X, Y, Result]),
            serv1(Serv2);
        {Op, X, Y} when Op == 'div', is_number(X), is_number(Y) ->
            Result = X / Y,
            io:format("(serv1) div(~p, ~p) = ~p~n", [X, Y, Result]),
            serv1(Serv2);
        {Op, X} when Op == 'neg', is_number(X) ->
            Result = -X,
            io:format("(serv1) neg(~p) = ~p~n", [X, Result]),
            serv1(Serv2);
        {Op, X} when Op == 'sqrt', is_number(X) ->
            Result = math:sqrt(X),
            io:format("(serv1) sqrt(~p) = ~p~n", [X, Result]),
            serv1(Serv2);
        Msg ->
            Serv2 ! Msg,
            serv1(Serv2)
    end.

serv2(Serv3) ->
    receive
        halt ->
            Serv3 ! halt,
            io:format("(serv2) Exiting.~n");
        [Head | Tail] when is_integer(Head) ->
            Numbers = [X || X <- [Head | Tail], is_number(X)],
            Sum = lists:sum(Numbers),
            io:format("(serv2) Sum of numbers: ~p~n", [Sum]),
            serv2(Serv3);
        [Head | Tail] when is_float(Head) ->
            Numbers = [X || X <- [Head | Tail], is_number(X)],
            Prod = lists:foldl(fun(X, Acc) -> X * Acc end, 1, Numbers),
            io:format("(serv2) Product of numbers: ~p~n", [Prod]),
            serv2(Serv3);
        Msg ->
            Serv3 ! Msg,
            serv2(Serv3)
    end.

serv3() ->
    serv3(0).

serv3(Count) ->
    receive
        halt ->
            io:format("(serv3) Exiting. Unprocessed messages: ~p~n", [Count]);
        {error, Msg} ->
            io:format("(serv3) Error: ~p~n", [Msg]),
            serv3(Count);
        Msg ->
            io:format("(serv3) Not handled: ~p~n", [Msg]),
            serv3(Count + 1)
    end.
