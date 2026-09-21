[
  (chunk)
  (do_statement)
  (while_statement)
  (repeat_statement)
  (if_statement)
  (for_statement)
  (function_declaration)
  (function_definition)
] @local.scope

(assignment_statement
  (variable_list
    (identifier) @local.definition.var))

(function_declaration
  name: (identifier) @local.definition.function)

(function_declaration
  name: (dot_index_expression
    (identifier) @local.definition.function))

(function_declaration
  name: (method_index_expression
    (identifier) @local.definition.method))

(for_generic_clause
  (variable_list
    (identifier) @local.definition.var))

(for_numeric_clause
  name: (identifier) @local.definition.var)

(parameters
  (identifier) @local.definition.parameter)