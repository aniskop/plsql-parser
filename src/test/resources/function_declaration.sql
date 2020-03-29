declare
    my_var number;
    function my_func return number;
    /*
     *  This is comment for the function
    */
    function my_func(param1 in varchar2) return number; -- some more comment

    -- Another one single-line comment
    function my_func(param1 in varchar2, p2 out number, p3 in out nocopy clob, p_out_collection out nocopy t_my_type) return number;
    function my_func(p1 number := 10, p2 pls_integer default 256) return pls_integer
        pipelined parallel_enable deterministic result_cache;
    function my_func(p1 number := 10, p2 pls_integer default 256) return pls_integer deterministic;
begin
end;