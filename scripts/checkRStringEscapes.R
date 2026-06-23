#!/usr/bin/env Rscript

# Standalone preflight scanner for suspicious single backslashes in R strings.
# The goal is to catch common accidental escapes such as "\\$" written as
# a single backslash before slow package tests are run.

scanRStringEscapesInText = function(text, path = "<text>") {
  lines = strsplit(text, "\n", fixed = TRUE)[[1]]
  findings = list()

  for (lineIndex in seq_along(lines)) {
    line = lines[[lineIndex]]
    lineFindings = scanRStringEscapesInLine(line)

    if (length(lineFindings) > 0) {
      for (finding in lineFindings) {
        findings[[length(findings) + 1]] = data.frame(
          file = path,
          line = lineIndex,
          column = finding$column,
          escape = finding$escape,
          text = line,
          stringsAsFactors = FALSE
        )
      }
    }
  }

  if (length(findings) == 0) {
    return(data.frame(
      file = character(),
      line = integer(),
      column = integer(),
      escape = character(),
      text = character(),
      stringsAsFactors = FALSE
    ))
  }

  do.call(rbind, findings)
}

scanRStringEscapesInLine = function(line) {
  chars = strsplit(line, "", fixed = TRUE)[[1]]
  findings = list()
  quoteChar = NULL
  stringStart = NA_integer_
  escaped = FALSE
  rawDelimiter = NULL
  index = 1L

  while (index <= length(chars)) {
    current = chars[[index]]

    if (is.null(quoteChar)) {
      rawStart = detectRawStringStart(chars, index)
      if (!is.null(rawStart)) {
        quoteChar = "raw"
        rawDelimiter = rawStart$delimiter
        index = rawStart$contentStart
        next
      }

      if (current %in% c("'", '"')) {
        quoteChar = current
        stringStart = index
        escaped = FALSE
      } else if (current == "#") {
        break
      }

      index = index + 1L
      next
    }

    if (identical(quoteChar, "raw")) {
      rawEnd = detectRawStringEnd(chars, index, rawDelimiter)
      if (!is.null(rawEnd)) {
        quoteChar = NULL
        rawDelimiter = NULL
        index = rawEnd + 1L
      } else {
        index = index + 1L
      }
      next
    }

    if (escaped) {
      if (isSuspiciousEscape(current)) {
        findings[[length(findings) + 1]] = list(
          column = index - 1L,
          escape = paste0("\\", current)
        )
      }
      escaped = FALSE
      index = index + 1L
      next
    }

    if (current == "\\") {
      escaped = TRUE
      index = index + 1L
      next
    }

    if (current == quoteChar) {
      quoteChar = NULL
      stringStart = NA_integer_
    }

    index = index + 1L
  }

  findings
}

detectRawStringStart = function(chars, index) {
  if (index + 1L > length(chars)) {
    return(NULL)
  }

  if (!chars[[index]] %in% c("r", "R") || !chars[[index + 1L]] %in% c("'", '"')) {
    return(NULL)
  }

  quoteChar = chars[[index + 1L]]
  delimiterChars = character()
  scanIndex = index + 2L

  while (scanIndex <= length(chars) && chars[[scanIndex]] != "(") {
    delimiterChars = c(delimiterChars, chars[[scanIndex]])
    scanIndex = scanIndex + 1L
  }

  if (scanIndex > length(chars)) {
    return(NULL)
  }

  list(
    delimiter = paste0(c(")", delimiterChars, quoteChar), collapse = ""),
    contentStart = scanIndex + 1L
  )
}

detectRawStringEnd = function(chars, index, delimiter) {
  delimiterChars = strsplit(delimiter, "", fixed = TRUE)[[1]]
  endIndex = index + length(delimiterChars) - 1L

  if (endIndex > length(chars)) {
    return(NULL)
  }

  if (identical(chars[index:endIndex], delimiterChars)) {
    return(endIndex)
  }

  NULL
}

isSuspiciousEscape = function(char) {
  char %in% c("$", ".", "s", "d", "w", "(", ")", "[", "]", "{", "}", "|", "+", "*", "?", "^")
}

scanRStringEscapes = function(paths) {
  findings = list()

  for (path in paths) {
    if (!file.exists(path)) {
      next
    }

    text = paste(readLines(path, warn = FALSE), collapse = "\n")
    pathFindings = scanRStringEscapesInText(text, path)

    if (nrow(pathFindings) > 0) {
      findings[[length(findings) + 1]] = pathFindings
    }
  }

  if (length(findings) == 0) {
    return(data.frame(
      file = character(),
      line = integer(),
      column = integer(),
      escape = character(),
      text = character(),
      stringsAsFactors = FALSE
    ))
  }

  do.call(rbind, findings)
}

findDefaultRFiles = function(root = ".") {
  searchDirs = c("R", file.path("tests", "testthat"), "scripts")
  files = character()

  for (searchDir in searchDirs) {
    fullDir = file.path(root, searchDir)
    if (dir.exists(fullDir)) {
      files = c(files, list.files(fullDir, pattern = "[.]R$", recursive = TRUE, full.names = TRUE))
    }
  }

  sort(unique(files))
}

printEscapeFindings = function(findings) {
  if (nrow(findings) == 0) {
    message("No suspicious R string escapes found.")
    return(invisible(findings))
  }

  message("Suspicious R string escapes found:")
  for (index in seq_len(nrow(findings))) {
    message(sprintf(
      "%s:%s:%s: %s in %s",
      findings$file[[index]],
      findings$line[[index]],
      findings$column[[index]],
      findings$escape[[index]],
      trimws(findings$text[[index]])
    ))
  }

  invisible(findings)
}

main = function(args = commandArgs(trailingOnly = TRUE)) {
  root = "."
  if (length(args) >= 2 && identical(args[[1]], "--root")) {
    root = args[[2]]
  } else if (length(args) > 0) {
    stop("Usage: Rscript scripts/checkRStringEscapes.R [--root PATH]", call. = FALSE)
  }

  paths = findDefaultRFiles(root)
  findings = scanRStringEscapes(paths)
  printEscapeFindings(findings)

  if (nrow(findings) > 0) {
    stop("Suspicious R string escapes found. Use double backslashes or fixed = TRUE where appropriate.", call. = FALSE)
  }

  invisible(TRUE)
}

if (identical(environment(), globalenv()) && !interactive()) {
  main()
}
