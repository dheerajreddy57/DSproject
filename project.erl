-module(project).
-export([main/0,create_process/1,for/2]).

for(0,_) -> []; 

for(N,Term) when N > 0 -> 
   io:fwrite("Hello~n"), 
   [Term|for(N-1,Term)].

create_process(a) -> [].



main() ->
    A0 = array:new(10)
    spawn('project',create_process,[])