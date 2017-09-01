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
#' @param args a list containing three additional lists \code{eovcheckArgs}, \code{normcheckArgs} and
#' \code{cooksArgs}. The elements of these lists are the optional arguments of \code{\link{eovcheck}},
#' \code{\link{normcheck}} and \code{\link{cooks20x}}, and are explained in more detail in those functions.
#' Most users will never use these arguments, but they provide super-flexibility in terms of what is 
#' displayed.
#' @param parVals the values that are set via \code{\link{par}} for this plot. These are \code{mfrow}, 
#' \code{xaxs}, \code{yaxs}, \code{pty}, and \code{mai}. Most users will never use these arguments, but 
#' they provide super-flexibility in terms of what is displayed.
#' @param \ldots additional paramaters. Included for future flexibility, but unsure how this might be 
#' used currently.
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
                       args = list(predResArgs = list(smoother = FALSE, 
                                                      twosd = FALSE, 
                                                      levene = FALSE, ...), 
                                   normcheckArgs = list(xlab = c("Theoretical Quantiles", ""), 
                                                        ylab = c("Sample Quantiles", ""),
                                                        main = c("", ""), col = "light blue",
                                                        bootstrap = FALSE, B = 5, bpch = 3, bcol = "lightgrey",
                                                        shapiro.wilk = FALSE, 
                                                        whichPlot = 1:2,
                                                        usePar = TRUE, ...), 
                                   cooksArgs = list(main = "Cook's Distance plot",
                                                    xlab = "observation number", 
                                                    ylab = "Cook's distance", 
                                                    line = c(0.5, 0.1, 2), 
                                                    cex.labels = 1, 
                                                    axisOpts = list(xAxis = TRUE), ...)),
                       parVals = list(mfrow = c(2, 2),
                                      xaxs = "r", yaxs = "r", pty = "s",
                                      mai = c(0.2, 0.2, 0.05, 0.05)),
                       ...){
  if (missing(x) || (class(x) != "lm")) 
    stop("missing or incorrect lm object")
  
  if(!all(plotOrder %in% 1:4)){
    stop("plotOrder must be in 1:4")
  }
  
  oldPar = par(parVals)
  
  Plots = c(eovcheck, normcheck, normcheck, cooks20x)[plotOrder]
  
  for(p in plotOrder){
    if(p == 1){
      eovcheck(x, axes = FALSE)
      title(xlab = "Fitted values", line = 1)
      box()
    }else if(p == 2){
      normcheck(x, whichPlot = 1, usePar = FALSE, bootstrap = TRUE)
    }else if(p == 3){
      normcheck(x, whichPlot = 2, usePar = FALSE)
    }else{
      cooks20x(x)
    }
  }
  
  on.exit(par(oldPar))
}