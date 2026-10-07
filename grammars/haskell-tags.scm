; Signatures accompanying a definition are omitted to avoid duplicate entries.
(header module: (module) @name) @definition.module
(function name: [(variable) (prefix_id)] @name) @definition.function
(bind name: [(variable) (prefix_id)] @name) @definition.variable
(class name: (_) @name) @definition.class
[(data_type name: (_) @name)
 (newtype name: (_) @name)
 (type_synonym name: (_) @name)
 (type_family name: (_) @name)] @definition.type
(data_constructor constructor: (prefix name: (_) @name)) @definition.constructor
(newtype_constructor name: (_) @name) @definition.constructor
(field name: (field_name) @name
  (#set! symbol.tag "field"))
(class_declarations (signature name: (_) @name) @definition.method)
(class_declarations (signature names: (binding_list name: (_) @name)
  (#set! symbol.tag "method")))
(function (infix operator: (_) @name)) @definition.function
(data_constructor constructor: (record name: (_) @name)) @definition.constructor
(data_constructor constructor: (infix operator: (_) @name)) @definition.constructor
(gadt_constructor name: (_) @name) @definition.constructor
(gadt_constructor names: (binding_list name: (_) @name)
  (#set! symbol.tag "constructor"))
