#' Skewness Statistic
#' 
#' Calculates the skewness statistic of the data in 'x'. Values close to zero
#' correspond to reasonably symmetric data, positive values of this measure
#' indicate right-skewed data whereas negative values indicate left-skewness.
#' 
#' 
#' @param x vector containing the data.
#' @return Returns the value of the skewness.
#' @keywords univar
#' @examples
#' 
#' ##Merger data:
#' data(mergers.df)
#' skewness(mergers.df$mergerdays)
#' 
#' @export skewness
skewness = function(x) mean((x - mean(x))^3)/sd(x)^3

