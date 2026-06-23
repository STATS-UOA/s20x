getS20xInternal = function(name) {
  namespaceEnv = asNamespace("s20x")
  get(name, envir = namespaceEnv, inherits = FALSE)
}
