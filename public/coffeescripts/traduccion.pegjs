start
	= statements
statements
	= statement PUNTOYCOMA
	/ // Vacio
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

// Elementos para regex
SIN_DIGITO = [a-zA-Z_]
CON_DIGITO = [a-zA-Z_0-9]*
DIG_CLEENE = [0-9]*
DIG_POSITIVO = [0-9]+
PUNTO = [.]
IZQUIERDA = [<>=!]
EXPONENTE = [eE][+-]?
PARTE_A = IZQUIERDA IGUAL
PARTE_B = [<>]

// Expresiones con regex
ID = _ id:$SIN_DIGITO CON_DIGITO _ { return id; }
NUM = _ num:$ DIG_POSITIVO(PUNTO DIG_CLEENE)?(EXPONENTE DIG_POSITIVO)? _ { return parseInt(num, 10); }
COMPARISONOPERATOR = _ comp:$[PARTE_A PARTE_B] _ { return comp; }