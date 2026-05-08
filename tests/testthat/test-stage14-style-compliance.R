findPackageRoot = function(path = getwd()) {
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

stripRComments = function(lines) {
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

test_that("Stage 14 diagnostic internals avoid qualified namespace calls", {
  packageRoot = findPackageRoot()
  if (is.na(packageRoot)) {
    skip("Source-tree R files are not available during installed-package checks.")
  }

  rFiles = list.files(file.path(packageRoot, "R"), pattern = "[.][Rr]$", full.names = TRUE)
  rLines = lapply(rFiles, function(fileName) {
    stripRComments(readLines(fileName, warn = FALSE))
  })
  names(rLines) = rFiles
  offendingLines = unlist(
    lapply(names(rLines), function(fileName) {
      matchedLines = grep("::", rLines[[fileName]], fixed = TRUE)
      if (length(matchedLines) == 0) {
        return(character())
      }

      paste0(fileName, ":", matchedLines, ": ", rLines[[fileName]][matchedLines])
    }),
    use.names = FALSE
  )

  if (length(offendingLines) > 0) {
    fail(paste(offendingLines, collapse = "
"))
  }

  expect_length(offendingLines, 0)
})

test_that("Stage 14 internal diagnostic helpers have roxygen comments", {
  packageRoot = findPackageRoot()
  if (is.na(packageRoot)) {
    skip("Source-tree R files are not available during installed-package checks.")
  }

  helperFiles = file.path(packageRoot, "R", c("model-diagnostic-helpers.R", "tslm.R"))
  helperFiles = helperFiles[file.exists(helperFiles)]

  expect_length(helperFiles, 2)

  helperText = unlist(lapply(helperFiles, readLines, warn = FALSE), use.names = FALSE)
  helperDefinitions = grep("^[[:alnum:]_.]+[[:space:]]*=[[:space:]]*function", helperText)

  for (definitionLine in helperDefinitions) {
    precedingLines = helperText[seq(max(1, definitionLine - 8), definitionLine - 1)]
    hasRoxygen = any(grepl("^#'", precedingLines))
    if (!hasRoxygen) {
      fail(helperText[[definitionLine]])
    }
    expect_true(hasRoxygen)
  }
})
