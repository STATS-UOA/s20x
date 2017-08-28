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
#' # Peruvian Indians data
#' data(peru.df)
#' modcheck(lm(BP ~ weight, data = peru.df))
#' 
#' @export modcheck 
modcheck = function(x, ...) {
  UseMethod("modcheck")
}


#' @export
#' @describeIn modcheck Model checking plots
modcheck.lm = function(x, plotOrder = 1:4, 
                       args = list(predResArgs, normcheckArgs, cooksArgs),
                       ...){
  if (missing(x) || (class(x) != "lm")) 
    stop("missing or incorrect lm object")
  
  if(!all(plotOrder %in% 1:4)){
    stop("plotOrder must be in 1:4")
  }
  
  oldPar = par(mfrow = c(2, 2))
  
  Plots = c(eovcheck, normcheck, normcheck, cooks20x)[plotOrder]
  
  for(p in plotOrder){
    if(p == 1){
      eovcheck(x)
    }else if(p == 2){
      normcheck(x, whichPlot = 1, usePar = FALSE)
    }else if(p == 3){
      normcheck(x, whichPlot = 2, usePar = FALSE)
    }else{
      cooks20x(x)
    }
  }
  
  on.exit(par(oldPar))
}