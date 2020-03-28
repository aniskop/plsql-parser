declare
    type nested_table is table of number;
    type nested_table is table of varchar2(4000);
    type nested_table is table of number(11,2);
    type "Nested table 123" is table of "Customer type";
    
    type associative_array is table of number index by varchar2(200);
    type associative_array is table of varchar2(50) index by pls_integer;
    type associative_array is table of c_my_customers%rowtype index by pls_integer;

    type record_type is record
    (
        field1 number,
        field2 varchar2(20),
        field3 r_medium%rowtype,
        field4 r_medium%type not null,
        field5 number default 10
    );
begin
end;