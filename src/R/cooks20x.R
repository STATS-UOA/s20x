#' Cook's distance plot
#' 
#' Draws a Cook's distance plot.
#' 
#' 
#' @param lmfit output from the function 'lm()'.
#' @param main the plot title
#' @param xlab the x-axis title.
#' @param ylab the y-axis title.
#' @param line a vector of length 3 controlling the distances of the plot title, the x-axis title and the y-axis title 
#'             from the axis in line units.
#' @param cex.labels a factor controlling the font size of the labels on suspected high influence points.
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
cooks20x = function(lmfit, main = "Cook's Distance plot", xlab = "observation number", ylab = "Cook's distance", 
                    line = c(0.5, 2, 2), cex.labels = 1, ...) {
  
    y = cooks.distance(lmfit)
    show.r = order(-y)[1:3]
    plot(1:length(y), y, type = "h", xlab = "", ylab = "", main = "", ...)
    title(main = main, line = line[1])
    title(xlab = xlab, line = line[2])
    title(ylab = ylab, line = line[3])
    text(show.r, y[show.r] + 0.4 * 0.75 * strheight(" "), show.r, cex = cex.labels)
}

