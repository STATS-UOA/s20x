#' Crossed Factors
#' 
#' Computes a factor that has a level for each combination of the factors
#' 'fac1' and 'fac2'.
#' 
#' 
#' @param x the name of the first factor or a formula in the form \code{~ fac1 * fac2}
#' @param fac2 the name of the second factor - ignored if \code{x} is a formula.
#' @param formula a formula in the form \code{~ fac1 * fac2}
#' @param data an optional data frame in which to evaluate the formula
#' @param \dots Optional arguments
#' @return Returns a vector containing the factor which represents the
#' interaction of the given factors.
#' @note This function actually returns a \code{factor} now instead of a character string, so coercion into a \code{factor} is no longer necessary.
#' @seealso \code{\link{factor}}.
#' @keywords models
#' @examples
#' 
#' ## arousal data:
#' data(arousal.df)
#' gender.picture = crossFactors(arousal.df$gender, arousal.df$picture)
#' gender.picture
#' 
#' ## arousal data:
#' data(arousal.df)
#' gender.picture = crossFactors(~ gender * picture, data = arousal.df)
#' gender.picture
#' 
#' 
#' @export crossFactors
crossFactors = function(x, fac2 = NULL, ...) {
  UseMethod("crossFactors")
}

#' @describeIn crossFactors Crossed Factors
#' @export
crossFactors.default = function(x, fac2 = NULL, ...) {
  fac1 = x
  fac1.fac2 = factor(paste(fac1, fac2, sep = "."))
  
  return(fac1.fac2)
}

#' @describeIn crossFactors Crossed Factors
#' @export
crossFactors.formula = function(formula, fac2 = NULL, data = NULL, ...) {
  if (missing(formula) || length(formula) != 2) {
    stop("'formula' missing or incorrect")
  }
  
  m = match.call()
  m$drop.unused.levels = TRUE
  m[[1]] = as.name("model.frame")
  mf = eval(m, parent.frame())
  
  Terms = attr(mf, "terms")
  fac1 = mf[, 1]
  fac2 = mf[, 2]
  
  crossFactors.default(fac1, fac2)
}
