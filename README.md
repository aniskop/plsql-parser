The goal of the project &ndash; create Oracle PL/SQL parser, which operates the same syntactic blocks, which are described in Oracle documentation. This means that the parse tree produced by the parser has the same structure (or at least very close) as the one presented in Oracle docs. Also parser rules are named after the Oracle docs (with some exceptions) to keep straightforward mapping.

Oracle docs used:
* [Database PL/SQL Language Reference](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/index.html)

To test the grammar execute `mvn test` or `mvn clean test`.

# Supported syntax elements

* [Literals](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/plsql-language-fundamentals.html#GUID-A5970DA8-78B4-460B-971D-C957A80B3B08)
    * Numeric
    * Character (e.g. string)
    * Boolean
* [Comments](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/plsql-language-fundamentals.html#GUID-9DEE49B3-40B3-48A8-8F78-C98399379ACE)
    * Single-line
    * Multi-line (see "Known issues" for exceptions).
* [PL/SQL block](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/overview.html#GUID-826B070B-4888-4398-889B-61A3C6B91349)
* Declarations
    * [Variable](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/scalar-variable-declaration.html#GUID-03124315-0E1E-4154-8EBE-12034CA6AD55)
    * [Constant](https://docs.oracle.com/en/database/oracle/racle-database/20/lnpls/constant-declaration.tml#GUID-C6DA65F8-3F0C-43F3-8BC6-231064E8C1B6)
    * [Cursor variable](https://docs.oracle.com/en/database/oracle/racle-database/20/lnpls/cursor-variable-declaration.tml#GUID-CE884B31-07F0-46AA-8067-EBAF73821F3D)
    * [Exception](https://docs.oracle.com/en/database/oracle/racle-database/20/lnpls/exception-declaration.tml#GUID-AAC8C54F-775C-4E65-B531-0350CFF5B1BD)
    * [Record variable](https://docs.oracle.com/en/database/oracle/racle-database/20/lnpls/record-variable-declaration.tml#GUID-704FC014-561E-422C-9636-EDCA3B996AAD)
    * [Collection variable](https://docs.oracle.com/en/database/oracle/racle-database/20/lnpls/collection-variable.tml#GUID-89A1863C-65A1-40CF-9392-86E9FDC21BE9)
    * [Function](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/function-declaration-and-definition.html#GUID-4E19FB09-46B5-4CE5-8A5B-CD815C29DA1C__CJADJIFC)
    * [Procedure](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/procedure-declaration-and-definition.html#GUID-9A48D7CE-3720-46A4-B5CA-C2250CA86AF2__CJACCJID)
* Definitions
    * [Type definition](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/block.html#GUID-9ACEB9ED-567E-4E1A-A16A-B8B35214FC9D__CJACIHEC)
        * [Subtype](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/block.html#GUID-9ACEB9ED-567E-4E1A-A16A-B8B35214FC9D__CHDCIGAD)
        * [Collection type](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/collection-variable.html#GUID-89A1863C-65A1-40CF-9392-86E9FDC21BE9__CJABBGEE)
            * Associative array
            * Varray
            * Nested table
        * [Record type](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/record-variable-declaration.html#GUID-704FC014-561E-422C-9636-EDCA3B996AAD__CJAJCHJA)
        * [Ref cursor type](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/cursor-variable-declaration.html#GUID-CE884B31-07F0-46AA-8067-EBAF73821F3D__CJAIGBFF)
* [Exception handler](https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/exception-handler.html#GUID-3FECF29B-A240-4191-A635-92C612D00C4D)

# Known issues

**Comments**
Comments can be only outside statements and expressions. This makes parser rules and eventually parser easier. 
```sql
-- Valid comment.
declare
    /* Valid multi-line
    comment. */

    /* This is also valid.*/
    -- This is valid.
    my_const constant number := 10; -- Valid comment

    my_var /* This will cause parser to fail */ varchar2(100);
begin
    -- Valid comment
    /* Also valid. */
end;
```
Making the parser find comment everywhere will slow it down while bringing almost no value.
