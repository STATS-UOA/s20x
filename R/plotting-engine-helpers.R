# Internal helpers for optional plotting engines

#' Require an optional plotting package
#'
#' Checks that an optional plotting package is installed and gives a consistent
#' error message for optional plotting engines.
#'
#' @param package character name of the required optional package.
#' @param engine character name of the plotting engine being used.
#' @return Invisibly returns TRUE when the package is available.
#' @keywords internal
requirePlottingPackage = function(package, engine = "ggplot2") {
  if (!requireNamespace(package, quietly = TRUE)) {
    stop(
      "The ", engine, " engine requires the ", package, " package.",
      call. = FALSE
    )
  }

  invisible(TRUE)
}
