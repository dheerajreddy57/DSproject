-module(project).
-export([main/0,create_process/0,for/3,for2/3]).
main() ->
  	Lst = [0.1,0.0,0.3,0.7],
 	Lst1 = lists:reverse(lists:sort(Lst)),
	Rho = 	for2(Lst1,0,0),
      	L = for(1, 4, fun() -> spawn( 'project',create_process,[] ) end ),
      	Map=maps:from_list(lists:zip(L,Lst1)),
      	lists:foreach(fun(A)-> A ! {map,Map,Rho} end,L),
      	io:format("~w~n",[Lst1]),
      	io:format("~w~n",[Map]).
  
   
create_process() ->
   	receive
       	{map,Map,Rho}->
           	Mp=Map,
           	io:format("~w~n",[Mp]),
io:format("~w~n",[Rho])
   	end,
   	Myval = rand:uniform(2) -1 .
   
	
for2([Ls|Lst1],Sum,Cnt) ->
        if  
Sum+Ls =< 0.9  ->  
			for2(Lst1,Sum+Ls,Cnt+1);
        	true -> 
			Cnt+1
 	  end.
  
for( N, N, F )  -> [F()];
for( I, N, F ) ->
     io:format("process created: ~w~n", [I] ),
     [F() | for(I+1, N, F)].
 
 
 
