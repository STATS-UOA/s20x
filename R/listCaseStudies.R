#' List available case studies
#'
#' Lists all case study R Markdown files shipped with the package and prints
#' them as a formatted text table.
#'
#' Case studies are expected to live in \code{inst/case_studies} and to be named
#' using the pattern \code{CS<chapter>_<number>.Rmd} (e.g. \code{CS9_2.Rmd}).
#'
#' @details
#' The table has two columns: \code{File} (the case study identifier) and
#' \code{Title} (extracted from the YAML header). Case studies are listed in
#' numerical order, not alphabetical order.
#'
#' The function invisibly returns a character vector of case study identifiers.
#'
#' @return
#' Invisibly returns a character vector of case study identifiers.
#'
#' @examples
#' if (interactive()) {
#'   listCaseStudies()
#'   ids = listCaseStudies()
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @export
listCaseStudies = function() {
  csDir = system.file("case_studies", package = "s20x")
  if (csDir == "") {
    stop("No case_studies directory found in package.", call. = FALSE)
  }

  files = list.files(csDir, pattern = "\\.Rmd$", full.names = TRUE)
  if (length(files) == 0) {
    return(invisible(character()))
  }

  extractTitle = function(file) {
    lines = readLines(file, warn = FALSE)

    start = which(trimws(lines) == "---")[1]
    end = which(trimws(lines) == "---")[2]
    if (is.na(start) || is.na(end) || end <= start) {
      return(NA_character_)
    }

    yaml = lines[(start + 1):(end - 1)]
    titleIndex = grep("^title\\s*:", yaml)
    if (length(titleIndex) == 0) {
      return(NA_character_)
    }

    title = sub("^title\\s*:\\s*", "", yaml[titleIndex[1]])
    title = trimws(title)
    title = sub('^"(.*)"$', "\\1", title)
    title = sub("^'(.*)'$", "\\1", title)
    trimws(title)
  }

  parseNumber = function(fileName) {
    base = file_path_sans_ext(basename(fileName))
    match = regexec("^CS(\\d+)_([0-9]+)$", base)
    groups = regmatches(base, match)[[1]]
    if (length(groups) == 0) {
      return(c(NA, NA))
    }
    c(as.integer(groups[2]), as.integer(groups[3]))
  }

  info = lapply(files, function(file) {
    number = parseNumber(file)
    list(
      id = file_path_sans_ext(basename(file)),
      major = number[1],
      minor = number[2],
      title = extractTitle(file)
    )
  })

  info = Filter(function(item) {
    !is.na(item$major)
  }, info)

  orderIndex = order(
    vapply(info, `[[`, integer(1), "major"),
    vapply(info, `[[`, integer(1), "minor")
  )
  info = info[orderIndex]

  ids = vapply(info, `[[`, character(1), "id")
  titles = vapply(info, `[[`, character(1), "title")

  fileWidth = max(nchar(c("File", ids)))
  titleWidth = max(nchar(c("Title", titles)), na.rm = TRUE)

  header = sprintf(
    "%-*s | %-*s",
    fileWidth, "File",
    titleWidth, "Title"
  )

  separator = sprintf(
    "%s-+-%s",
    paste(rep("-", fileWidth), collapse = ""),
    paste(rep("-", titleWidth), collapse = "")
  )

  rows = sprintf(
    "%-*s | %-*s",
    fileWidth, ids,
    titleWidth, ifelse(is.na(titles) | titles == "", "(no title)", titles)
  )

  cat(header, "\n", separator, "\n", paste(rows, collapse = "\n"), "\n", sep = "")

  invisible(ids)
}

#' @rdname listCaseStudies
#' @export
listCS = function() {
  listCaseStudies()
}

#' @rdname listCaseStudies
#' @export
lcs = function() {
  listCaseStudies()
}
