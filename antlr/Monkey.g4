grammar Monkey;

// Note: Whitespace handling not as strict as in the specification.

rulelist
   : rule_* EOF
   ;

rule_
   : ID ( '=' | '=/' ) elements
   ;

elements
   : alternation
   ;

alternation
   : concatenation ( '/' concatenation )*
   ;

concatenation
   : repetition ( repetition )*
   ;

repetition
   : repeat? element
   ;

repeat
   : INT | ( INT? '*' INT? )
   ;

element
   : ID | group | option | STRING | NumberValue | ProseValue
   ;

group
   : '(' alternation ')'
   ;

option
   : '[' alternation ']'
   ;


NumberValue
   : '%' ( BinaryValue | DecimalValue | HexValue )
   ;


fragment BinaryValue
   : 'b' BIT+ ( ( '.' BIT+ )+ | ( '-' BIT+ ) )?
   ;


fragment DecimalValue
   : 'd' DIGIT+ ( ( '.' DIGIT+ )+ | ( '-' DIGIT+ ) )?
   ;


fragment HexValue
   : 'x' HEX_DIGIT+ ( ( '.' HEX_DIGIT+ )+ | ( '-' HEX_DIGIT+ ) )?
   ;


ProseValue
   : '<' ( ~ '>' )* '>'
   ;


ID
   : ( 'a' .. 'z' | 'A' .. 'Z' ) ( 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '-' )*
   ;


INT
   : '0' .. '9'+
   ;


COMMENT
   : ';' ~ ( '\n' | '\r' )* '\r'? '\n' -> channel ( HIDDEN )
   ;


WS
   : ( ' ' | '\t' | '\r' | '\n' ) -> channel ( HIDDEN )
   ;


STRING
   : ( '%s' | '%i' )? '"' ( ~ '"' )* '"'
   ;


fragment BIT
   : '0' .. '1'
   ;


fragment DIGIT
   : '0' .. '9'
   ;


// Note: from the RFC errata (http://www.rfc-editor.org/errata_search.php?rfc=5234&eid=4040):
// > ABNF strings are case insensitive and the character set for these strings is US-ASCII.
// > So the definition of HEXDIG already allows for both upper and lower case (or a mixture).
fragment HEX_DIGIT
   : ( '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' )
   ;
