lexer grammar PlsqlLexer;

// Keywords
ADD: [Aa][Dd][Dd];

// Operators

// Delimiters

// Spaces
fragment SPACE: [ \t];
fragment NEWLINE: '\r'? '\n';

SPACES: [ \t\r\n]+ -> skip;