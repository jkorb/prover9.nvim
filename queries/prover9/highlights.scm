(line_comment) @comment
(block_comment) @comment

(symbol (identifier) @constant
  (#match? @constant "^[A-Z]"))

(symbol (identifier) @variable
  (#match? @variable "^[a-z$]"))

(command name: (symbol (identifier) @function.builtin))
(application (symbol (identifier) @function.call))
(list_block (symbol (identifier) @label))
(if_block (symbol (identifier) @constant.builtin))
(quantified (symbol (identifier) @variable.parameter))

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
