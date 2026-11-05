# Internal helpers for plotting engines

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
#' Keeps ggplot2 diagnostic plots visually close to the original
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
