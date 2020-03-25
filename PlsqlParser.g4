parser grammar PlsqlParser;

options { tokenVocab=PlsqlLexer; }

plsql_block
    : label? DECLARE declare_section? body SEMICOLON
    ;

label
    : LABEL_BEGIN name LABEL_END
    ;

declare_section
//TODO: type definition
//TODO: cursor declaration
//TODO: item_declaration (collection var, record variable (type.column)
//TODO: function declaration
//TODO: procedure declaration
//TODO: cursor definition
//TODO: function definition
//TODO: procedure definition
    : DECLARE
    (
        subtype_definition
        | type_definition
        | exception_declaration
        | constant_declaration
        | variable_declaration
    )*
    ;

//TODO: record type def
// Make subtype definition separate although in Oracle docs it falls under type_definition.
// This way parse tree and reading type name is more consistent:
// subtype_definition.name instead of type_definition.subtype_definition.name.
type_definition
    : TYPE name IS
    (
        collection_type_definition
        | ref_cursor_type_definition
        | record_type_definition
    ) SEMICOLON
    ;

ref_cursor_type_definition
    : REF CURSOR return_clause?
    ;

record_type_definition
    : RECORD L_PAREN field_definition (COMMA field_definition)* R_PAREN
    ;

//TODO: implement default value
field_definition
    : name plsql_datatype not_null_constraint? (DEFAULT | ASSIGNMENT)?
    ;

// Begin: collection types
collection_type_definition
    : (assoc_array_type_definition | varray_type_definition | nested_table_type_definition)
    ;

assoc_array_type_definition
    // Do not restrict INDEX BY to valid datatypes
    // to make parser simpler and prevent crashing on invalid datatypes.
    : TABLE OF plsql_datatype not_null_constraint? INDEX BY plsql_datatype
    ;

varray_type_definition
    : (VARRAY | (VARYING? ARRAY)) L_PAREN DECIMAL_NUMBER R_PAREN OF plsql_datatype not_null_constraint?
    ;

nested_table_type_definition
    : TABLE OF plsql_datatype not_null_constraint?
    ;

// End: collection types

// Begin: subtype
subtype_definition
    : SUBTYPE name IS plsql_datatype (subtype_constraint | character_set)? not_null_constraint? SEMICOLON
    ;

subtype_constraint
    : (DECIMAL_NUMBER (COMMA DECIMAL_NUMBER)?) | (RANGE DECIMAL_NUMBER RANGE_OP DECIMAL_NUMBER)
    ;

character_set
    : CHARACTER SET character_set_name
    ;

character_set_name
    //TODO: separate regexp. charset has no spaces and has dots allowed
    : IDENTIFIER
    ;
// End: subtype

//TODO: expression

// Begin: item declaration
constant_declaration
    : name CONSTANT plsql_datatype not_null_constraint? (ASSIGNMENT | DEFAULT) SEMICOLON
    ;

variable_declaration
    : name plsql_datatype not_null_constraint? SEMICOLON
    ;

exception_declaration
    : name EXCEPTION SEMICOLON
    ;
// End: item declaration

body
    : BEGIN .*? (EXCEPTION)? END
    ;

// Begin: common things
return_clause
    : RETURN plsql_datatype
    ;

not_null_constraint
    : NOT NULL
    ;

plsql_datatype
    // TODO: implement table.column%type
    : IDENTIFIER (L_PAREN DECIMAL_NUMBER (COMMA DECIMAL_NUMBER)? R_PAREN)? (ROWTYPE_ATTRIBUTE | TYPE_ATTRIBUTE)?
    ;
name
    : IDENTIFIER
    ;
// End: common things