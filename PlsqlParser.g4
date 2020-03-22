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
    (item_declaration | type_definition)+
    ;

//TODO: collection type def
//TODO: record type def
//TODO: ref cursor type def
type_definition
    : subtype_definition
    | collection_type_definition
    ;

//TODO: varray
//TODO: nested
collection_type_definition
    : TYPE type_name IS (assoc_array_type_definition)+
    ;

assoc_array_type_definition
    // Do not restrict INDEX BY to valid datatypes
    // to make parser simpler and prevent crashing on invalid datatypes.
    : TABLE OF plsql_datatype not_null_constraint? INDEX BY plsql_datatype
    ;

type_name
    : IDENTIFIER
    ;

subtype_definition
    : SUBTYPE name IS plsql_datatype (subtype_constraint | character_set)? not_null_constraint?
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

item_declaration
    : (exception_declaration
    | constant_declaration
    | variable_declaration)
    SEMICOLON
    ;
//TODO: expression
constant_declaration
    : name CONSTANT plsql_datatype not_null_constraint? (ASSIGNMENT | DEFAULT)
    ;

variable_declaration
    : name plsql_datatype not_null_constraint?
    ;

exception_declaration
    : name EXCEPTION
    ;

body
    : BEGIN .*? (EXCEPTION)? END
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