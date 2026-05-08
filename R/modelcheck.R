#' Deprecated model checking plots
#'
#' `modelcheck()` is deprecated and is no longer exported. Use focused
#' diagnostic helpers such as [eovcheck()], [normcheck()], and [cooks20x()]
#' directly in new teaching material.
#'
#' @param x The fitted model.
#' @param which The plot(s) to be drawn. Residuals versus fitted values
#' (\code{which = 1}), histogram and Q-Q plot of residuals
#' (\code{which = 2}), and Cook's distance plot (\code{which = 3}).
#' @param mar Margins applied to each selected plot.
#' @param \ldots any other arguments to pass to \code{\link{plot}}
#' @return Draws diagnostic plots for teaching model checking. The function is
#' called for its plotting side effects and does not provide a stable data return
#' object.
#' @examplesIf FALSE
#' data(peru.df)
#' lmFit = lm(BP ~ weight, data = peru.df)
#'
#' # Plot residuals versus fitted values only
#' # Deprecated compatibility helper, no longer exported
#' s20x:::modelcheck(lmFit, 1)
#'
#' # Plot residuals versus fitted values, histogram, and Q-Q plot
#' s20x:::modelcheck(lmFit, 1:2)
#'
#' # Plot all diagnostics
#' s20x:::modelcheck(lmFit)
modelcheck = function(x, ...) {
  .Deprecated(
    msg = "modelcheck() is deprecated and is no longer exported; use eovcheck(), normcheck(), and cooks20x() directly."
  )
  UseMethod("modelcheck")
}

#' @describeIn modelcheck Model checking plots
modelcheck.lm = function(x, which = 1:3, mar = c(3, 4, 1.5, 4), ...) {
  
  if(!all(which %in% 1:3)){
    stop("which must be in 1:3")
  }
  
  createLayoutMatrix = function(){
    M = matrix(NA, nrow = length(which), ncol = 2)
    k = 1  # Value of next plot
    
    if (1 %in% which) {
      M[1, ] = c(1, 1)
      k = k + 1
    }
    
    if (2 %in% which) {
      M[k, ] = c(k, k + 1)
      k = k + 2
    }
    
    if (3 %in% which){
      M[length(which), ] = c(k, k)
    }
    
    return(M)
  }
  
  M = createLayoutMatrix()
  layout(M)
  restoreGraphicsParameters = saveGraphicsParameters("mar", "mgp")
  on.exit(restoreGraphicsParameters())
  
  par(mar = mar, mgp = c(2, 1, 0))
  
  if (1 %in% which){
    plot(x, which = 1, ...)
  }
  
  if (2 %in% which){
    plot(x, which = 2, ...)
    hist(resid(x), xlab="Residuals",main = "Histogram of residuals")
  }
  
  if(3 %in% which){
    plot(x, which = 4, ...)
  }
  

  layout(1)
}
