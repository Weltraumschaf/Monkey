grammar Monkey;

program
   : statement* EOF
   ;

statement
    : letStatement
    | returnStatement
    | expressionStatement
    ;

letStatement
    : LET IDENTIFIER ASSIGN expression SEMICOLON
    ;

returnStatement
    : RETURN expression SEMICOLON
    ;

expressionStatement
    : expression SEMICOLON
    ;

expression
    : literal
    | prefixExpression
    | ifExpression
    | callExpression
    | LPAREN expression RPAREN
    ;

prefixExpression
    :
    ;

ifExpression
    :
    ;

callExpression
    : IDENTIFIER LPAREN functionArgs? RPAREN
    ;

literal
    : arrayLiteral
    | mapLiteral
    | functionLiteral
    | constantLiteral
    ;

arrayLiteral
    : LBRACKET RBRACKET
    ;

mapLiteral
    : LBRACE RBRACE
    ;

functionLiteral
    : FUNCTION LPAREN functionArgs? RPAREN LBRACE statement* RBRACE
    ;

functionArgs
    : IDENTIFIER ( COMMA IDENTIFIER )*
    ;

constantLiteral
    : INTEGER
    | FLOAT
    | BOOLEAN
    | STRING
    | NULL
    ;

multiplicativeExpression
    : prefixExpression
    | multiplicativeExpression ASTERISK prefixExpression
    | multiplicativeExpression SLASH prefixExpression
    | multiplicativeExpression PERCENT prefixExpression
    ;

additiveExpression
    : multiplicativeExpression
    | additiveExpression PLUS multiplicativeExpression
    | additiveExpression MINUS multiplicativeExpression
    ;

relationalExpression
    : additiveExpression
    | relationalExpression LT additiveExpression
    | relationalExpression GT additiveExpression
    | relationalExpression LTE additiveExpression
    | relationalExpression GTE additiveExpression
    ;

equalityExpression
    : relationalExpression
    | relationalExpression EQ relationalExpression
    ;

logicalAndExpression
    : equalityExpression
    | logicalAndExpression AND equalityExpression
    ;

logicalOrExpression
    : logicalAndExpression
    | logicalOrExpression OR logicalAndExpression
    ;

// Operators
ASSIGN   : '=' ;
PLUS     : '+' ;
MINUS    : '-' ;
ASTERISK : '*' ;
SLASH    : '/' ;
PERCENT  : '%' ;

LT     : '<' ;
LTE    : '<=' ;
GT     : '>' ;
GTE    : '>=' ;
EQ     : '==' ;
NOT_EQ : '!=' ;

AND     : '&&' ;
OR      : '||' ;
NOT     : '!' ;

// Delimiters
COMMA     : ',' ;
SEMICOLON : ';' ;
COLON     : ':' ;

LPAREN   : '(' ;
RPAREN   : ')' ;
LBRACE   : '{' ;
RBRACE   : '}' ;
LBRACKET : '[' ;
RBRACKET : ']' ;


INTEGER : NUM+ ;
FLOAT   : (NUM)+ '.' (NUM)* EXPONENT?
        | '.' (NUM)+ EXPONENT?
        | (NUM)+ EXPONENT ;
fragment
EXPONENT: ('e'|'E') ('+' | '-') ? ? NUM+ ;
BOOLEAN : ( TRUE | FALSE ) ;
STRING  : '"' ( ~'"' | '\\' '"')* '"' ;

IDENTIFIER  : ALPHA ALPHANUM? ;
ALPHANUM    : ALPHA | NUM ;
ALPHA       : [a-zA-Z] ;
NUM         : [0-9] ;

// Keywords
FUNCTION : 'fn' ;
LET      : 'let' ;
TRUE     : 'true' ;
FALSE    : 'false' ;
IF       : 'if' ;
ELSE     : 'else' ;
RETURN   : 'return' ;
NULL     : 'null' ;

// Ignored stuff.
COMMENT : ('/*' .*? '*/' | '//' .*?) -> skip ;
WS      : [ \t\r\n] -> skip ;
