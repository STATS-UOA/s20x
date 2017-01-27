#' Cook's distance plot
#' 
#' Draws a Cook's distance plot.
#' 
#' 
#' @param lmfit output from the function 'lm()'.
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
cooks20x = function(lmfit) {
  
    y = cooks.distance(lmfit)
    show.r = order(-y)[1:3]
    plot(1:length(y), y, type = "h", main = "Cook's Distance plot", xlab = "observation number", ylab = "Cook's distance")
    text(show.r, y[show.r] + 0.4 * 0.75 * strheight(" "), show.r)
}

