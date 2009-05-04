-module(similarity).
-export([start/0, stop/0, reset/0, get/2, is_cached/2, calc_all_for/1]).
%-compile(export_all).

start() ->
    similarity_store:start(),
    movie_data:start().

stop() ->
    similarity_store:stop(),
    movie_data:stop().

reset() ->    
    similarity_store:delete_all(),
    movie_data:delete_all(),
    movie_data:write_movie_ratings().
    
get(M1,M2) ->
    get(M1,M2,fun() -> movie_data:ratings(M1) end).
		     
get(M1,M2,M1RatingsEval) ->
    Similarity = similarity_store:get({M1,M2}),
    case Similarity of
	record_not_found ->
	    %io:format("~p ~p ~p not cached~n",[self(),M1,M2]),
	    Ratings2 = movie_data:ratings(M2),
	    Calculated = coeff:pearson(M1RatingsEval(), Ratings2),
	    similarity_store:set({M1,M2},Calculated),
	    Calculated;
	_ ->
	    %io:format("~p ~p ~p cached~n",[self(),M1,M2]),
	    Similarity
    end.

is_cached(M1,M2) ->
    Similarity = similarity_store:get({M1,M2}),
    case Similarity of
	record_not_found -> false;
	_ -> true
    end.

calc_all_for(Mid) ->	        
    Start = now(),
    start(),
    M1Ratings = movie_data:ratings(Mid),
    lists:foreach(
      fun(OtherId) -> get(Mid,OtherId,fun() -> M1Ratings end) end,
      movie_data:ids()
      %lists:sublist(movie_data:ids(),5000)
     ),
    stop(),
    io:format("done for ~p in ~p secs \n",[Mid,timer:now_diff(now(),Start)/1000/1000]).

	    


	    

