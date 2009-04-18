-module(similarity_store).
-compile(export_all).
-include("records.hrl").
-include_lib("stdlib/include/qlc.hrl").

start() ->
    mnesia:start().
    
stop() ->
    mnesia:stop().

delete_all() ->
    start(),
    mnesia:clear_table(similarity).

bootstrap() ->
    mnesia:create_schema([node()]),    
    start(),
    mnesia:create_table(similarity, 
			[{attributes, record_info(fields, similarity)}, 
			{type,set}, 
			{disc_copies, [node()]}]).

set({Id1,Id2},Similarity) when Id1 > Id2 ->    
    set({Id2,Id1},Similarity);
set({Id1,Id2},Similarity) ->
    R = #similarity{idPair={Id1,Id2},similarity=Similarity},
    %mnesia:transaction(fun() -> mnesia:write(R) end).
    mnesia:dirty_write(R).
  
get({Id1,Id2}) when Id1 > Id2 ->
    similarity_store:get({Id2,Id1});
get({Id1,Id2}) ->
    %{atomic,Result} = mnesia:transaction(fun() -> mnesia:read(similarity, {Id1,Id2}, read) end),
    Result = mnesia:dirty_read(similarity, {Id1,Id2}),
    case length(Result) of
	0 -> record_not_found;
	_ -> (hd(Result))#similarity.similarity
    end.	     
    

