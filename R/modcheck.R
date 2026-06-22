#' Deprecated model checking plots
#' 
#' `modcheck()` is deprecated and is no longer exported. It plots four model checking plots: residuals versus fitted values, a normal
#' Q-Q plot, a histogram of residuals with a normal distribution superimposed,
#' and a Cook's distance plot.
#' 
#'
#' @param x a vector of observations, or the residuals from fitting a linear model.  Alternatively, a fitted \code{lm} object.
#' If \code{x} is a single vector, then the implicit assumption is that the mean (or null) model is being 
#' fitted, i.e. \code{lm(x ~ 1)} and that the data are best summarised by the sample mean. 
#' @param plotOrder the order of the plots: 1 for residuals versus fitted
#' values, 2 for the normal Q-Q plot, 3 for the histogram, and 4 for Cook's
#' distance plot.
#' @param args a list containing three additional lists \code{eovcheckArgs}, \code{normcheckArgs} and
#' \code{cooksArgs}. The elements of these lists are the optional arguments of \code{\link{eovcheck}},
#' \code{\link{normcheck}} and \code{\link{cooks20x}}, and are explained in more detail in those functions.
#' Most users will never use these arguments, but they provide extra flexibility
#' in terms of what is displayed.
#' @return Draws the selected model checking plots for teaching diagnostics. The
#' function is called for its plotting side effects and does not provide a stable
#' data return object.
#' @param parVals the values that are set via \code{\link{par}} for this plot. These are \code{mfrow}, 
#' \code{xaxs}, \code{yaxs}, \code{pty}, and \code{mai}. Most users will never use these arguments, but 
#' they provide extra flexibility in terms of what is displayed.
#' @param \ldots additional parameters. Included for future flexibility, but unsure how this might be 
#' used currently.
#' @keywords hplot
#' @examplesIf FALSE
#' # This legacy helper is no longer exported. Use modelcheck(), eovcheck(),
#' # normcheck(), and cooks20x() directly in new teaching material.
#'
#' @importFrom methods is
modcheck = function(x, ...) {
  .Deprecated(
    msg = "modcheck() is deprecated and is no longer exported; use eovcheck(), normcheck(), and cooks20x() directly."
  )
  UseMethod("modcheck")
}


#' @describeIn modcheck Model checking plots
modcheck.lm = function(x, plotOrder = 1:4, 
                       args = list(eovcheck = list(smoother = FALSE, 
                                                      twosd = FALSE, 
                                                      levene = FALSE, ...), 
                                   normcheck = list(xlab = c("Theoretical Quantiles", ""), 
                                                        ylab = c("Sample Quantiles", ""),
                                                        main = c("", ""), col = "light blue",
                                                        bootstrap = FALSE, B = 5, bpch = 3, bcol = "lightgrey",
                                                        shapiro.wilk = FALSE, 
                                                        whichPlot = 1:2,
                                                        usePar = TRUE, ...), 
                                   cooks20x = list(main = "Cook's Distance plot",
                                                    xlab = "observation number", 
                                                    ylab = "Cook's distance", 
                                                    line = c(0.5, 0.1, 2), 
                                                    cex.labels = 1, 
                                                    axisOpts = list(xAxis = TRUE), ...)),
                       parVals = list(mfrow = c(2, 2),
                                      xaxs = "r", yaxs = "r", pty = "s",
                                      mai = c(0.2, 0.2, 0.05, 0.05)),
                       ...){
  if (missing(x) || !is(x, "lm")) 
    stop("missing or incorrect lm object")
  
  if(!all(plotOrder %in% 1:4)){
    stop("plotOrder must be in 1:4")
  }
  
  restoreGraphicsParameters = saveGraphicsParameters(parVals)
  on.exit(restoreGraphicsParameters())
  
  Plots = c(eovcheck, normcheck, normcheck, cooks20x)[plotOrder]
  
  for(p in plotOrder){
    if(p == 1){
      args$eovcheck$axes = FALSE
      args$eovcheck$ylab = ""
      args$eovcheck$x = formula(x$call$formula)
      args$eovcheck$data = data.frame(eval(x$call$data, parent.frame())) #x$model
      do.call(what = eovcheck, args = args$eovcheck)
      title(xlab = "Fitted values", line = 0)
      title(ylab = "Residuals", line = 0)
      box()
    }else if(p == 2){
      args$normcheck$x = x
      args$normcheck$whichPlot = 1
      args$normcheck$usePar = FALSE
      do.call(what = normcheck, args = args$normcheck)
    }else if(p == 3){
      args$normcheck$x = x
      args$normcheck$whichPlot = 2
      args$normcheck$usePar = FALSE
      do.call(what = normcheck, args = args$normcheck)
    }else{
      args$cooks20x$x = x
      args$cooks20x$axisOpts$xAxis = FALSE
      args$cooks20x$axisOpts$yAxisTight = TRUE
      do.call(what = cooks20x, args = args$cooks20x)
    }
  }
}
