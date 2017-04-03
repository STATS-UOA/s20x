#' Layout
#' 
#' Allows an \code{numRows} by \code{numCols} matrix of plots to be displayed
#' in a single plot. If the function is called with no arguments, then the
#' plotting device layout will be reset to a single plot.
#' 
#' 
#' @param numRows number of rows in plot array
#' @param numCols number of columns in plot array
#' @return Function returns no value
#' @keywords device
#' @note This function is deprecated. It will be removed in future versions of the package.
#' @examples
#' 
#' data(course.df)
#' layout20x(1,2)
#' stripchart(course.df$Exam)
#' boxplot(course.df$Exam)
#' 
#' @export layout20x
layout20x = function(numRows = 1, numCols = 1) {
  par(mfrow = c(numRows, numCols))
}

