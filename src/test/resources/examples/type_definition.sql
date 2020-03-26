declare
    type nested_table is table of number;
    type associative_array is table of number index by varchar2(200);
    type record_type is record (field1 number, field2 varchar2(20), field3 r_medium%rowtype);
begin
end;