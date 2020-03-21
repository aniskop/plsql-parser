lexer grammar PlsqlLexer;

// Keywords
ADD :               A D D;
BEGIN :             B E G I N;
DECLARE :           D E C L A R E;
END :               E N D;
EXCEPTION :         E X C E P T I O N;
NOT :               N O T;
NULL :              N U L L;

//DATATYPE: (QUOTED_IDENTIFIER | REGULAR_IDENTIFIER) (ROWTYPE_ATTRIBUTE | TYPE_ATTRIBUTE)? ;
ROWTYPE_ATTRIBUTE: '%' R O W T Y P E;
TYPE_ATTRIBUTE: '%' T Y P E;

IDENTIFIER: QUOTED_IDENTIFIER | REGULAR_IDENTIFIER;

fragment QUOTED_IDENTIFIER: '"' LETTER (LETTER | '$' | '_' | '#' | ' ' | DIGIT)*? '"';
fragment REGULAR_IDENTIFIER: LETTER (LETTER | '$' | '_' | '#' | DIGIT)*;

fragment LETTER: [a-zA-Z\u0080-\u00FF_];
fragment DIGIT: [0-9];

// Operators

// Delimiters
LABEL_BEGIN : '<<';
LABEL_END : '>>';
SEMICOLON : ';';
SLASH : '/';

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