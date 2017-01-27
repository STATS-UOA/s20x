#' Trend and scatter plot
#' 
#' Plots a scatter plot for the variables x, y along with a lowess smooth for
#' the underlying trend. One standard deviation error bounds for the scatter
#' about this trend are also plotted.
#' 
#' 
#' @aliases trendscatter trendscatter.default trendscatter.formula
#' @param x the coordinates of the points in the scatter plot. Alternatively, a
#' function.
#' @param y the y coordinates of the points in the plot, ignored if 'x' is a
#' function.
#' @param f the smoother span. This gives the proportion of points in the plot
#' which influence the smooth at each value. Larger values give more
#' smoothness.
#' @param data an optional data frame containing the variables in the model.
#' @param xlab a title for the x axis: see \code{\link{title}}.
#' @param ylab a title for the y axis: see \code{\link{title}}.
#' @param main a title for the plot: see \code{\link{title}}.
#' @param \dots Optional arguments
#' @return Returns the plot.
#' @seealso 'residPlot'
#' @keywords hplot
#' @examples
#' 
#' # A simple polynomial
#' x=rnorm(100)
#' e=rnorm(100)
#' y=2+3*x-2*x^2+4*x^3+e
#' trendscatter(y~x)
#' 
#' # An exponential growth curve
#' e=rnorm(100,0,0.1)
#' y=exp(5+3*x+e)
#' trendscatter(log(y)~x)
#' 
#' # Peruvian Indians data
#' data(peru.df)
#' trendscatter(BP~weight, data=peru.df)
#' 
#' # Note: this usage is deprecated
#' with(peru.df,trendscatter(weight,BP))
#' 
#' @export trendscatter
trendscatter = function(x, ...) {
    UseMethod("trendscatter")
}

trendscatter.default = function(x, y = NULL, f = 0.5, xlab = NULL, ylab = NULL, main = NULL, ...) {
    if (is.null(xlab)) 
        xlab = deparse(substitute(x))
    if (is.null(ylab)) 
        ylab = deparse(substitute(y))
    xs = sort(x, index = TRUE)
    x = xs$x
    ix = xs$ix
    y = y[ix]
    trend = lowess(x, y, f)
    e2 = (y - trend$y)^2
    scatter = lowess(x, e2, f)
    uplim = trend$y + sqrt(abs(scatter$y))
    lowlim = trend$y - sqrt(abs(scatter$y))
    plot(x, y, pch = 1, xlab = xlab, ylab = ylab, main = ifelse(is.null(main), paste("Plot of", ylab, "vs.", xlab, "  (lowess+/-sd)"), main))
    dots = list(...)
    
    lwd = 1
    
    if ("lwd" %in% names(dots)) {
        lwd = dots$lwd
    }
    
    col1 = "blue"
    col2 = "red"
    
    if ("col" %in% names(dots)) {
        if (length(dots$col) == 2) {
            col1 = dots$col[1]
            col2 = dots$col[2]
        } else {
            col1 = dots$col
        }
    }
    
    lines(trend, col = col1, lwd = lwd)
    lines(scatter$x, uplim, lty = 2, col = col2, lwd = lwd)
    lines(scatter$x, lowlim, lty = 2, col = col2, lwd = lwd)
}

trendscatter.formula = function(x, f = 0.5, data = NULL, xlab = NULL, ylab = NULL, main = NULL, ...) {
    if (missing(x) || (length(x) != 3)) 
        stop("missing or incorrect formula")
    
    if (is.null(data)) 
        vars = eval(attr(terms(x), "variables"), parent.frame()) else vars = eval(attr(terms(x), "variables"), data)
    nms = rownames(eval(attr(terms(x), "factors")))
    
    if (is.null(xlab)) 
        xlab = nms[2]
    if (is.null(ylab)) 
        ylab = nms[1]
    
    trendscatter(vars[[2]], vars[[1]], f = f, xlab = xlab, ylab = ylab, main = main, ... = ...)
}

