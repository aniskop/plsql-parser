declare
    my_var number;
    my_var number not null;
    my_var varchar2(20) := null;
    my_var number default 10;
    my_var number default -10;
    my_exception exception;
    my_constant constant number default null;
    my_constant constant number := 10;
    my_constant constant number not null default 25;
    my_constant constant varchar2(300) default null;
    my_var c_rec;
    my_var c_rec%rowtype;
    my_var another_var%type;
begin
end;