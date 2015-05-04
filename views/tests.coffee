assert = chai.assert
suite 'PEGJS ADPR', ->
  test 'Comprobación de detección de errores', ->
    assert.throws (->
      traduccion.parse 'a = e'
      return
    ), 'SyntaxError: Expected "*", "+", "-", "/", ";", [ \t\n\r] or [a-zA-Z_0-9] but end of input found.'
    return
  test 'Comprobación de IF', ->
    assert.throws(->
        traduccion.parse 'if x == 2 then y = 32;'
        return
      ), '{
  "left": {
    "comparatorIF": {
      "value": "if",
      "arity": "conditional"
    },
    "left": {
      "left": {
        "factor": {
          "value": "x",
          "arity": "name"
        }
      },
      "operator": {
        "value": "== ",
        "arity": "comparator"
      },
      "right": {
        "factor": {
          "value": 2,
          "arity": "literal"
        }
      }
    },
    "comparatorTHEN": {
      "value": "then",
      "arity": "conditional"
    },
    "right": {
      "left": {
        "value": "y",
        "arity": "name"
      },
      "operator": {
        "value": "=",
        "arity": "binary"
      },
      "right": {
        "factor": {
          "value": 32,
          "arity": "literal"
        }
      }
    }
  },
  "right": {
    "value": ";",
    "type": "END_OF_STATEMENT"
  }
}'
  return