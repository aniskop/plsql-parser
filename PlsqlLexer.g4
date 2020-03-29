lexer grammar PlsqlLexer;

// NOTE: Usual rule - if two (or more) tokens has the same beginning, place longer tokens first.
// For example, CHAR and CHARACTER begins with CHAR, so CHARACTER token must be first, then CHAR.

// Keywords
ADD :                   A D D;
ACCESSIBLE :            A C C E S S I B L E;
ARRAY :                 A R R A Y;
AUTHID :                A U T H I D;
BEGIN :                 B E G I N;
BY :                    B Y;
CHARACTER :             C H A R A C T E R;
COLLATION :             C O L L A T I O N;
CONSTANT :              C O N S T A N T;
CURSOR :                C U R S O R;
CURRENT_USER :          C U R R E N T '_' U S E R;
DECLARE :               D E C L A R E;
DEFAULT :               D E F A U L T;
DEFINER :               D E F I N E R;
DETERMINISTIC :         D E T E R M I N I S T I C;
END :                   E N D;
EXCEPTION :             E X C E P T I O N;
FALSE :                 F A L S E;
FUNCTION :              F U N C T I O N;
INDEX :                 I N D E X;
IN :                    I N;
IS :                    I S;
NOCOPY :                N O C O P Y;
NOT :                   N O T;
NULL :                  N U L L;
OF :                    O F;
OUT :                   O U T;
PACKAGE :               P A C K A G E;
PARALLEL_ENABLE :       P A R A L L E L '_' E N A B L E;
PIPELINED :             P I P E L I N E D;
PROCEDURE :             P R O C E D U R E;
RECORD :                R E C O R D;
REF :                   R E F;
RESULT_CACHE :          R E S U L T '_' C A C H E;
RETURN :                R E T U R N;
RANGE :                 R A N G E;
ROWTYPE_ATTRIBUTE :     '%' R O W T Y P E;
SET :                   S E T;
SUBTYPE :               S U B T Y P E;
TABLE :                 T A B L E;
TRIGGER :               T R I G G E R;
TRUE :                  T R U E;
TYPE_ATTRIBUTE :        '%' T Y P E;
TYPE :                  T Y P E;
USING_NLS_COMP :        U S I N G '_' N L S '_' C O M P;
VARRAY :                V A R R A Y;
VARYING :               V A R Y I N G;

// Identifiers
IDENTIFIER: QUOTED_IDENTIFIER | REGULAR_IDENTIFIER;

fragment QUOTED_IDENTIFIER: '"' LETTER (LETTER | '$' | '_' | '#' | ' ' | DIGIT)*? '"';
fragment REGULAR_IDENTIFIER: LETTER (LETTER | '$' | '_' | '#' | DIGIT)*;

// Numeric literals
DECIMAL_NUMBER : DIGIT+;

// Character literal a.k.a. string
CHAR_LITERAL : '\'' (~('\'' | '\r' | '\n' ) | '\'' '\'' | NEWLINE)* '\'';

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
MINUS : '-';
DOT : '.';

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