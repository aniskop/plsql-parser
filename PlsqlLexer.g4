lexer grammar PlsqlLexer;

// Keywords
ADD :                   A D D;
ARRAY :                 A R R A Y;
BEGIN :                 B E G I N;
BY :                    B Y;
CHARACTER :             C H A R A C T E R;
CONSTANT :              C O N S T A N T;
DECLARE :               D E C L A R E;
DEFAULT :               D E F A U L T;
END :                   E N D;
EXCEPTION :             E X C E P T I O N;
INDEX :                 I N D E X;
IS :                    I S;
NOT :                   N O T;
NULL :                  N U L L;
OF :                    O F;
RANGE :                 R A N G E;
ROWTYPE_ATTRIBUTE :     '%' R O W T Y P E;
SET :                   S E T;
SUBTYPE :               S U B T Y P E;
TABLE :                 T A B L E;
TYPE_ATTRIBUTE :        '%' T Y P E;
TYPE :                  T Y P E;
VARRAY :                V A R R A Y;
VARYING :               V A R Y I N G;

// Identifiers
IDENTIFIER: QUOTED_IDENTIFIER | REGULAR_IDENTIFIER;

fragment QUOTED_IDENTIFIER: '"' LETTER (LETTER | '$' | '_' | '#' | ' ' | DIGIT)*? '"';
fragment REGULAR_IDENTIFIER: LETTER (LETTER | '$' | '_' | '#' | DIGIT)*;

DECIMAL_NUMBER : DIGIT+;

fragment LETTER: [a-zA-Z\u0080-\u00FF_];
fragment DIGIT: [0-9];

// Operators

// Delimiters
// https://docs.oracle.com/en/database/oracle/oracle-database/20/lnpls/plsql-language-fundamentals.html#GUID-96A42F7C-7A71-4B90-8255-CA9C8BD9722E
ASSIGNMENT : ':=';
RANGE_OP : '..';
COMMA : ',';
LABEL_BEGIN : '<<';
LABEL_END : '>>';
SEMICOLON : ';';
SLASH : '/';
R_PAREN : ')';
L_PAREN : '(';

// Spaces
fragment SPACE: [ \t];
fragment NEWLINE: '\r'? '\n';

fragment A : [aA];
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];

SPACES: [ \t\r\n]+ -> skip;