parser grammar PlsqlParser;

options { tokenVocab=PlsqlLexer; }

anonymous_block
    : label? declare_section? body SEMICOLON (NEWLINE SLASH)?
    ;

label
    : LABEL_BEGIN name LABEL_END
    ;

declare_section
    : DECLARE
    ;

body
    : BEGIN .*? exception_handler? END
    ;

exception_handler
    : EXCEPTION
    ;

name
    : IDENTIFIER
    ;