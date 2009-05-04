-module(movie_data).
-export([start/0,stop/0,delete_all/0,ids/0,ratings/1,
	 write_movie_ratings/0,write_movie_rating/1]).
%-compile(export_all).
-include_lib("consts.hrl").

start() ->
    dets:open_file(?RATINGS,[{file,"movie_ratings.dets"}]), ok.

stop() ->
    dets:close(?RATINGS), ok.

delete_all() ->
    dets:delete_all_objects(?RATINGS), ok.

ids() -> 
    {ok,B} = file:read_file(?PATH ++ "/movie_titles.txt"),
    Lines = string:tokens(binary_to_list(B), "\n"),
    ParseLine = fun(Line) ->
			Tokens = string:tokens(Line,","),
			Id = hd(Tokens),
			list_to_integer(Id)
		end,
    [ ParseLine(Line) || Line <- Lines ].

ratings(Id) -> 
    util:extract_value(dets:lookup(?RATINGS, Id)).

% rating files across NumProcesses processes 
write_movie_ratings() ->
    start(),
    dets:delete_all_objects(?RATINGS),
    %lists:foreach(fun(Id) -> write_movie_rating(Id) end, ids()), % serial
    %rpc:pmap({?MODULE,write_movie_rating}, [], ids()),           % pure pmap    
    util:parallel_eval_in_chunks(?MODULE,write_movie_rating,?PROCS,ids()),
    stop().
    
write_movie_rating(MovieId) -> 
    Filename = ?PATH ++ "/training_set/mv_" ++ padded(MovieId,7) ++ ".txt",
    %io:format("file is ~p~n",[Filename]),
    {ok,B} = file:read_file(Filename),    
    Lines = string:tokens(binary_to_list(B), "\n"),
    ConvertALine = fun([UserId,Rating,_Date]) -> { list_to_integer(UserId), list_to_integer(Rating) } end,
    Ratings = [ ConvertALine(string:tokens(Line,",")) || Line <- Lines ],
    dets:insert(?RATINGS, {MovieId, Ratings}).
  
padded(Text,N) when is_integer(Text) ->
    padded(integer_to_list(Text),N);
padded(Text,N) when length(Text) >= N ->
    Text;
padded(Text,N) ->
    padded("0"++Text,N).
        
