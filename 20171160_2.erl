-module('20171160_2').
-export([main/1, merge_sort/1, process_merge_sort/2, merge_sort_pid/3,file_write_list/2,sep/2]).

main(Args) ->
	[Input_file_path, Output_file_path]= Args,
	{ _ , Input_file} = file:open(Input_file_path, [read]),
	{ _, Input_read} = file:read(Input_file, 1024*1024),
	[Input_line] = string:tokens(Input_read, "\n"),
	Given_array = [list_to_integer(X) || X<- string:tokens(Input_line," ")],
	file:close(Input_file),
	Procs_limit = 8,
    if length(Given_array) < 2 -> Sorted_array = Given_array;
		true ->	Sorted_array = process_merge_sort(Given_array,Procs_limit)
	end,
	{ _ , Output_file} = file:open(Output_file_path, [write]),
	file_write_list(Sorted_array,Output_file),
	file:close(Output_file).

file_write_list([],Output_file) -> 	io:fwrite(Output_file,"~n");
file_write_list([X],Output_file) ->  io:fwrite(Output_file,"~p~n",[X]);

file_write_list([H|T],Output_file) -> 	
	io:fwrite(Output_file,"~p ",[H]),
	file_write_list(T,Output_file).
sep(Input, 0) ->  {[], Input};
sep([H|T],N) -> {Lleft, Lright} = sep(T,N-1), {append([H],Lleft), Lright}.   

append(Input_1,Input_2) -> Input_1++Input_2.


merge(Input_1,Input_2) -> merge(Input_1,Input_2,[]).
merge([], [], Sorted_array) -> Sorted_array;
merge([], List_2, Sorted_array) -> append(Sorted_array, List_2);
merge(List_1, [], Sorted_array) -> append(Sorted_array, List_1);
merge([H1|List_1], [H2|List_2], Sorted_array) ->
	if 	H1 < H2 ->
			merge(List_1, [H2|List_2], append(Sorted_array, [H1]));
		true ->	
			merge([H1|List_1], List_2, append(Sorted_array, [H2]))
	end.	

merge_sort([]) -> [];
merge_sort([X]) -> [X];
merge_sort(Input) -> {Input_1, Input_2} = sep(Input, length(Input) div 2), merge(merge_sort(Input_1), merge_sort(Input_2)).



recieve_list(Pid) -> 
	receive
		{Pid, Input} -> Input
	end.

process_merge_sort(Input,Procs_limit) ->
	Pid = spawn('20171160_2', merge_sort_pid, [self(), Input,Procs_limit]),
    recieve_list(Pid).

merge_sort_pid(Pid, Input,Procs_limit) when Procs_limit < 2 -> Pid ! {self(), merge_sort(Input)};
merge_sort_pid(Pid, Input,Procs_limit) -> 
	{Lleft, Lright} = sep(Input, length(Input) div 2),
    Pid1 = spawn('20171160_2', merge_sort_pid, [self(), Lleft,Procs_limit div 2]),
    Pid2 = spawn('20171160_2', merge_sort_pid, [self(), Lright,Procs_limit div 2]),
    Input_1 = recieve_list(Pid1),
    Input_2 = recieve_list(Pid2),
    Pid ! {self(), merge(Input_1,Input_2)}. 