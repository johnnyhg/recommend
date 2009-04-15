-module(movie_data).
-export([start/0,stop/0,ids/0,title/1,ratings/1,populate_tables/0]).
%-compile(export_all).

-define(TITLES,  "movie_titles").
-define(RATINGS, "movie_ratings").
-define(PATH,    "/home/mat/dev/recommend/test_data_tiny").

start() ->
    dets:open_file(?TITLES, [{file,"movie_titles.dets"}]),
    dets:open_file(?RATINGS,[{file,"movie_ratings.dets"}]),
    ok.

stop() ->
    dets:close(?TITLES),
    dets:close(?RATINGS),
    ok.
    
ids() -> 
    % dets annoying wraps even set matches in a list
    [ Id || [{Id,_Name}] <- dets:match(?TITLES, '$1')].

title(Id) -> 
    util:extract_value(dets:lookup(?TITLES, Id)).

ratings(Id) -> 
    util:extract_value(dets:lookup(?RATINGS, Id)).

populate_tables() ->
    write_movie_titles(),
    write_movie_ratings().

write_movie_titles() ->
    {ok,B} = file:read_file(?PATH ++ "/movie_titles.txt"),
    Lines = string:tokens(binary_to_list(B), "\n"),
    lists:foreach(
      fun(Line) ->
	      [Id,_Year,Name] = string:tokens(Line,","),
	      dets:insert(?TITLES, {list_to_integer(Id),Name})
      end, 
      Lines).

write_movie_ratings() ->
    lists:foreach(
      fun(Id) -> write_movie_rating(Id) end,
      ids()
     ).
    
write_movie_rating(MovieId) -> 
    Filename = ?PATH ++ "/training_set/mv_" ++ padded(MovieId,7) ++ ".txt",
    io:format("file is ~p~n",[Filename]),
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
        
