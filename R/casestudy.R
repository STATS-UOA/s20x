#' Render a case study to HTML
#'
#' Renders a specified case study R Markdown file shipped with the package to
#' HTML and optionally opens it in a web browser.
#'
#' Case studies are expected to live in \code{inst/case_studies} and to be named
#' using the pattern \code{CS<chapter>_<number>.Rmd} (for example,
#' \code{CS9_2.Rmd}).
#'
#' @param id A case study identifier. Flexible formats are accepted, including
#'   \code{"CS9_2"}, \code{"CS9.2"}, \code{"9_2"}, or \code{"9.2"}.
#' @param output_dir Directory where the rendered HTML file should be written.
#'   Defaults to a temporary directory.
#' @param open Logical; if \code{TRUE} (default), open the rendered HTML file in
#'   the default web browser.
#' @param quiet Logical; passed to \code{rmarkdown::render()} to suppress output.
#' @param ... Additional arguments passed to \code{rmarkdown::render()}.
#'
#' @details
#' The case study is rendered on demand using \code{rmarkdown::render()}.
#' Figures and other outputs are generated at render time; users therefore need
#' any required packages installed for the selected case study.
#'
#' The rendered HTML file is returned invisibly.
#'
#' @return
#' Invisibly returns the path to the rendered HTML file.
#'
#' @examples
#' \dontrun{
#' casestudy("CS9_2")
#' casestudy("9.2")
#' cs("9_2")
#' }
#'
#' @export
casestudy = function(
    id,
    output_dir = tempfile("s20x_case_study_"),
    open = interactive(),
    quiet = TRUE,
    ...
) {
  if (!is.character(id) || length(id) != 1 || !nzchar(id)) {
    stop("`id` must be a single, non-empty character string.", call. = FALSE)
  }
  
  # Normalise input to chapter + number
  id_clean = toupper(id)
  id_clean = gsub("^CS", "", id_clean)
  id_clean = gsub("\\.", "_", id_clean)
  
  m = regexec("^(\\d+)_([0-9]+)$", id_clean)
  g = regmatches(id_clean, m)[[1]]
  
  if (length(g) == 0) {
    stop(
      "Could not interpret case study identifier '", id,
      "'. Expected formats include CS9_2, CS9.2, 9_2, or 9.2.",
      call. = FALSE
    )
  }
  
  cs_id = paste0("CS", g[2], "_", g[3])
  rmd = system.file("case_studies", paste0(cs_id, ".Rmd"), package = "s20x")
  
  if (rmd == "") {
    stop(
      "Case study '", cs_id, "' was not found in this package.\n",
      "Use listCaseStudies() to see available case studies.",
      call. = FALSE
    )
  }
  
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  
  # Work in a temporary directory so relative paths behave sensibly
  workdir = tempfile(paste0("s20x_", cs_id, "_"))
  dir.create(workdir, recursive = TRUE, showWarnings = FALSE)
  
  local_rmd = file.path(workdir, basename(rmd))
  file.copy(rmd, local_rmd, overwrite = TRUE)
  
  # Render
  out = rmarkdown::render(
    input = local_rmd,
    output_dir = output_dir,
    quiet = quiet,
    envir = .GlobalEnv,
    ...
  )
  
  if (open) {
    utils::browseURL(out)
  }
  
  invisible(out)
}

#' @rdname casestudy
#' @export
cs = function(...) {
  casestudy(...)
}
