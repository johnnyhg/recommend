-module(movie_data).
-export([start/0,stop/0,ids/0,reset_ids/0,ratings/1,populate_tables/0,
	 write_movie_rating/1]).
%-compile(export_all).
-include_lib("consts.hrl").

start() ->
    dets:open_file(?TITLES, [{file,"movie_titles.dets"}]),
    dets:open_file(?RATINGS,[{file,"movie_ratings.dets"}]),
    ok.

stop() ->
    dets:close(?TITLES),
    dets:close(?RATINGS),
    ok.

reset_ids() ->
    start(),
    dets:delete_all_objects(?TITLES),
    write_movie_ids(),
    io:format("~w~n",[length(ids())]),
    stop().

populate_tables() ->
    start(),
    write_movie_ids(),
    write_movie_ratings(),
    stop().
    
ids() -> 
    % dets annoying wraps even set matches in a list
    [ Id || [{Id}] <- dets:match(?TITLES, '$1')].

ratings(Id) -> 
    util:extract_value(dets:lookup(?RATINGS, Id)).


write_movie_ids() ->
    {ok,B} = file:read_file(?PATH ++ "/movie_titles.txt"),
    Lines = string:tokens(binary_to_list(B), "\n"),
    lists:foreach(
      fun(Line) ->
	      Tokens = string:tokens(Line,","),
	      Id = hd(Tokens),
	      dets:insert(?TITLES, {list_to_integer(Id)})
      end, 
      Lines).


% rating files across NumProcesses processes 
write_movie_ratings() ->
    % lists:foreach(fun(Id) -> write_movie_rating(Id) end, ids()). % serial
    % rpc:pmap({?MODULE,write_movie_rating}, [], ids()).           % pure pmap    
    util:parallel_eval_in_chunks(?MODULE,write_movie_rating,?PROCS,ids()).
    
write_movie_rating(MovieId) -> 
    Filename = ?PATH ++ "/training_set/mv_" ++ padded(MovieId,7) ++ ".txt",
    %io:format("file is ~p~n",[Filename]),
    {ok,B} = file:read_file(Filename),    
    Lines = string:tokens(binary_to_list(B), "\n"),
    ConvertALine = fun([UserId,Rating,_Date]) -> { list_to_integer(UserId), list_to_integer(Rating) } end,
    Ratings = [ ConvertALine(split_on_comma(X)) || X <- Lines ],
    dets:insert(?RATINGS, {MovieId, Ratings}).
  
split_on_comma(Line) ->    
    string:tokens(Line,",").
  
padded(Text,N) when is_integer(Text) ->
    padded(integer_to_list(Text),N);
padded(Text,N) when length(Text) >= N ->
    Text;
padded(Text,N) ->
    padded("0"++Text,N).
        
