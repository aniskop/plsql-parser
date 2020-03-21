parser grammar PlsqlParser;

options { tokenVocab=PlsqlLexer; }

anonymous_block
    : label? declare_section? body SEMICOLON (NEWLINE SLASH)? EOF
    ;

label
    : LABEL_BEGIN name LABEL_END
    ;

declare_section
    : DECLARE item_declaration?
    ;

item_declaration
    : variable_declaration
    ;

variable_declaration
    //TODO: make not null parser rule?
    : name datatype (NOT NULL)? SEMICOLON
    ;

body
    : BEGIN .*? exception_handler? END
    ;

exception_handler
    : EXCEPTION
    ;

datatype
    //TODO:%rowtype, %type e.g. reference types
    : IDENTIFIER (ROWTYPE_ATTRIBUTE | TYPE_ATTRIBUTE)?
    ;
name
    : IDENTIFIER
    ;