#' Cook's distance plot
#' 
#' Draws a Cook's distance plot.
#' 
#' 
#' @param x an object of class \code{lm}, usually obtained by using the \code{\link{lm}} function.
#' @param main the plot title
#' @param xlab the x-axis title.
#' @param ylab the y-axis title.
#' @param line a vector of length 3 controlling the distances of the plot title, the x-axis title and the y-axis title 
#'             from the axis in line units.
#' @param cex.labels a factor controlling the font size of the labels on suspected high influence points.
#' @param axisOpts a list of additional arguments that can be used to control the axes. At this point
#' this list only contains one element \code{xAxis} which is logical. If \code{xAxis == TRUE} then the 
#' x-axis will be displayed, and clearly, if it is \code{FALSE}, then it will not.  
#' @param \dots additional arguments are passed to \code{plot} and may provide some extra flexibility.
#' 
#' @return Returns the plot and identifies the three highest Cook's values
#' @keywords hplot
#' @examples
#' 
#' # Peruvian Indians data
#' data(peru.df)
#' peru.fit = lm(BP ~ age + years + I(years^2) + weight + height, data = peru.df)
#' cooks20x(peru.fit)
#' 
#' @export cooks20x
cooks20x = function(x, main = "Cook's Distance plot", xlab = "observation number", ylab = "Cook's distance", 
                    line = c(0.5, 0.1, 2), cex.labels = 1, axisOpts = list(xAxis = TRUE, yAxisTight = FALSE), ...) {
  
    y = cooks.distance(x)
    show.r = order(-y)[1:3]
    plot(1:length(y), y, type = "h", xlab = "", ylab = "", main = "", ylim = c(0, max(y) * 1.1), axes = FALSE, yaxs = "i", ...)
    
    dots = list(...)
    
    if(axisOpts$xAxis){
      title(xlab = xlab, line = line[2])
      axis(1, mgp = c(0.3, 0.3, 0))
    }
    
    if(axisOpts$yAxisTight){
      axis(2, mgp = c(0.3, 0.5, 0))
    }else{
      axis(2)
    }
    
    box()
    
    title(main = main, line = line[1])
    title(ylab = ylab, line = line[3])
    
    text(show.r, y[show.r] + 0.4 * 0.75 * strheight(" "), show.r, cex = cex.labels)
}

