#' Deprecated box plots and normal quantile-quantile plots
#'
#' `boxqq()` is deprecated and is no longer exported. It draws boxplots
#' and normal quantile-quantile plots of `x` for each level of the grouping
#' variable `g`.
#'
#'
#' @param formula A symbolic specification of the form \code{x ~ g} can be given,
#' indicating the observations in the vector \code{x} are to be grouped according to
#' the levels of the factor \code{g}. \code{NA}'s are allowed in the data.
#' @param ... Arguments to be passed to methods, such as graphical parameters
#' (see \code{\link{par}}).
#' @return Returns the plot.
#' @keywords hplot
#' @note This is a legacy teaching helper retained for compatibility with
#'   older course material. New teaching material should prefer current
#'   diagnostic plotting workflows.
boxqq = function(formula, ...) {
  .Deprecated(
    msg = "boxqq() is deprecated and is no longer exported."
  )
  UseMethod("boxqq")
}

