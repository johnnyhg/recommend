-module(util).
-export([extract_value/1,split/2,parallel_eval_in_chunks/4,apply_all/3,next_line/1]).
%-compile(export_all).

extract_value(Record) ->
    case length(Record) of
	0 -> 
	    record_not_found;
	_ ->
	    [{_Key,Value}] = Record,
	    Value
    end.

% apply Module:Function to each elem of List run across NumChunks processes 
% NumChunks << length(List)
parallel_eval_in_chunks(Module,Function,NumChunks,List) ->
    Chunks = split(List,NumChunks),  
    %io:format("split ~w\n",[Split]),
    Calls = [ {?MODULE,apply_all,[Module,Function,Chunk]} || Chunk <- Chunks ],
    rpc:parallel_eval(Calls).

apply_all(Module,Function,List) ->
    lists:foreach(fun(X) -> apply(Module,Function,[X]) end, List).  

% split List into N chunks
split(List,N) -> 
    Chunks = [ [] || _X <- lists:seq(1,N)],
    split(List,Chunks,[]).
split([],Chunks,Acc) ->
    Chunks ++ Acc;
split(List,[],Acc) ->
    split(List,Acc,[]);
split([H|T],[CH|CT],Acc) ->
    split(T,CT,[[H|CH]|Acc]).

next_line(Binary) ->
    next_line(Binary, []).
next_line(<<>>, _Collected) ->
    ignore_last_line_if_didnt_end_in_newline;
next_line(<<"\n",Rest/binary>>, Collected) ->  
    { Rest, binary_to_list(list_to_binary(lists:reverse(Collected))) }; % black magic voodoo line
next_line(<<C:1/binary,Rest/binary>>, Collected) ->
    next_line(Rest, [C|Collected]). 





