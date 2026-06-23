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

#' Match a plotting engine argument
#'
#' Applies the standard plotting engine argument matching used by exported
#' plotting functions. Keeping this in one place makes engine-dispatch cleanup
#' stages less repetitive without changing the accepted engine values.
#'
#' @param engine character plotting engine argument.
#' @param choices character vector of accepted plotting engines.
#' @return The matched plotting engine.
#' @keywords internal
matchPlottingEngine = function(engine, choices = c("base", "ggplot2")) {
  match.arg(engine, choices)
}

#' Get an exported function from an optional plotting package
#'
#' Retrieves a plotting function after the caller has checked that the optional
#' package is available. This keeps dynamic optional-package lookups in one
#' helper rather than repeating direct exported-value retrieval in each plotting
#' implementation.
#'
#' @param package character name of the optional plotting package.
#' @param functionName character name of the exported function to retrieve.
#' @return The exported function object.
#' @keywords internal
getPlottingFunction = function(package, functionName) {
  getExportedValue(package, functionName)
}
