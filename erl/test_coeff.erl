-module(test_coeff).
-include_lib("eunit/include/eunit.hrl").

same_data_test() ->
    A = [ {0,2}, {1,3}, {2,7}, {3,8} ],
    ?assertEqual(1.0, coeff:pearson(A,A)).

grade_inflated_simple_test() ->
    A = [ {0,2}, {1,3}, {2,7}, {3,8} ],
    B = [ {0,3}, {1,4}, {2,8}, {3,9} ],
    ?assertEqual(1.0, coeff:pearson(A,B)).

grade_inflated_complex_test() ->
    A = [ {0,12}, {1,3},  {5,27}, {7,18} ],
    B = [ {0,3},  {1,14}, {5,8},  {7,29} ],
    assertClose(0.017, coeff:pearson(A,B), 0.001).

when_indexes_are_all_different_test() ->
    A = [ {0,12}, {2,3},  {4,27}, {6,18} ],    
    B = [ {1,3},  {3,14}, {5,8},  {7,29} ],
    ?assertEqual(0.0, coeff:pearson(A,B)).    
    
when_two_lists_have_different_indexes_1_test() ->
    A = [ {0,4}, {1,2}, {2,12}, {3,3},  {4,27}, {5,18} ],
    B = [               {2,3},  {3,14}, {4,8},  {5,29}, {6,5}, {7,8} ],
    assertClose(0.017, coeff:pearson(A,B), 0.001).    

when_two_lists_have_different_indexes_2_test() ->
    A = [               {2,12}, {3,3},  {4,27}, {5,18}, {8,7}, {10,2} ],
    B = [ {0,3}, {1,4}, {2,3},  {3,14}, {4,8},  {5,29} ],
    assertClose(0.017, coeff:pearson(A,B), 0.001).    

assertClose(A,B,Delta) ->
    ?assert(abs(A-B) < Delta).
    
