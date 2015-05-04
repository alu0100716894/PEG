start
	= oper:statement end:(PUNTOYCOMA statement ?)* {
		return {left: oper, right: end};
	}
	/ // Vacio
statement
	= left:ID operator:IGUAL right:expresion {
			return { left: left, operator: operator, right: right };
	}
	/ P right:expresion { return {right: right} }
	/ comp1:IF left:condition comp2:THEN right:statement { return {comparatorIF: comp1, left: left, comparatorTHEN: comp2, right: right}; }

condition
	= left:expresion oper:COMPARISONOPERATOR right:expresion { 
		return {left: left, operator: oper, right: right}; 
	}

expresion
	= left:expresionResta oper:MAS right:expresionResta { 
		return {left: left, operator: oper, right: right}; 
	}
	/ left:expresionResta

expresionResta
	= left:term oper:MENOS right:expresionResta { 
		return {left: left, operator: oper, right: right}; 
	}
	/ left:term
term
	= left:termDiv oper:POR right:term { return {left: left, operator: oper, right: right}; }
	/ left:termDiv
termDiv
	= left:factor oper:DIV right:termDiv { return {left: left, operator: oper, right: right}; }
	/ left:factor
factor
	= val:NUM { return {factor: val}; }
	/ val:ID { return {factor: val}; }
	/ par1:PAR_I left:expresion par2:PAR_D { 
		return {left: par1, expression: left, right: par2};
	}

// Convirtiendo _ en espacios en blanco
_ = $[ \t\n\r]*

// Caracteres especiales
PUNTOYCOMA = _";"_ { return {value: ";", type: "END_OF_STATEMENT"}; }
IGUAL = _"="_ { return {value: "=", arity: "binary"}; }
P = _"P"_
IF = _"if"_ { return {value: "if", arity: "conditional"}; }
THEN = _"then"_ { return {value: "then", arity: "conditional"}; }

// Operandos
MAS = _"+"_ { return {value: "+", arity: "binary"}; }
MENOS = _"-"_ { return {value: "-", arity: "binary"}; }
POR = _"*"_ { return {value: "*", arity: "binary"}; }
DIV = _"/"_ { return {value: "/", arity: "binary"}; }
PAR_D = _")"_ { return {value: ")", arity: "binary"}; }
PAR_I = _"("_ { return {value: "(", arity: "binary"}; }

// Elementos para regex
SIN_DIGITO = [a-zA-Z_]
CON_DIGITO = [a-zA-Z_0-9]*
DIG_CLEENE = [0-9]*
DIG_POSITIVO = [0-9]+
PUNTO = [.]
IZQUIERDA = [<>=!]
EXPONENTE = [eE][+-]?
PARTE_A = $(IZQUIERDA IGUAL*)

// Expresiones con regex
ID = _ id:$SIN_DIGITO CON_DIGITO _ {
	return {value: id, arity: "name"};
}
NUM = _ num:$ DIG_POSITIVO(PUNTO DIG_CLEENE)?(EXPONENTE DIG_POSITIVO)? _ {
	var aux = parseInt(num, 10);
	return {value: aux, arity: "literal"};
}
COMPARISONOPERATOR = _ comp:$PARTE_A _ { 
	return {value: comp, arity: "comparator"};
	}