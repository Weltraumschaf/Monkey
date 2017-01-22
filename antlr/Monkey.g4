grammar Monkey;

// Parser production rules:
///////////////////////////

program
   : statement+ EOF
   ;

statement
    : assignStatement
    | letStatement
    | constStateent
    | emptyStatement
    ;

letStatement
    : KW_LET assignStatement
    ;

constStateent
    : KW_CONST assignStatement
    ;

assignStatement
    : IDENTIFIER OP_ASSIGN expression SEMICOLON
    ;

emptyStatement
    : SEMICOLON
    ;

expression
    // Here we define the operator precedence because ANTLR4 can deal with left recursion.
    : ( OP_NOT | OP_SUB ) expression
    | <assoc=right> expression OP_POW expression
    | expression ( OP_MUL | OP_DIV | OP_MOD ) expression
    | expression ( OP_ADD | OP_SUB ) expression
    | expression ( RELOP_LT |RELOP_LTE | RELOP_GT | RELOP_GTE ) expression
    | expression ( RELOP_EQ | RELOP_NEQ ) expression
    | expression OP_AND expression
    | expression OP_OR expression
    | L_PAREN expression R_PAREN
    | literalExpression
    ;

literalExpression
    : NULL
    | BOOLEAN
    | FLOAT
    | INTEGER
    | STRING
    | IDENTIFIER
    ;

// Lexer tokens:
////////////////

// Operators:
OP_ASSIGN   : '=' ;
OP_ADD      : '+' ;
OP_SUB      : '-' ;
OP_MUL      : '*' ;
OP_DIV      : '/' ;
OP_MOD      : '%' ;
OP_POW      : '^' ;

OP_AND      : '&&' ;
OP_OR       : '||' ;
OP_NOT      : '!' ;

RELOP_LT    : '<' ;
RELOP_LTE   : '<=' ;
RELOP_GT    : '>' ;
RELOP_GTE   : '>=' ;
RELOP_EQ    : '==' ;
RELOP_NEQ   : '!=' ;


// Delimiters:
COMMA       : ',' ;
SEMICOLON   : ';' ;
COLON       : ':' ;
L_PAREN     : '(' ;
R_PAREN     : ')' ;
L_BRACE     : '{' ;
R_BRACE     : '}' ;
L_BRACKET   : '[' ;
R_BRACKET   : ']' ;


// Keywords:
KW_LET      : 'let' ;
KW_CONST    : 'const' ;
KW_FUNCTION : 'fn' ;
// Control structures:
KW_RETURN   : 'return' ;
KW_IF       : 'if' ;
KW_ELSE     : 'else' ;
KW_FOR      : 'loop' ;
KW_BREAK    : 'break' ;
KW_CONTINUE : 'continue' ;
KW_SWITCH   : 'switch' ;
KW_CASE     : 'case' ;
KW_DEFAULT  : 'default' ;

INTEGER : DIGIT+ ;
FLOAT   : (DIGIT)+ '.' (DIGIT)* EXPONENT?
        | '.' (DIGIT)+ EXPONENT?
        | (DIGIT)+ EXPONENT ;
fragment
EXPONENT: ('e'|'E') ('+' | '-') ? ? DIGIT+ ;
BOOLEAN : ( TRUE | FALSE ) ;
STRING  : '"' ( ~'"' | '\\' '"')* '"' ;

// Must be defined after keywords. Instead keywords will be recognized as identifier.
IDENTIFIER  : LETTER ALPHANUM* ;
ALPHANUM    : LETTER | DIGIT ;
LETTER      : [a-zA-Z] ;
DIGIT       : [0-9] ;

// Literal values:
TRUE    : 'true' ;
FALSE   : 'false' ;
NULL    : 'null' ;

// Ignored stuff:
MULTILINE_COMMENT   : '/*' .*? '*/'     -> channel(HIDDEN) ;
SINGLELINE_COMMENT  : '//' .*? '\n'     -> channel(HIDDEN) ;
WHITESPACE          : [ \t\r\n\u000C]+  -> skip ;
