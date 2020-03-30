parser grammar PlsqlParser;

options { tokenVocab=PlsqlLexer; }

script
    : (comment | plsql_block)*
    ;

plsql_block
    : label? declare_section? body
    ;

label
    : LABEL_BEGIN name LABEL_END
    ;

//TODO: pragmas (each pragma has its specific locations inthe PL/SQL code):
//TODO: autonomous transaction
//TODO: coverage
//TODO: deprecate
//TODO: exception init
//TODO: inline
//TODO: restrict references
//TODO: serially reusable
//TODO: suppress warning 6009
//TODO: udf

declare_section
//TODO: cursor declaration
//TODO: cursor definition
//TODO: function definition
//TODO: procedure definition
    : DECLARE
    (
        comment
        | subtype_definition
        | type_definition
        | exception_declaration
        | constant_declaration
        | variable_declaration
        // Do not force that function declaration goes after variable declartion
        // to keep things simpler.
        | function_declaration
        | procedure_declaration
    )*
    ;

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

field_definition
    : name plsql_datatype not_null_constraint? default_value?
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

// Begin: item declaration
constant_declaration
    : name CONSTANT plsql_datatype not_null_constraint? default_value SEMICOLON
    ;

variable_declaration
    // Allow declare not null without default value to keep rule simpler
    : name plsql_datatype not_null_constraint? default_value? SEMICOLON
    ;

exception_declaration
    : name EXCEPTION SEMICOLON
    ;
// End: item declaration

function_declaration
    // Hints and clauses can go in any order. That's why using combination of alternative (|) and *
    : function_heading (deterministic_hint | pipelined_clause | parallel_clause | result_cache_clause )* SEMICOLON
    ;

function_heading
    : FUNCTION name ( L_PAREN parameter_declaration (COMMA parameter_declaration)* R_PAREN )? return_clause
    ;

parameter_declaration
    // Allow default value for out/inout params to keep rule and parse tree simpler
    : name parameter_mode? nocopy_hint? plsql_datatype default_value?
    ;

parameter_mode
    : OUT | IN OUT | IN
    ;

procedure_declaration
    : procedure_heading procedure_properties? SEMICOLON
    ;

procedure_heading
    : PROCEDURE name ( L_PAREN parameter_declaration (COMMA parameter_declaration)* R_PAREN )?
    ;

procedure_properties
    : ( accessible_by_clause | default_collation_clause | invoker_rights_clause) +
    ;

accessible_by_clause
    : ACCESSIBLE BY L_PAREN accessor (COMMA accessor)* R_PAREN
    ;

accessor
    : unit_kind? (schema DOT)? unit_name
    ;

unit_kind
    : (FUNCTION | PROCEDURE | PACKAGE | TRIGGER | TYPE)
    ;

unit_name
    : IDENTIFIER
    ;

default_collation_clause
    : DEFAULT COLLATION collation_option
    ;

collation_option
    : USING_NLS_COMP
    ;

invoker_rights_clause
    : AUTHID (CURRENT_USER | DEFINER)
    ;

body
    : BEGIN ( comment | plsql_statement )* ( EXCEPTION exception_handler+ )? END SEMICOLON
    ;

exception_handler
    : WHEN exception_name (OR exception_name)* THEN plsql_statement+
    ;

// OTHERS falls under this rule.
// It OTHERS will be introduces as a lexer rule, this will fail.
exception_name
    : IDENTIFIER
    ;

//TODO: assignment
//TODO: basic_loop
//TODO: case_statement
//TODO: close
//TODO: collection_method_call
//TODO: continue
//TODO: cursor for loop
//TODO: execute immediate
//TODO: exit
//TODO: fetch
//TODO: for loop
//TODO: forall
//TODO: goto
//TODO: if
//TODO: null
//TODO: open
//TODO: open for
//TODO: pipe_row
//TODO: plsql block
//TODO: procedure call
//TODO: raise
//TODO: return
//TODO: select into
//TODO: sql statement
//TODO: while loop
plsql_statement
    :
    (
        //TODO: change to null_statement
        null_statement
    ) SEMICOLON
    ;

null_statement
    : NULL
    ;

// Begin: common things
deterministic_hint
    : DETERMINISTIC
    ;

pipelined_clause
    : PIPELINED
    ;

parallel_clause
    : PARALLEL_ENABLE
    ;

result_cache_clause
    : RESULT_CACHE
    ;

return_clause
    : RETURN plsql_datatype
    ;

nocopy_hint
    : NOCOPY
    ;

not_null_constraint
    : NOT NULL
    ;

default_value
    : (ASSIGNMENT | DEFAULT) plsql_expression
    ;

// https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/expression.html#GUID-D4700B45-F2C8-443E-AEE7-2BD20FFD45B8
//TODO: boolean
//TODO: character
//TODO: collection constructor
//TODO: date
//TODO: numeric
//TODO: qualified
//TODO: searched case
//TODO: simple case
//TODO: ( expression )
plsql_expression
    : null_value
    | character_literal
    | boolean_literal
    | numeric_literal
    ;

plsql_datatype
    // For now scale, precision, %type, %rowtype are not parser rules because
    // there is no use case when such parser rules needed.
    : IDENTIFIER
    (
        // Examples: number(11), number(11,2), varchar2(4000)
        (L_PAREN DECIMAL_NUMBER (COMMA DECIMAL_NUMBER)? R_PAREN)?
        // Examples: package.type, c_cursor%rowtype, table.column.type%type, schema.table.column%type
        | (DOT IDENTIFIER)* (ROWTYPE_ATTRIBUTE | TYPE_ATTRIBUTE)?
    )
    ;

schema
    : IDENTIFIER
    ;

name
    : IDENTIFIER
    ;

null_value
    : NULL
    ;

character_literal
    : CHAR_LITERAL
    ;

boolean_literal
    : TRUE | FALSE
    ;

numeric_literal
    : (MINUS DECIMAL_NUMBER)
    | DECIMAL_NUMBER
    ;

comment
    : SINGLE_LINE_COMMENT | MULTI_LINE_COMMENT
    ;

// End: common things