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
#' \dontrun{
#' listCaseStudies()
#' ids = listCaseStudies()
#' }
#'
#' @export
listCaseStudies = function() {
  cs_dir = system.file("case_studies", package = "s20x")
  if (cs_dir == "") {
    stop("No case_studies directory found in package.", call. = FALSE)
  }
  
  files = list.files(cs_dir, pattern = "\\.Rmd$", full.names = TRUE)
  if (length(files) == 0) {
    return(invisible(character()))
  }
  
  extract_title = function(file) {
    lines = readLines(file, warn = FALSE)
    
    start = which(trimws(lines) == "---")[1]
    end   = which(trimws(lines) == "---")[2]
    if (is.na(start) || is.na(end) || end <= start) {
      return(NA_character_)
    }
    
    yaml = lines[(start + 1):(end - 1)]
    idx = grep("^title\\s*:", yaml)
    if (length(idx) == 0) {
      return(NA_character_)
    }
    
    title = sub("^title\\s*:\\s*", "", yaml[idx[1]])
    title = trimws(title)
    title = sub('^"(.*)"$', "\\1", title)
    title = sub("^'(.*)'$", "\\1", title)
    trimws(title)
  }
  
  parse_number = function(fname) {
    base = tools::file_path_sans_ext(basename(fname))
    m = regexec("^CS(\\d+)_([0-9]+)$", base)
    g = regmatches(base, m)[[1]]
    if (length(g) == 0) return(c(NA, NA))
    c(as.integer(g[2]), as.integer(g[3]))
  }
  
  info = lapply(files, function(f) {
    num = parse_number(f)
    list(
      id = tools::file_path_sans_ext(basename(f)),
      major = num[1],
      minor = num[2],
      title = extract_title(f)
    )
  })
  
  info = Filter(function(x) !is.na(x$major), info)
  
  ord = order(
    vapply(info, `[[`, integer(1), "major"),
    vapply(info, `[[`, integer(1), "minor")
  )
  info = info[ord]
  
  ids = vapply(info, `[[`, character(1), "id")
  titles = vapply(info, `[[`, character(1), "title")
  
  # Column widths
  file_width  = max(nchar(c("File", ids)))
  title_width = max(nchar(c("Title", titles)), na.rm = TRUE)
  
  # Header
  header = sprintf(
    "%-*s | %-*s",
    file_width, "File",
    title_width, "Title"
  )
  
  separator = sprintf(
    "%s-+-%s",
    paste(rep("-", file_width), collapse = ""),
    paste(rep("-", title_width), collapse = "")
  )
  
  rows = sprintf(
    "%-*s | %-*s",
    file_width, ids,
    title_width, ifelse(is.na(titles) | titles == "", "(no title)", titles)
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
