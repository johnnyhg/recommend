-module(file_util).
-export([apply_to_lines/2]).
%-compile(export_all).

% stream based execution of applying function
% per line. doesn't require entire file to have
% been read in before running function against
% first line

apply_to_lines(Filename,Fun) ->
    {ok,Handle} = file:open(Filename,[read,binary]),
    apply_to_lines(Handle,Fun,next_chunk(Handle)).

apply_to_lines(_Handle,_Fun,<<>>) ->
    done;

apply_to_lines(Handle,Fun,Data) ->
    NextLine = next_line_b(Data),
    case NextLine of
	{ incomplete_line, Collected } ->
	    MoreData = list_to_binary([Collected,next_chunk(Handle)]),
	    apply_to_lines(Handle,Fun,MoreData);
	{ complete_line, Collected, Rest } ->
	    Fun(binary_to_list(Collected)),
	    case size(Rest) of
		0 -> apply_to_lines(Handle,Fun,next_chunk(Handle));
		_ -> apply_to_lines(Handle,Fun,Rest)
	    end
    end.


next_chunk(F) ->
    case file:read(F,1024) of
	eof ->       <<>>;
	{ok,Data} -> Data
    end.

next_line_b(Binary) ->
    next_line_b(Binary, []).

next_line_b(<<>>, Collected) ->
    { incomplete_line, convert(Collected) };

next_line_b(<<"\n",Rest/binary>>, Collected) ->  
    { complete_line, convert(Collected), Rest };

next_line_b(<<C:1/binary,Rest/binary>>, Collected) ->
    next_line_b(Rest, [C|Collected]). 

convert(Collected) ->
    list_to_binary(lists:reverse(Collected)).
