#' Model checking plots
#' 
#' Plots four model checking plots: an pred-res plot (residuals against predicted values), a Normal
#' Quantile-Quantile (Q-Q) plot, a histogram of the residuals with a normal distribution super-imposed
#' and a Cook's Distance plot.  
#' 
#'
#' @param x a vector of observations, or the residuals from fitting a linear model.  Alternatively, a fitted \code{lm} object.
#' If \code{x} is a single vector, then the implicit assumption is that the mean (or null) model is being 
#' fitted, i.e. \code{lm(x ~ 1)} and that the data are best summarised by the sample mean. 
#' @param plotOrder the order of the plots. 1: pred-res plot, 2: normal Q-Q plot, 3: histogram, 4: Cooks's
#' Distance plot.
#' @param xlab a title for the x-axis of both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param ylab a title for the y-axis of both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param main a title for both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param col a color for the bars of the histogram.
#' @param bootstrap if \code{TRUE} then \code{B} samples will be taken from a Normal distribution 
#' with the same mean and standard deviation as \code{x}. These will be plotted in a lighter colour behind the
#' empirical quantiles so that we can see how much variation we would expect in the Q-Q plot for a
#' sample of the same size from a truly normal distribution.
#' @param B the number of bootstrap samples to take. Five should be sufficient, but hey maybe you want more?
#' @param shapiro.wilk if \code{TRUE}, then in the top left hand corner of the
#' Q-Q plot, the P-value from the Shapiro-Wilk test for normality is displayed.
#' @param \dots additional arguments which are passed to both \code{qqnorm} and \code{hist}
#' @seealso \code{\link{shapiro.test}}.
#' @keywords hplot
#' @examples
#' 
#' # An exponential growth curve
#' e = rnorm(100, 0, 0.1)
#' x = rnorm(100)
#' y = exp(5 + 3 * x + e)
#' fit = lm(y ~ x)
#' modcheck(fit)
#' 
#' # An exponential growth curve with the correct transformation
#' fit = lm(log(y) ~ x)
#' modcheck(fit)
#' 
#' # Same example as above except we use normcheck.default
#' modcheck(residuals(fit))
#' 
#' # Peruvian Indians data
#' data(peru.df)
#' modcheck(lm(BP ~ weight, data = peru.df))
#' 
#' @export modcheck
modcheck = function(x, ...) {
  UseMethod("modcheck")
}


modcheck.default = function(x, plotOrder = 1:4, 
                            args = list(predResArgs, normcheckArgs, cooksArgs),
                            ...){
  
  if(!all(plotOrder %*% 1:4)){
    stop("plotOrder must be in 1:4")
  }
  
  oldPar = par(mfrow = c(2, 2))
  
  Plots = c(eovcheck, normcheck, normcheck, cooks20x)
  
  on.exit(par(oldPar))
}