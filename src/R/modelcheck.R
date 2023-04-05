#' Model checking plots
#' Compact layout for model checking plots.
#'
#' @param x The fitted model.
#' @param which The plot(s) to be drawn. Residuals vs fitted values (
#' \code{which = v1}), 
#' histogram and QQ plot of residuals (\code{which = 2}), Cook's distance plot 
#' (\code{which = 2}).
#' @param mar Margins applied to each selected plot.
#' @param \ldots any other arguments to pass to \code{\link{plot}}
#' @examples
#' x = 1:30
#' y = rnorm(30)
#' lm.fit = lm(y~x)
#' # Plot resids vs fitted only
#' modelcheck(lm.fit, 1)
#' 
#' # Plot resids vs fitted, and histogram and QQ plot
#' modelcheck(lm.fit, 1:2)
#' 
#' # Plot all
#' modelcheck(lm.fit)
#' @export
modelcheck = function(x, ...) {
  UseMethod("modelcheck")
}

#' @describeIn modelcheck Model checking plots
#' @export
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
  oldPar = par("mar","mgp")
  on.exit(par(oldPar))
  
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