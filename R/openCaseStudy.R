#' Open a case study source file in the editor
#'
#' Opens a case study \code{.Rmd} file for interactive use. The file shipped
#' inside the package is copied to \code{dest_dir} (so it is writable), then
#' opened in the RStudio editor when available (otherwise the system editor).
#'
#' @param id Case study identifier. Flexible formats are accepted, including
#'   \code{"CS9_2"}, \code{"CS9.2"}, \code{"9_2"}, or \code{"9.2"}.
#' @param dest_dir Directory to copy the case study into. Defaults to the
#'   current working directory.
#' @param overwrite Logical; overwrite an existing file in \code{dest_dir}.
#' @return Invisibly returns the path to the copied file.
#'
#' @examples
#' \dontrun{
#' openCaseStudy("2.1")
#' }
#'
#' @export
openCaseStudy = function(id, dest_dir = getwd(), overwrite = FALSE) {
  if (!is.character(id) || length(id) != 1 || !nzchar(id)) {
    stop("`id` must be a single, non-empty character string.", call. = FALSE)
  }
  
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
  src = system.file("case_studies", paste0(cs_id, ".Rmd"), package = "s20x")
  if (src == "") {
    stop(
      "Case study '", cs_id, "' was not found in this package.\n",
      "Use listCaseStudies() to see available case studies.",
      call. = FALSE
    )
  }
  
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  dst = file.path(dest_dir, basename(src))
  
  if (file.exists(dst) && !overwrite) {
    stop(
      "File already exists: ", dst, "\n",
      "Set overwrite = TRUE or choose a different dest_dir.",
      call. = FALSE
    )
  }
  
  ok = file.copy(src, dst, overwrite = overwrite)
  if (!ok) stop("Failed to copy case study to: ", dst, call. = FALSE)
  
  # Open in RStudio if available; otherwise use system editor
  if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
    rstudioapi::navigateToFile(dst)
  } else {
    utils::file.edit(dst)
  }
  
  invisible(dst)
}

#' @rdname openCaseStudy
#' @export
opencs = function(...) openCaseStudy(...)


#' @rdname openCaseStudy
#' @export
ocs = function(...) openCaseStudy(...)
