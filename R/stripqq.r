#' Deprecated strip charts and normal quantile-quantile plots
#'
#' `stripqq()` is deprecated and is no longer exported. It draws strip
#' charts and normal quantile-quantile plots of `x` for each level of the
#' grouping variable `g`.
#'
#'
#' @param formula A symbolic specification of the form \code{x ~ g} can be
#'   given, indicating the observations in the vector \code{x} are grouped
#'   according to the levels of the factor \code{g}. \code{NA}s are allowed in
#'   the data.
#' @param \ldots Optional arguments that are passed to the \code{stripchart} function.
#' @keywords hplot
#' @note This is a legacy teaching helper retained for compatibility with
#'   older course material. New teaching material should prefer current
#'   diagnostic plotting workflows.
stripqq = function(formula, ...) {
  .Deprecated(
    msg = "stripqq() is deprecated and is no longer exported."
  )
  UseMethod("stripqq")
}

