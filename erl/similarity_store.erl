-module(similarity_store).
-compile(export_all).

start() ->
    dets:open_file(?MODULE,[{file,"similarity.dets"}]), ok.
    
stop() ->
    dets:close(?MODULE), ok.

set({_,_}=Pair,Similarity) ->    
    dets:insert(?MODULE,{ensure_a_less_than_b(Pair),Similarity}).
  
get({_,_}=Pair) ->
    util:extract_value(dets:lookup(?MODULE,ensure_a_less_than_b(Pair))).
    
ensure_a_less_than_b({A,B}) when A<B -> {A,B};
ensure_a_less_than_b({A,B}) ->          {B,A}.

