#' Skewness Statistic
#'
#' Calculates the skewness statistic of the data in `x`. Values close to zero
#' correspond to reasonably symmetric data. Positive values indicate right-skewed
#' data, whereas negative values indicate left-skewed data.
#'
#' @param x Vector containing the data.
#' @param \dots Additional arguments passed to [mean()] and [sd()], such as
#'   `na.rm = TRUE`.
#'
#' @return The value of the skewness statistic.
#' @keywords univar
#'
#' @examples
#' data(mergers.df)
#' skewness(mergers.df$mergerdays)
#'
#' @export skewness
skewness = function(x, ...) {
  mx = mean(x, ...)
  sx = sd(x, ...)

  mean((x - mx)^3, ...) / sx^3
}
