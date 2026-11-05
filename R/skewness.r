#' Skewness Statistic
#'
#' Calculates the skewness statistic of the data in 'x'. Values close to zero
#' correspond to reasonably symmetric data, positive values of this measure
#' indicate right-skewed data whereas negative values indicate left-skewness.
#'
#' @param x vector containing the data.
#' @param \dots any other variables to be passed to \code{mean} and \code{sd}, e.g.
#' \code{na.rm = TRUE}.
#' @return Returns the value of the skewness.
#' @keywords univar
#' @examples
#'
#' ## Merger data:
#' data(mergers.df)
#' skewness(mergers.df$mergerdays)
#'
#' @note Deprecated in s20x 3.3.6. \code{summaryStats()} still reports skewness.
#' @export skewness
skewness = function(x, ...) {
  .Deprecated(msg = "skewness() is deprecated; summaryStats() still reports skewness.")

  skewnessStatistic(x, ...)
}

#' Calculate the skewness statistic
#'
#' @param x vector containing the data.
#' @param \dots passed to \code{mean} and \code{sd}.
#' @return The value of the skewness.
#' @noRd
skewnessStatistic = function(x, ...) {
  meanValue = mean(x, ...)
  sdValue = sd(x, ...)

  mean((x - meanValue)^3, ...) / sdValue^3
}
