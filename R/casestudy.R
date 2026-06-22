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
#'   Defaults to a temporary directory. This legacy argument is retained for
#'   compatibility; new code may use the camelCase \code{outputDir} alias
#'   through \code{...}.
#' @param open Logical; if \code{TRUE} (default), open the rendered HTML file in
#'   the default web browser.
#' @param quiet Logical; passed to \code{rmarkdown::render()} to suppress output.
#' @param ... Additional arguments passed to \code{rmarkdown::render()}. Also
#'   supports \code{outputDir}, a camelCase alias for \code{output_dir}.
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
#' if (interactive()) {
#'   casestudy("CS9_2")
#'   casestudy("9.2")
#'   casestudy("9_2", outputDir = tempdir())
#'   cs("9_2")
#' }
#'
#' @importFrom rmarkdown render
#' @importFrom utils browseURL
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

  outputArgs = resolveCaseStudyOutputArgs(
    output_dir = if (missing(output_dir)) {
      tempfile("s20x_case_study_")
    } else {
      output_dir
    },
    outputDirWasSupplied = !missing(output_dir),
    ...
  )
  outputDir = outputArgs$outputDir
  renderArgs = outputArgs$renderArgs

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
  rmd = system.file("case_studies", paste0(csId, ".Rmd"), package = "s20x")

  if (rmd == "") {
    stop(
      "Case study '", csId, "' was not found in this package.\n",
      "Use listCaseStudies() to see available case studies.",
      call. = FALSE
    )
  }

  dir.create(outputDir, recursive = TRUE, showWarnings = FALSE)

  workDir = tempfile(paste0("s20x_", csId, "_"))
  dir.create(workDir, recursive = TRUE, showWarnings = FALSE)

  localRmd = file.path(workDir, basename(rmd))
  file.copy(rmd, localRmd, overwrite = TRUE)

  out = do.call(
    render,
    c(
      list(
        input = localRmd,
        output_dir = outputDir,
        quiet = quiet,
        envir = .GlobalEnv
      ),
      renderArgs
    )
  )

  if (open) {
    browseURL(out)
  }

  invisible(out)
}

#' Resolve case-study output arguments
#'
#' Normalise legacy and camelCase output-directory arguments for `casestudy()`.
#'
#' @param output_dir legacy output directory argument.
#' @param outputDirWasSupplied logical; whether `output_dir` was supplied by the caller.
#' @param ... additional rendering arguments.
#' @return A list containing `outputDir` and remaining `renderArgs`.
#' @keywords internal
resolveCaseStudyOutputArgs = function(output_dir, outputDirWasSupplied, ...) {
  renderArgs = list(...)
  argNames = names(renderArgs)

  if (!is.null(argNames) && sum(argNames == "outputDir") > 1) {
    stop("Use only one outputDir argument.", call. = FALSE)
  }

  if (!is.null(argNames) && "outputDir" %in% argNames) {
    if (outputDirWasSupplied) {
      stop("Use only one of output_dir or outputDir.", call. = FALSE)
    }
    output_dir = renderArgs$outputDir
    renderArgs$outputDir = NULL
  }

  if (!is.character(output_dir) || length(output_dir) != 1 || !nzchar(output_dir)) {
    stop("`outputDir` must be a single, non-empty character string.", call. = FALSE)
  }

  list(
    outputDir = output_dir,
    renderArgs = renderArgs
  )
}

#' @rdname casestudy
#' @export
cs = function(...) {
  casestudy(...)
}
