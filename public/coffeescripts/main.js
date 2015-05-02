// Generated by CoffeeScript 1.9.1
(function() {
  var CopyMe, cargar, clear, handleDragOver, handleFileSelect, main, parse;

  main = function() {
    var result, source;
    source = INPUT.value;
    try {
      result = JSON.stringify(parse(source), null, 2);
    } catch (_error) {
      result = _error;
      result = "<div class=\"error\">" + result + "</div>";
    }
    return OUTPUT.innerHTML = result;
  };

  clear = function() {
    OUTPUT.innerHTML = "";
    return INPUT.value = "";
  };

  window.onload = function() {
    PARSE.onclick = main;
    CLEAR.onclick = clear;
    EJE1.onclick = cargar;
    EJE2.onclick = cargar;
    EJE3.onclick = cargar;
    files.addEventListener("change", CopyMe);
    INPUT.addEventListener("dragover", handleDragOver);
    return INPUT.addEventListener("drop", handleFileSelect);
  };

  handleDragOver = function(evt) {
    evt.stopPropagation();
    evt.preventDefault();
    evt.target.style.background = 'purple';
  };

  handleFileSelect = function(evt) {
    var f, files, i, reader;
    evt.stopPropagation();
    evt.preventDefault();
    files = evt.dataTransfer.files;
    INPUT.value = '';
    i = 0;
    f = void 0;
    while (f = files[i]) {
      reader = new FileReader;
      reader.readAsText(f);
      reader.onload = function(e) {
        var txt;
        txt = INPUT.value;
        if (txt !== '') {
          txt = txt + '\n';
        }
        txt = txt + e.target.result;
        INPUT.value = txt;
      };
      i++;
    }
    evt.target.style.background = 'white';
  };

  cargar = function(value) {
    var filename;
    filename = "ejemplos/" + value.srcElement.name;
    return $.ajax({
      url: filename,
      dataType: "text",
      success: function(data) {
        INPUT.value = data;
        return main();
      }
    });
  };

  CopyMe = function(evt) {
    var c, file, reader;
    console.log("entro");
    file = evt.target.files[0];
    if (file) {
      reader = new FileReader;
      reader.onload = function(e) {
        INPUT.value = e.target.result;
      };
      c = reader.readAsText(file);
    } else {
      alert('Failed to load file');
    }
  };

  Object.constructor.prototype.error = function(message, t) {
    t = t || this;
    t.name = "SyntaxError";
    t.message = message;
    throw treturn;
  };

  RegExp.prototype.bexec = function(str) {
    var i, m;
    i = this.lastIndex;
    m = this.exec(str);
    if (m && m.index === i) {
      return m;
    }
    return null;
  };

  String.prototype.tokens = function() {
    var RESERVED_WORD, from, getTok, i, key, m, make, n, result, rw, tokens, value;
    from = void 0;
    i = 0;
    n = void 0;
    m = void 0;
    result = [];
    tokens = {
      WHITES: /\s+/g,
      ID: /[a-zA-Z_]\w*/g,
      NUM: /\b\d+(\.\d*)?([eE][+-]?\d+)?\b/g,
      STRING: /('(\\.|[^'])*'|"(\\.|[^"])*")/g,
      ONELINECOMMENT: /\/\/.*/g,
      MULTIPLELINECOMMENT: /\/[*](.|\n)*?[*]\//g,
      COMPARISONOPERATOR: /[<>=!]=|[<>]/g,
      ONECHAROPERATORS: /([-+*\/=()&|;:,{}[\]])/g
    };
    RESERVED_WORD = {
      p: "P",
      "if": "IF",
      then: "THEN"
    };
    make = function(type, value) {
      return {
        type: type,
        value: value,
        from: from,
        to: i
      };
    };
    getTok = function() {
      var str;
      str = m[0];
      i += str.length;
      return str;
    };
    if (!this) {
      return;
    }
    while (i < this.length) {
      for (key in tokens) {
        value = tokens[key];
        value.lastIndex = i;
      }
      from = i;
      if (m = tokens.WHITES.bexec(this) || (m = tokens.ONELINECOMMENT.bexec(this)) || (m = tokens.MULTIPLELINECOMMENT.bexec(this))) {
        getTok();
      } else if (m = tokens.ID.bexec(this)) {
        rw = RESERVED_WORD[m[0]];
        if (rw) {
          result.push(make(rw, getTok()));
        } else {
          result.push(make("ID", getTok()));
        }
      } else if (m = tokens.NUM.bexec(this)) {
        n = +getTok();
        if (isFinite(n)) {
          result.push(make("NUM", n));
        } else {
          make("NUM", m[0]).error("Bad number");
        }
      } else if (m = tokens.STRING.bexec(this)) {
        result.push(make("STRING", getTok().replace(/^["']|["']$/g, "")));
      } else if (m = tokens.COMPARISONOPERATOR.bexec(this)) {
        result.push(make("COMPARISON", getTok()));
      } else if (m = tokens.ONECHAROPERATORS.bexec(this)) {
        result.push(make(m[0], getTok()));
      } else {
        throw "Syntax error near '" + (this.substr(i)) + "'";
      }
    }
    return result;
  };

  parse = function(input) {
    var condition, expression, expressionResta, factor, lookahead, match, statement, statements, term, termDiv, tokens, tree;
    tokens = input.tokens();
    lookahead = tokens.shift();
    match = function(t) {
      if (lookahead.type === t) {
        lookahead = tokens.shift();
        if (typeof lookahead === "undefined") {
          lookahead = null;
        }
      } else {
        throw ("Syntax Error. Expected " + t + " found '") + lookahead.value + "' near '" + input.substr(lookahead.from) + "'";
      }
    };
    statements = function() {
      var result;
      result = [statement()];
      while (lookahead && lookahead.type === ";") {
        match(";");
        if (lookahead) {
          result.push(statement());
        }
      }
      if (result.length === 1) {
        return result[0];
      } else {
        return result;
      }
    };
    statement = function() {
      var left, result, right;
      result = null;
      if (lookahead && lookahead.type === "ID") {
        left = {
          type: "ID",
          value: lookahead.value
        };
        match("ID");
        match("=");
        right = expression();
        result = {
          type: "=",
          left: left,
          right: right
        };
      } else if (lookahead && lookahead.type === "P") {
        match("P");
        right = expression();
        result = {
          type: "P",
          value: right
        };
      } else if (lookahead && lookahead.type === "IF") {
        match("IF");
        left = condition();
        match("THEN");
        right = statement();
        result = {
          type: "IF",
          left: left,
          right: right
        };
      } else {
        throw "Syntax Error. Expected identifier but found " + (lookahead ? lookahead.value : "end of input") + (" near '" + (input.substr(lookahead.from)) + "'");
      }
      return result;
    };
    condition = function() {
      var left, result, right, type;
      left = expression();
      type = lookahead.value;
      match("COMPARISON");
      right = expression();
      result = {
        type: type,
        left: left,
        right: right
      };
      return result;
    };
    expression = function() {
      var exp, result;
      result = expressionResta();
      if (lookahead && lookahead.type === "+") {
        match("+");
        exp = expression();
        result = {
          type: "+",
          left: result,
          right: exp
        };
      }
      return result;
    };
    expressionResta = function() {
      var result, right;
      result = term();
      if (lookahead && lookahead.type === "-") {
        match("-");
        right = expressionResta();
        result = {
          type: "-",
          left: result,
          right: right
        };
      }
      return result;
    };
    term = function() {
      var result, right;
      result = termDiv();
      if (lookahead && lookahead.type === "*") {
        match("*");
        right = term();
        result = {
          type: "*",
          left: result,
          right: right
        };
      }
      return result;
    };
    termDiv = function() {
      var result, right;
      result = factor();
      if (lookahead && lookahead.type === "/") {
        match("/");
        right = termDiv();
        result = {
          type: "/",
          left: result,
          right: right
        };
      }
      return result;
    };
    factor = function() {
      var result;
      result = null;
      if (lookahead.type === "NUM") {
        result = {
          type: "NUM",
          value: lookahead.value
        };
        match("NUM");
      } else if (lookahead.type === "ID") {
        result = {
          type: "ID",
          value: lookahead.value
        };
        match("ID");
      } else if (lookahead.type === "(") {
        match("(");
        result = expression();
        match(")");
      } else {
        throw "Syntax Error. Expected number or identifier or '(' but found " + (lookahead ? lookahead.value : "end of input") + (lookahead ? " near '" + input.substr(lookahead.from) + "'" : ".");
      }
      return result;
    };
    tree = statements(input);
    if (lookahead != null) {
      throw "Syntax Error parsing statements. " + "Expected 'end of input' and found '" + input.substr(lookahead.from) + "'";
    }
    return tree;
  };

  window.onload();

}).call(this);
