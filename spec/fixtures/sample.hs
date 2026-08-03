-- Assertions live in the comments: `<- scope` checks the marker's own column
-- on the previous non-comment line, `^ scope` checks the caret's. Scopes
-- match by prefix, so the trailing `.haskell` segment is left off.

module Main where
-- <- keyword

main = putStrLn "hi"
--               ^ string

xs = [1, 2]
--   ^ punctuation.definition.list.begin.bracket.square
--     ^ punctuation.separator.comma

-- a comment
-- <- comment
