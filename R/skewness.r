#' Skewness Statistic
#' 
#' Calculates the skewness statistic of the data in 'x'. Values close to zero
#' correspond to reasonably symmetric data, positive values of this measure
#' indicate right-skewed data whereas negative values indicate left-skewness.
#' 
#' 
#' @param x vector containing the data.
#' @param \dots any other variables to be passed to \code{mean} and \code{sd}, e.g. 
#' \code{na.rm = TRUE}.
#' @return Returns the value of the skewness.
#' @keywords univar
#' @examples
#' 
#' ##Merger data:
#' data(mergers.df)
#' skewness(mergers.df$mergerdays)
#' 
#' @export skewness
skewness = function(x, ...){
  mx = mean(x, ...)
  sx = sd(x, ...)
  mean((x - mx)^3, ...)/sx^3
} 

