%%%-------------------------------------------------------------------
%%% @author jaspreet.chhabra
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Sep 2024 2:52 AM
%%%-------------------------------------------------------------------
-module(csv_to_json).
-author("jaspreet.chhabra").

%% API

-export([csv_to_json/0]).

% Function to convert CSV to JSON
csv_to_json() ->
  AppName = csv_json,  % Replace 'myapp' with your application name
  PrivDir = code:priv_dir(AppName),
  FilePath = filename:join(PrivDir, "example.csv"),
  {ok, BinaryData} = file:read_file(FilePath),
  {ok, CsvData} = erl_csv:decode(BinaryData),
  Headers = hd(CsvData), % First row as headers
  Rows = tl(CsvData),    % Remaining rows are data
  JsonRows = lists:map(fun(Row) -> convert_row(Headers, Row) end, Rows),
  Json = jsx:encode(JsonRows, [indent]),
  json_to_map(Json).

% Function to convert a row of CSV data to a map
convert_row(Headers, Row) ->
  lists:foldl(fun({Key, Value}, Acc) ->
    maps:put(binary_to_atom(Key, utf8), Value, Acc)
              end, #{}, lists:zip(Headers, Row)).

json_to_map(JsonString) ->
  jsx:decode(JsonString, [return_maps]).
