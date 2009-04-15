-module(util).
-compile(export_all).

extract_value(Record) ->
    case length(Record) of
	0 -> 
	    record_not_found;
	_ ->
	    [{_Key,Value}] = Record,
	    Value
    end.
