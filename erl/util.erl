-module(util).
-export([extract_value/1,split/2]).
%-compile(export_all).

extract_value(Record) ->
    case length(Record) of
	0 -> 
	    record_not_found;
	_ ->
	    [{_Key,Value}] = Record,
	    Value
    end.

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





