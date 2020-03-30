-- Testing basic structure of the PL/SQL block
<<block_label>>
declare
    -- Comment can
    /* be where ever
    and span
    multiple lines   */
begin
    /* Also they can be
    -- nested inside
    another comment */
end;

begin
end;

-- Empty block with empty exception handler
begin
    null;
    exception
        when others then
            null;
end;

-- Testing several handlers
begin
    null;
    exception
        when dup_val_on_index or no_data_found then
            null;
        when others then
            null;
end;



