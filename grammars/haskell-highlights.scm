; ----------------------------------------------------------------------------
; Parameters and variables
; NOTE: These are at the top, so that they have low priority,
; and don't override destructured parameters
(variable) @variable.other.haskell

(pattern/wildcard) @variable.other.haskell

(decl/function
  patterns: (patterns
    (_) @variable.parameter.haskell))

(expression/lambda
  (_)+ @variable.parameter.haskell
  "->")

(decl/function
  (infix
    (pattern) @variable.parameter.haskell))

; ----------------------------------------------------------------------------
; Literals and comments
(integer) @constant.numeric.haskell

(negation) @constant.numeric.haskell

(expression/literal
  (float)) @constant.numeric.float.haskell

(char) @string.quoted.single.haskell

(string) @string.quoted.double.haskell

(unit) @constant.other.symbol.haskell ; unit, as in ()

(comment) @comment.line.haskell

((haddock) @comment.block.documentation.haskell)

; ----------------------------------------------------------------------------
; Punctuation
"(" @punctuation.definition.expression.begin.bracket.round.haskell
")" @punctuation.definition.expression.end.bracket.round.haskell
"{" @punctuation.definition.record.begin.bracket.curly.haskell
"}" @punctuation.definition.record.end.bracket.curly.haskell
"[" @punctuation.definition.list.begin.bracket.square.haskell
"]" @punctuation.definition.list.end.bracket.square.haskell

"," @punctuation.separator.comma.haskell
";" @punctuation.terminator.statement.haskell

; ----------------------------------------------------------------------------
; Keywords, operators, includes
[
  "forall"
  ; "∀" ; utf-8 is not cross-platform safe
] @keyword.control.loop.haskell

(pragma) @keyword.control.directive.haskell

[
  "if"
  "then"
  "else"
  "case"
  "of"
] @keyword.control.conditional.haskell

[
  "import"
  "qualified"
  "module"
] @keyword.control.import.haskell

[
  (operator)
  (constructor_operator)
  (all_names)
  (wildcard)
  "."
  ".."
  "="
  "|"
  "::"
  "=>"
  "->"
  "<-"
  "\\"
  "`"
  "@"
] @keyword.operator.haskell

; TODO broken, also huh?
; ((qualified_module
;   (module) @constructor)
;   .
;   (module))

(module
  (module_id) @entity.name.namespace.haskell)

[
  "where"
  "let"
  "in"
  "class"
  "instance"
  "pattern"
  "data"
  "newtype"
  "family"
  "type"
  "as"
  "hiding"
  "deriving"
  "via"
  "stock"
  "anyclass"
  "do"
  "mdo"
  "rec"
  "infix"
  "infixl"
  "infixr"
] @keyword.control.haskell

; ----------------------------------------------------------------------------
; Functions and variables
(decl
  [
   name: (variable) @entity.name.function.haskell
   names: (binding_list (variable) @entity.name.function.haskell)
  ])

(decl/bind
  name: (variable) @variable.other.haskell)

; Consider signatures (and accompanying functions)
; with only one value on the rhs as variables
(decl/signature
  name: (variable) @variable.other.haskell
  type: (type))

