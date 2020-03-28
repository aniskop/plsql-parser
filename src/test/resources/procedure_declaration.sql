declare
    my_var number;
    procedure my_proc;
    procedure my_proc(p1 in number := 10, p2 out varchar2, p3 in out nocopy t_object);
    procedure my_proc(p1 in date, p2 in varchar2 default null, p3 in number default 0);
    procedure my_proc(p_name in varchar2) accessible by (my_func);
    procedure my_proc(p_name in varchar2) accessible by (schema.my_func);
    procedure my_proc(p_name in varchar2) accessible by (function schema.my_func);
    procedure my_proc(p_name in varchar2) accessible by (function schema.my_func, trigger another_schema.my_name);
    procedure my_proc(p_name in varchar2) default collation using_nls_comp;
    procedure my_proc(p_name in varchar2) authid current_user;
    procedure my_proc(p_name in varchar2) authid definer;
    procedure my_proc(p_name in varchar2)
        accessible by (function schema.my_func)
        default collation using_nls_comp
        authid current_user;
begin
end;