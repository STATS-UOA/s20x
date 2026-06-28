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


#' Build a base-like ggplot2 theme
#'
#' Keeps optional ggplot2 diagnostic plots visually close to the original
#' teaching plots by removing the default grey panel and grid.
#'
#' @return A ggplot2 theme object.
#' @keywords internal
s20x_ggplot2_base_theme = function() {
  theme(
    panel.background = element_rect(fill = "white", colour = NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(fill = NA, colour = "black"),
    axis.line = element_blank()
  )
}