((decl/signature
  name: (variable) @_IGNORE_.name
  type: (type))
  .
  (decl
    name: (variable) @variable.other.haskell)
    match: (_)
  (#eq? @_IGNORE_.name @variable.other.haskell))

; but consider a type that involves 'IO' a decl/function
(decl/signature
  name: (variable) @entity.name.function.haskell
  type: (type/apply
    constructor: (name) @_IGNORE_.type)
  (#eq? @_IGNORE_.type "IO"))

((decl/signature
  name: (variable) @_IGNORE_.name
  type: (type/apply
    constructor: (name) @_IGNORE_.type)
  (#eq? @_IGNORE_.type "IO"))
  .
  (decl
    name: (variable) @entity.name.function.haskell)
    match: (_)
  (#eq? @_IGNORE_.name @entity.name.function.haskell))

((decl/signature) @entity.name.function.haskell
  .
  (decl/function
    name: (variable) @entity.name.function.haskell))

(decl/bind
  name: (variable) @entity.name.function.haskell
  (match
    expression: (expression/lambda)))

; view patterns
(view_pattern
  [
    (expression/variable) @support.other.function.haskell
    (expression/qualified
      (variable) @support.other.function.haskell)
  ])

; consider infix functions as operators
(infix_id
  [
    (variable) @keyword.operator.haskell
    (qualified
      (variable) @keyword.operator.haskell)
  ])

; decl/function calls with an infix operator
; e.g. func <$> a <*> b
(infix
  [
    (variable) @support.other.function.haskell
    (qualified
      ((module) @entity.name.namespace.haskell
        (variable) @support.other.function.haskell))
  ]
  .
  (operator))

; infix operators applied to variables
((expression/variable) @variable.other.haskell
  .
  (operator))

((operator)
  .
  [
    (expression/variable) @variable.other.haskell
    (expression/qualified
      (variable) @variable.other.haskell)
  ])

; decl/function calls with infix operators
([
    (expression/variable) @support.other.function.haskell
    (expression/qualified
      (variable) @support.other.function.haskell)
  ]
  .
  (operator) @_IGNORE_.op
  (#any-of? @_IGNORE_.op "$" "<$>" ">>=" "=<<"))

; right hand side of infix operator
((infix
  [
    (operator)
    (infix_id (variable))
  ] ; infix or `func`
  .
  [
    (variable) @support.other.function.haskell
    (qualified
      (variable) @support.other.function.haskell)
  ])
  .
  (operator) @_IGNORE_.op
  (#any-of? @_IGNORE_.op "$" "<$>" "=<<"))

; decl/function composition, arrows, monadic composition (lhs)
(
  [
    (expression/variable) @entity.name.function.haskell
    (expression/qualified
      (variable) @entity.name.function.haskell)
  ]
  .
  (operator) @_IGNORE_.op
  (#any-of? @_IGNORE_.op "." ">>>" "***" ">=>" "<=<"))

; right hand side of infix operator
((infix
  [
    (operator)
    (infix_id (variable))
  ] ; infix or `func`
  .
  [
    (variable) @entity.name.function.haskell
    (qualified
      (variable) @entity.name.function.haskell)
  ])
  .
  (operator) @_IGNORE_.op
  (#any-of? @_IGNORE_.op "." ">>>" "***" ">=>" "<=<"))

; function composition, arrows, monadic composition (rhs)
((operator) @_IGNORE_.op
  .
  [
    (expression/variable) @entity.name.function.haskell
    (expression/qualified
      (variable) @entity.name.function.haskell)
  ]
  (#any-of? @_IGNORE_.op "." ">>>" "***" ">=>" "<=<"))

; function defined in terms of a function composition
(decl/function
  name: (variable) @entity.name.function.haskell
  (match
    expression: (infix
      operator: (operator) @_IGNORE_.op
      (#any-of? @_IGNORE_.op "." ">>>" "***" ">=>" "<=<"))))

(apply
  [
    (expression/variable) @support.other.function.haskell
    (expression/qualified
      (variable) @support.other.function.haskell)
  ])

; function compositions, in parentheses, applied
; lhs
(apply
  .
  (expression/parens
    (infix
      [
        (variable) @support.other.function.haskell
        (qualified
          (variable) @support.other.function.haskell)
      ]
      .
      (operator))))

; rhs
(apply
  .
  (expression/parens
    (infix
      (operator)
      .
      [
        (variable) @support.other.function.haskell
        (qualified
          (variable) @support.other.function.haskell)
      ])))

; variables being passed to a function call
(apply
  (_)
  .
  [
    (expression/variable) @variable.other.haskell
    (expression/qualified
      (variable) @variable.other.haskell)
  ])

; main is always a function
; (this prevents `main = undefined` from being highlighted as a variable)
(decl/bind
  name: (variable) @entity.name.function.haskell
  (#eq? @entity.name.function.haskell "main"))

; scoped function types (func :: a -> b)
(signature
  pattern: (pattern/variable) @entity.name.function.haskell
  type: (quantified_type))

; signatures that have a function type
; + binds that follow them
(decl/signature
  name: (variable) @entity.name.function.haskell
  type: (quantified_type))

((decl/signature
  name: (variable) @_IGNORE_.name
  type: (quantified_type))
  .
  (decl/bind
    (variable) @entity.name.function.haskell)
  (#eq? @entity.name.function.haskell @_IGNORE_.name))

; ----------------------------------------------------------------------------
; Types
(name) @support.type.haskell

(type/star) @support.type.haskell

(variable) @support.type.haskell

(constructor) @entity.name.function.constructor.haskell

; True or False
((constructor) @constant.language.boolean.haskell
  (#any-of? @constant.language.boolean.haskell "True" "False"))

; otherwise (= True)
((variable) @constant.language.boolean.haskell
  (#eq? @constant.language.boolean.haskell "otherwise"))

; ----------------------------------------------------------------------------
; Quasi-quotes
(quoter) @support.other.function.haskell

(quasiquote
  [
    (quoter) @_IGNORE_.name
    (_
      (variable) @_IGNORE_.name)
  ]
  (#eq? @_IGNORE_.name "qq")
  (quasiquote_body) @string.quoted.double.haskell)

(quasiquote
  (_
    (variable) @_IGNORE_.name)
  (#eq? @_IGNORE_.name "qq")
  (quasiquote_body) @string.quoted.double.haskell)

; namespaced quasi-quoter
(quasiquote
  (_
    (module) @entity.name.namespace.haskell
    .
    (variable) @support.other.function.haskell))

; Highlighting of quasiquote_body for other languages is handled by injections.scm
; ----------------------------------------------------------------------------
; Exceptions/error handling
((variable) @keyword.control.exception.haskell
  (#any-of? @keyword.control.exception.haskell
    "error" "undefined" "try" "tryJust" "tryAny" "catch" "catches" "catchJust" "handle" "handleJust"
    "throw" "throwIO" "throwTo" "throwError" "ioError" "mask" "mask_" "uninterruptibleMask"
    "uninterruptibleMask_" "bracket" "bracket_" "bracketOnErrorSource" "finally" "fail"
    "onException" "expectationFailure"))

; ----------------------------------------------------------------------------
; Debugging
((variable) @keyword.control.haskell
  (#any-of? @keyword.control.haskell
    "trace" "traceId" "traceShow" "traceShowId" "traceWith" "traceShowWith" "traceStack" "traceIO"
    "traceM" "traceShowM" "traceEvent" "traceEventWith" "traceEventIO" "flushEventLog" "traceMarker"
    "traceMarkerIO"))

; ----------------------------------------------------------------------------
; Fields

(field_name
  (variable) @variable.other.member.haskell)

(import_name
  (name)
  .
  (children
    (variable) @variable.other.member.haskell))

; ----------------------------------------------------------------------------
; Spell checking
(comment) @_IGNORE_.spell
