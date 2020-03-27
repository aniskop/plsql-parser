declare
    subtype my_sybtype is number range 1..16;
    subtype my_sybtype is number range 1..16 not null;
    subtype my_subtype is varchar2 character set AL32UTF8;
    subtype amount is number(11,2);
begin
end;