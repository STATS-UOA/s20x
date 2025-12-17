#' List available case studies
#'
#' Lists all case study R Markdown files shipped with the package and returns
#' them in numerical order, together with their titles.
#'
#' Case studies are expected to live in \code{inst/case_studies} and to be named
#' using the pattern \code{CS<chapter>_<number>.Rmd} (e.g. \code{CS9_2.Rmd}).
#'
#' @details
#' The returned object is a named character vector. Each element has the form
#' \code{"CSx_y: <title>"}, and the names are the case study identifiers
#' (e.g. \code{"CS9_2"}).
#'
#' Sorting is numerical rather than alphabetical, so for example
#' \code{CS17_1} appears after \code{CS9_2}.
#'
#' @return
#' A named character vector of case study identifiers and titles. If no case
#' studies are found, an empty character vector is returned.
#'
#' @examples
#' \dontrun{
#' listCaseStudies()
#' listCS()
#' lcs()
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
    return(character())
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
    
    title
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
  
  out = vapply(
    info,
    function(x) {
      if (is.na(x$title) || !nzchar(x$title)) {
        x$id
      } else {
        paste0(x$id, ": ", x$title)
      }
    },
    character(1)
  )
  
  names(out) = vapply(info, `[[`, character(1), "id")
  out
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
