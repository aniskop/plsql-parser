parser grammar PlsqlParser;

options { tokenVocab=PlsqlLexer; }

plsql_block
    : label? declare_section? body SEMICOLON
    ;

label
    : LABEL_BEGIN name LABEL_END
    ;

declare_section
    : DECLARE item_declaration+
    ;

item_declaration
    : (constant_declaration
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

body
    : BEGIN .*? exception_handler? END
    ;

exception_handler
    : EXCEPTION
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