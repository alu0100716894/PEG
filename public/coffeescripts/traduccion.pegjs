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
	/ PAR_I left:expresion PAR_D

// Convirtiendo _ en espacios en blanco
_ = $[ \t\n\r]*
// Caracteres especiales
PUNTOYCOMA = _";"_
IGUAL = _"="_
P = _"P"_
IF = _"IF"_
THEN = _"THEN"_
// Operandos
MAS = _"+"_
MENOS = _"-"_
POR = _"*"_
DIV = _"/"_
PAR_D = _")"_
PAR_I = _"("_
// Expresiones con regex
ID = _ id:$[a-zA-Z_]\w* _ { return id; }
NUM = _ num:$\b\d+(\.\d*)?([eE][+-]?\d+)?\b _ { return parseInt(num, 10); }
COMPARISONOPERATOR = comp:$[<>=!]=|[<>] _ { return comp; }