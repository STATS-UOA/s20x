#' Open a case study source file in the editor
#'
#' Opens a case study \code{.Rmd} file for interactive use. The file shipped
#' inside the package is copied to \code{dest_dir} (so it is writable), then
#' opened in the RStudio editor when available (otherwise the system editor).
#'
#' @param id Case study identifier. Flexible formats are accepted, including
#'   \code{"CS9_2"}, \code{"CS9.2"}, \code{"9_2"}, or \code{"9.2"}.
#' @param dest_dir Directory to copy the case study into. Defaults to the
#'   current working directory. This legacy argument is retained for
#'   compatibility; new code may use the camelCase \code{destDir} alias through
#'   \code{...}.
#' @param overwrite Logical; overwrite an existing file in \code{dest_dir}.
#' @param ... Additional compatibility arguments. Currently supports
#'   \code{destDir}, a camelCase alias for \code{dest_dir}.
#' @return Invisibly returns the path to the copied file.
#'
#' @examples
#' \dontrun{
#' openCaseStudy("2.1")
#' openCaseStudy("2.1", destDir = tempdir())
#' }
#'
#' @export
openCaseStudy = function(id, dest_dir = getwd(), overwrite = FALSE, ...) {
  if (!is.character(id) || length(id) != 1 || !nzchar(id)) {
    stop("`id` must be a single, non-empty character string.", call. = FALSE)
  }

  destDir = resolveCaseStudyDestinationDir(dest_dir = dest_dir, ...)

  idClean = toupper(id)
  idClean = gsub("^CS", "", idClean)
  idClean = gsub("\\.", "_", idClean)

  match = regexec("^(\\d+)_([0-9]+)$", idClean)
  groups = regmatches(idClean, match)[[1]]
  if (length(groups) == 0) {
    stop(
      "Could not interpret case study identifier '", id,
      "'. Expected formats include CS9_2, CS9.2, 9_2, or 9.2.",
      call. = FALSE
    )
  }

  csId = paste0("CS", groups[2], "_", groups[3])
  sourcePath = system.file("case_studies", paste0(csId, ".Rmd"), package = "s20x")
  if (sourcePath == "") {
    stop(
      "Case study '", csId, "' was not found in this package.\n",
      "Use listCaseStudies() to see available case studies.",
      call. = FALSE
    )
  }

  dir.create(destDir, recursive = TRUE, showWarnings = FALSE)
  destinationPath = file.path(destDir, basename(sourcePath))

  if (file.exists(destinationPath) && !overwrite) {
    stop(
      "File already exists: ", destinationPath, "\n",
      "Set overwrite = TRUE or choose a different destDir.",
      call. = FALSE
    )
  }

  copied = file.copy(sourcePath, destinationPath, overwrite = overwrite)
  if (!copied) {
    stop("Failed to copy case study to: ", destinationPath, call. = FALSE)
  }

  if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
    rstudioapi::navigateToFile(destinationPath)
  } else {
    utils::file.edit(destinationPath)
  }

  invisible(destinationPath)
}

resolveCaseStudyDestinationDir = function(dest_dir = getwd(), ...) {
  dots = list(...)
  dotNames = names(dots)

  if (length(dots) > 0 && (is.null(dotNames) || any(!nzchar(dotNames)))) {
    stop("Case study compatibility arguments must be named.", call. = FALSE)
  }

  unknownArgs = setdiff(dotNames, "destDir")
  if (length(unknownArgs) > 0) {
    stop(
      "Unsupported case study argument: ", paste(unknownArgs, collapse = ", "),
      call. = FALSE
    )
  }

  if ("destDir" %in% dotNames) {
    if (!identical(dest_dir, getwd())) {
      stop("Use only one of dest_dir or destDir.", call. = FALSE)
    }
    dest_dir = dots$destDir
  }

  if (!is.character(dest_dir) || length(dest_dir) != 1 || !nzchar(dest_dir)) {
    stop("`destDir` must be a single, non-empty character string.", call. = FALSE)
  }

  dest_dir
}

#' @rdname openCaseStudy
#' @export
opencs = function(id, dest_dir = getwd(), overwrite = FALSE, ...) {
  openCaseStudy(id = id, dest_dir = dest_dir, overwrite = overwrite, ...)
}

#' @rdname openCaseStudy
#' @export
ocs = function(id, dest_dir = getwd(), overwrite = FALSE, ...) {
  openCaseStudy(id = id, dest_dir = dest_dir, overwrite = overwrite, ...)
}
