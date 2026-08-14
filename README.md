# language-haskell

Haskell language support.

## Features

- **Grammars**: provides Tree-sitter grammars, built from [tree-sitter-haskell](https://github.com/tree-sitter/tree-sitter-haskell).
- **Syntax highlighting**: full tree-sitter grammar coverage for Haskell files.
- **Folding**: folds blocks from the parse tree rather than by indentation.

## Installation

To install `language-haskell` search for it in the Install pane of the Lumine settings, or run the command `lumine --install lumine-code/language-haskell`.

## Services

- `hyperlink.injection`: consumed to highlight URLs inside Haskell files as clickable links.
- `todo.injection`: consumed to highlight `TODO`-style markers inside comments.

## Contributing

Got ideas to make this package better, found a bug, or want to help add new features? Just drop your thoughts on GitHub. Any feedback is welcome!
