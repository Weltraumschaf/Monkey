grammar Monkey;

// Parser production rules:
///////////////////////////

        program
   : statement* EOF
   ;

statement
    : expression SEMICOLON
    ;

expression
    // Here we define the operator precedence because ANTLR4 can deal with left recursion.
    : expression OP_POW<assoc=right> expression
    | expression ( OP_MUL | OP_DIV | OP_MOD ) expression
    | expression ( OP_ADD | OP_SUB ) expression
    | expression ( RELOP_LT |RELOP_LTE | RELOP_GT | RELOP_GTE ) expression
    | expression ( RELOP_EQ | RELOP_NEQ ) expression
    | expression OP_AND expression
    | expression OP_OR expression
    | literalExpression
    | L_PAREN expression R_PAREN
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

// Operators
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


// Delimiters
COMMA       : ',' ;
SEMICOLON   : ';' ;
COLON       : ':' ;

L_PAREN     : '(' ;
R_PAREN     : ')' ;
L_BRACE     : '{' ;
R_BRACE     : '}' ;
L_BRACKET   : '[' ;
R_BRACKET   : ']' ;

INTEGER : DIGIT+ ;
FLOAT   : (DIGIT)+ '.' (DIGIT)* EXPONENT?
        | '.' (DIGIT)+ EXPONENT?
        | (DIGIT)+ EXPONENT ;
fragment
EXPONENT: ('e'|'E') ('+' | '-') ? ? DIGIT+ ;
BOOLEAN : ( TRUE | FALSE ) ;
STRING  : '"' ( ~'"' | '\\' '"')* '"' ;

IDENTIFIER  : LETTER ALPHANUM* ;
ALPHANUM    : LETTER | DIGIT ;
LETTER      : [a-zA-Z] ;
DIGIT       : [0-9] ;

// Keywords
LET         : 'let' ;
CONST       : 'const' ;
FUNCTION    : 'fn' ;
// Control structures
RETURN      : 'return' ;
IF          : 'if' ;
ELSE        : 'else' ;
FOR         : 'loop' ;
BREAK       : 'break' ;
CONTINUE    : 'continue' ;
SWITCH      : 'switch' ;
CASE        : 'case' ;
DEFAULT     : 'default' ;
// Litera values
TRUE        : 'true' ;
FALSE       : 'false' ;
NULL        : 'null' ;

// Ignored stuff.
MULTILINE_COMMENT   : '/*' .*? '*/' -> skip ;
SINGLELINE_COMMENT  : '//' .*?      -> skip ;
WHITESPACE          : [ \t\r\n]     -> skip ;
