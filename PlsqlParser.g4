parser grammar PlsqlParser;

options { tokenVocab=PlsqlLexer; }

script
    : plsql_block*
    ;

plsql_block
    : label? declare_section? body SEMICOLON
    ;

label
    : LABEL_BEGIN name LABEL_END
    ;

declare_section
//TODO: cursor declaration
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

//TODO: expression

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
    : BEGIN .*? (EXCEPTION)? END
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

plsql_expression
    : null_value
    | character_literal
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

numeric_literal
    : (MINUS DECIMAL_NUMBER)
    | DECIMAL_NUMBER
    ;

// End: common things