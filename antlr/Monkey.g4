grammar Monkey;

/*
 * Statements must be terminated with ';'. Expressions always return a value.
 */

// Parser production rules:
///////////////////////////

program
   : statement* EOF
   ;

statement
    : assignStatement
    | letStatement
    | constStateent
    | returnStatement
    | expressionStateent
    | ifExpression
    ;

letStatement
    : KW_LET ( IDENTIFIER SEMICOLON | assignStatement )
    ;

constStateent
    : KW_CONST assignStatement
    ;

assignStatement
    // Is the assoc property here really necessary?
    : <assoc=right> IDENTIFIER OP_ASSIGN expression SEMICOLON
    ;

returnStatement
    : KW_RETURN expression SEMICOLON
    ;

expressionStateent
    : expression SEMICOLON
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
    | ifExpression
    | callExpression
    ;

literalExpression
    : functionLiteral
    | NULL
    | BOOLEAN
    | FLOAT
    | INTEGER
    | STRING
    | IDENTIFIER
    ;

functionLiteral
    : KW_FUNCTION L_PAREN functionArguments? R_PAREN L_BRACE statement+ R_BRACE
    ;

functionArguments
    : IDENTIFIER ( COMMA IDENTIFIER )*
    ;

ifExpression
    // We want at least one statetement or exactly one expression.
    : KW_IF L_PAREN expression R_PAREN L_BRACE ( statement+ | expression ) R_BRACE
        ( KW_ELSE L_BRACE ( statement+ | expression ) R_BRACE )?
    ;

callExpression
    : IDENTIFIER L_PAREN callArguments? R_PAREN
    ;

callArguments
    : expression ( COMMA expression )*
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
