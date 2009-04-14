-module(data).
%-export([to_list/1, to_dict/1, to_dict_from_binary/1, to_dict_b/1, test/1]).
-compile(export_all).

-define(PATH,"/home/mat/dev/recommend/test_data_tiny").

% dict from NetflixId -> Name 
movie_titles() ->
    {ok,B} = file:read_file(?PATH ++ "/movie_titles.txt"),
    Lines = string:tokens(binary_to_list(B), "\n"),
    ConvertALine = fun([Id,_Year,Name]) -> { list_to_integer(Id), Name } end,  
    LinesSplit = [ ConvertALine(split_on_comma(X)) || X <- Lines ],
    dict:from_list(LinesSplit).

% [ {Uid,Rating}, {Uid,Rating} ... ]
movie_ratings(MovieId) ->
    Filename = ?PATH ++ "/training_set/mv_" ++ padded(MovieId,7) ++ ".txt",
    %io:format("file is ~p~n",[Filename]),
    {ok,B} = file:read_file(Filename),    
    Lines = string:tokens(binary_to_list(B), "\n"),
    ConvertALine = fun([Id,Rating,_Date]) -> { list_to_integer(Id), list_to_integer(Rating) } end,
    [ ConvertALine(split_on_comma(X)) || X <- Lines ].

split_on_comma(Line) ->    
    string:tokens(Line,",").

padded(Text,N) when is_integer(Text) ->
    padded(integer_to_list(Text),N);
padded(Text,N) when length(Text) >= N ->
    Text;
padded(Text,N) ->
    padded("0"++Text,N).
     


