start
	= stat:statements*
statements
	= oper:statement end:PUNTOYCOMA {
		return "Left: " + oper + "\nRight: " + end;
	}
	/ // Vacio
statement
	= left:ID operator:IGUAL right:expresion {
		if(left != null)
			return "\nLeft: " + left + "\nOperator: " + operator + "\nRight: " + right;
		else
			return "\nOperator: " + operator + "\nRight: " + right;
	}
	/ P right:expresion { return "\nRight: " + right; }
	/ comp1:IF left:condition comp2:THEN right:statement { return "\nComp: " + comp1 + "\nLeft: " + left + "\nComp: " + comp2 +  "\nRight: " + right; }

condition
	= left:expresion oper:COMPARISONOPERATOR right:expresion { 
		if(left != null)
			return "\nLeft: " + left + "\nOper: " + oper + "\nRight: " + right; 
		else
			return "\nOper: " + oper + "\nRight: " + right;
	}

expresion
	= left:expresionResta oper:MAS right:expresionResta { 
		if(left != null)
			return "\nLeft: " + left + "\nOper: " + oper + "\nRight: " + right; 
		else
			return "\nOper: " + oper + "\nRight: " + right;
	}
	/ left:expresionResta { return "\nLeft: " + left; }

expresionResta
	= left:term oper:MENOS right:expresionResta { 
		if(left != null)
			return "\nLeft: " + left + "\nOper: " + oper + "\nRight: " + right; 
		else
			return "\nOper: " + oper + "\nRight: " + right;
	}
	/ left:term { return "\nLeft: " + left; }
term
	= left:termDiv oper:POR right:term { return "\nLeft: " + left + "\nOper: " + oper + "\nRight: " + right; }
	/ left:termDiv
termDiv
	= left:factor oper:DIV right:termDiv { return "\nLeft: " + left + "\nOper: " + oper + "\nRight: " + right; }
	/ left:factor { return "\nLeft: " + left; }
factor
	= val:NUM { return "\nLeft: " + val }
	/ val:ID { return "\nLeft: " + val }
	/ par1:PAR_I left:expresion par1:PAR_D { 
		if(par1 != null)
			return "\nLeft: " + par1 + "\nExpression: " + left + "\nRight: " + par1
		else
			return "\nExpression: " + left + "\nRight: " + par1
	}

// Convirtiendo _ en espacios en blanco
_ = $[ \t\n\r]*

// Caracteres especiales
PUNTOYCOMA = _";"_ { return "\n\tValue: ;\n\tEnd of statement" }
IGUAL = _"="_ { return "\n\tValue: =\n\tArity: binary" }
P = _"P"_
IF = _"if"_ { return "\n\tValue: if\n\tArity: conditional" }
THEN = _"then"_ {return "\n\tValue: then\n\tArity: conditional" }

// Operandos
MAS = _"+"_ {return "\n\tValue: +\n\tArity: binary"}
MENOS = _"-"_ {return "\n\tValue: -\n\tArity: binary"}
POR = _"*"_ {return "\n\tValue: *\n\tArity: binary"}
DIV = _"/"_ {return "\n\tValue: /\n\tArity: binary"}
PAR_D = _")"_ {return "\n\tValue: )\n\tArity: binary"}
PAR_I = _"("_ {return "\n\tValue: (\n\tArity: binary"}

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
	var aux = "\n\tValue: " + id;
	aux += "\n\tArity: name"
	return aux;
}
NUM = _ num:$ DIG_POSITIVO(PUNTO DIG_CLEENE)?(EXPONENTE DIG_POSITIVO)? _ {
	var aux = "\n\tValue: " + parseInt(num, 10);
	aux += "\n\tArity: literal";
	return aux;
}
COMPARISONOPERATOR = _ comp:$PARTE_A _ { 
	var aux = "\n\tOperator: " + comp;
	aux += "\n\tArity: binary";
	return aux;
	}