#' Layout
#'
#' Allows a `numRows` by `numCols` matrix of plots to be displayed in a single
#' plot. If the function is called with no arguments, then the plotting device
#' layout will be reset to a single plot.
#'
#' @param numRows Number of rows in the plot array.
#' @param numCols Number of columns in the plot array.
#'
#' @return No return value.
#' @keywords device
#' @note This is a legacy convenience wrapper retained for compatibility with
#'   older teaching material. New code can use \code{par(mfrow = ...)}
#'   directly.
#'
#' @examples
#' data(course.df)
#' layout20x(1, 2)
#' stripchart(course.df$Exam)
#' boxplot(course.df$Exam)
#'
#' @export layout20x
layout20x = function(numRows = 1, numCols = 1) {
  par(mfrow = c(numRows, numCols))
}
