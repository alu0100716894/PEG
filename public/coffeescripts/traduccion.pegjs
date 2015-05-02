/*
	
	WHITES: /\s+/g,
      ID: /[a-zA-Z_]\w* /g,
      NUM: /\b\d+(\.\d*)?([eE][+-]?\d+)?\b/g,
      STRING: /('(\\.|[^'])*'|"(\\.|[^"])*")/g,
      ONELINECOMMENT: /\/\/.* /g,
      MULTIPLELINECOMMENT: /\/[*](.|\n)*?[*]\//g,
      COMPARISONOPERATOR: /[<>=!]=|[<>]/g,
      ONECHAROPERATORS: /([-+*\/=()&|;:,{}[\]])/g

 */
start
	= statements
statements
	= statement PUNTOYCOMA
statement
	= ID IGUAL right:expresion
	/ P right:expresion
	/ IF left:condition THEN right:statement
condition
	= left:expresion COMPARISONOPERATOR right:expresion
expresion
	= left:expresionResta MAS right:expresion
	/ left:expresionResta
expresionResta
	= left:term MENOS right:expresionResta
	/ left:term
term
	= left:termDiv POR right:term
	/ left:termDiv
termDiv
	= left:factor DIV right:termDiv
	/ left:factor
factor
	= NUM
	/ ID
	/ PAR_I expresion PAR_D

_ = $[ \t\n\r]*
PUNTOYCOMA = _";"_
IGUAL = _"="_
P = _"P"_
IF = _"IF"_
THEN = _"THEN"_

MAS = _"+"_
MENOS = _"-"_
POR = _"*"_
DIV = _"/"_

PAR_D = _")"_
PAR_I = _"("_

ID = _ id:$[a-zA-Z_]\w* _ { return id; }
NUM = _ num:$\b\d+(\.\d*)?([eE][+-]?\d+)?\b _ { return parseInt(num, 10); }
COMPARISONOPERATOR = comp:$[<>=!]=|[<>] _ { return comp; }