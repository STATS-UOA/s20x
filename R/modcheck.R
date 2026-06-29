#' Deprecated model checking plots
#'
#' `modcheck()` is deprecated and is no longer exported. It plots four model
#' checking plots: residuals versus fitted values, a normal Q-Q plot, a
#' histogram of residuals with a normal distribution superimposed, and a Cook's
#' distance plot.
#'
#' @param x a vector of observations, or the residuals from fitting a linear model.  Alternatively, a fitted \code{lm} object.
#' If \code{x} is a single vector, then the implicit assumption is that the mean (or null) model is being 
#' fitted, i.e. \code{lm(x ~ 1)} and that the data are best summarised by the sample mean. 
#' @return Draws the selected model checking plots for teaching diagnostics. The
#' function is called for its plotting side effects and does not provide a stable
#' data return object.
#' @param \ldots additional parameters. Included for future flexibility, but unsure how this might be 
#' used currently.
#' @keywords hplot
#' @importFrom methods is
modcheck = function(x, ...) {
  .Deprecated(
    msg = "modcheck() is deprecated and is no longer exported; use eovcheck(), normcheck(), and cooks20x() directly."
  )
  UseMethod("modcheck")
}


