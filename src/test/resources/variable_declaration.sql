declare
    my_var number;
    my_var number not null;
    my_var varchar2(20) := null;
    my_var varchar2(20) := 'initial text';
    my_var varchar2(20) := 'initial multi
                            line
                            text';
    my_var number default 10;
    my_var number default -10;
    my_exception exception;
    my_constant constant number default null;
    my_constant constant number := 10;
    my_constant constant number not null default 25;
    my_constant constant varchar2(300) default 'it''s time';
    my_var c_rec;
    my_var c_rec%rowtype;
    my_var another_var%type;
    my_var my_table.my_column%type;
    my_var my_schema.my_table.my_column%type;
    my_var my_package.my_type;
begin
end;