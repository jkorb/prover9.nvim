(line_comment) @comment
(block_comment) @comment

(command name: (symbol (identifier) @function))
(list_block (symbol (identifier) @type))
(if_block (symbol (identifier) @constant.builtin))
(quantified (symbol (identifier) @keyword))

(identifier) @variable
(quoted_symbol) @string
(number) @number

[
  "if"
  "end_if"
  "formulas"
  "terms"
  "list"
  "end_of_list"
  "all"
  "exists"
] @keyword

[
  "="
  "!="
  "=="
  "<"
  "<="
  ">"
  ">="
  "+"
  "-"
  "*"
  "/"
  "\\"
  "^"
  "v"
  "@"
  ":"
  "|"
  "&"
  "<->"
  "->"
  "<-"
  "#"
  "~"
] @operator

[
  "("
  ")"
  "["
  "]"
  "."
  ","
] @punctuation.delimiter

"'" @punctuation.special
