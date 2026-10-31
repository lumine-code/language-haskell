; Recovery may drop a quasiquote wrapper while keeping its named opener.
; Payload recovered as a following field/name still belongs to an open quote.
((ERROR (quasiquote (MISSING "|]")) (_) @preserve)
  (#is? indent.reindent true)
  (#set! indent.force true))

(ERROR "[" . (quoter) . "|" @match.next
  (#set! indent.match startPosition))
(ERROR "[" . (quoter) . "|" ["(" ")" "[" "]" "{" "}"] @match.next
  (#set! indent.match startPosition))
; An unfinished brace character is distinct from promoted lists/tuples.
(ERROR "'" @match.next . ["{" "}"]
  (#set! indent.match startPosition))

; Reindent changes code structure, never the contents of multiline literals
; or the alignment a user chose inside a block comment.
([(string) (quasiquote) (comment)] @preserve
  (#is? indent.reindent true)
  (#is-not? indent.matchesCurrentRow startPosition)
  (#set! indent.force true))

; Only explicit delimiters change the inherited indentation. Layout,
; operators and unfinished expressions deliberately keep the current level.
; Quasiquote bodies are literal text and end with a different delimiter.
(quasiquote "[" @_IGNORE_ (#set! capture.final true))

["(" "[" "{"] @indent
[")" "]" "}"] @dedent
