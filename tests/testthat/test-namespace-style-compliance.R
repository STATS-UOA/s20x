findPackageRootForNamespaceStyle = function(path = getwd()) {
  currentPath = normalizePath(path, winslash = "/", mustWork = TRUE)

  repeat {
    if (file.exists(file.path(currentPath, "DESCRIPTION")) &&
        dir.exists(file.path(currentPath, "R"))) {
      return(currentPath)
    }

    parentPath = dirname(currentPath)
    if (identical(parentPath, currentPath)) {
      return(NA_character_)
    }

    currentPath = parentPath
  }
}

stripNamespaceStyleComments = function(lines) {
  vapply(lines, function(line) {
    inSingleQuote = FALSE
    inDoubleQuote = FALSE
    escaped = FALSE

    chars = strsplit(line, "", fixed = TRUE)[[1]]
    if (length(chars) == 0) {
      return(line)
    }

    for (index in seq_along(chars)) {
      char = chars[[index]]

      if (escaped) {
        escaped = FALSE
        next
      }

      if (char == "\\" && (inSingleQuote || inDoubleQuote)) {
        escaped = TRUE
        next
      }

      if (char == "'" && !inDoubleQuote) {
        inSingleQuote = !inSingleQuote
        next
      }

      if (char == '"' && !inSingleQuote) {
        inDoubleQuote = !inDoubleQuote
        next
      }

      if (char == "#" && !inSingleQuote && !inDoubleQuote) {
        if (index == 1) {
          return("")
        }
        return(substr(line, 1, index - 1))
      }
    }

    line
  }, character(1))
}

collectNamespaceStyleOffences = function(files, patterns) {
  offendingLines = unlist(
    lapply(files, function(fileName) {
      lines = stripNamespaceStyleComments(readLines(fileName, warn = FALSE))
      matchedLines = which(vapply(lines, function(line) {
        any(vapply(patterns, grepl, logical(1), x = line, fixed = TRUE))
      }, logical(1)))

      if (length(matchedLines) == 0) {
        return(character())
      }

      paste0(fileName, ":", matchedLines, ": ", lines[matchedLines])
    }),
    use.names = FALSE
  )

  offendingLines[nzchar(offendingLines)]
}

test_that("controlled source files do not use namespace operators", {
  packageRoot = findPackageRootForNamespaceStyle()
  if (is.na(packageRoot)) {
    skip("Source-tree files are not available during installed-package checks.")
  }

  controlledFiles = c(
    list.files(file.path(packageRoot, "R"), pattern = "[.][Rr]$", full.names = TRUE),
    list.files(file.path(packageRoot, "tests", "testthat"), pattern = "[.][Rr]$", full.names = TRUE)
  )

  namespaceOperator = paste0(":", ":")
  offendingLines = collectNamespaceStyleOffences(controlledFiles, namespaceOperator)

  if (length(offendingLines) > 0) {
    fail(paste(offendingLines, collapse = "\n"))
  }

  expect_length(offendingLines, 0)
})

test_that("controlled source files do not use dynamic namespace lookup helpers", {
  packageRoot = findPackageRootForNamespaceStyle()
  if (is.na(packageRoot)) {
    skip("Source-tree files are not available during installed-package checks.")
  }

  controlledFiles = c(
    list.files(file.path(packageRoot, "R"), pattern = "[.][Rr]$", full.names = TRUE),
    list.files(file.path(packageRoot, "tests", "testthat"), pattern = "[.][Rr]$", full.names = TRUE)
  )

  dynamicLookupPatterns = c(
    paste0("get", "Exported", "Value"),
    paste0("get", "From", "Namespace")
  )
  offendingLines = collectNamespaceStyleOffences(controlledFiles, dynamicLookupPatterns)

  if (length(offendingLines) > 0) {
    fail(paste(offendingLines, collapse = "\n"))
  }

  expect_length(offendingLines, 0)
})
