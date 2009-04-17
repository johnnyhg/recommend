-module(similarity).
-compile(export_all).

start() ->
    similarity_store:start(),
    movie_data:start().

stop() ->
    similarity_store:stop(),
    movie_data:stop().
    
get(M1,M2)->
    Similarity = similarity_store:get({M1,M2}),
    case Similarity of
	record_not_found ->
	    io:format("~p ~p ~p not cached~n",[self(),M1,M2]),
	    Ratings1 = movie_data:ratings(M1),
	    Ratings2 = movie_data:ratings(M2),
	    Calculated = coeff:pearson(Ratings1, Ratings2),
	    similarity_store:set({M1,M2},Calculated),
	    Calculated;
	_ ->
	    io:format("~p ~p ~p cached~n",[self(),M1,M2]),
	    Similarity
    end.

is_cached(M1,M2) ->
    Similarity = similarity_store:get({M1,M2}),
    case Similarity of
	record_not_found -> false;
	_ -> true
    end.

calc_all_for(Mid) ->	        
    start(),
    lists:foreach(
      fun(OtherId) -> get(Mid,OtherId) end,
      movie_data:ids()
     ),
    stop().
    
	    

