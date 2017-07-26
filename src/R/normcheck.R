#' Testing for normality plot
#' 
#' Plots two plots side by side. Firstly it draws a Normal QQ-plot of the
#' residuals, along with a line which has an intercept at the mean of the
#' residuals and a slope equal to the standard deviation of the residuals. If
#' \code{shapiro.wilk = TRUE} then, in the top left hand corner of the Q-Q
#' plot, the P-value from the Shapiro-Wilk test for normality is given.
#' Secondly, it draws a histogram of the residuals. A normal distribution is
#' fitted and superimposed over the histogram.
#' 
#' 
#' @param x the residuals from fitting a linear model.  Alternatively, a fitted \code{lm} object.
#' @param xlab a title for the x axis: see \code{\link{title}}.
#' @param main a title for the x axis: see \code{\link{title}}.
#' @param col a color for the bars of the histogram.
#' @param shapiro.wilk if \code{TRUE}, then in the top left hand corner of the
#' Q-Q plot, the P-value from the Shapiro-Wilk test for normality is displayed.
#' @param \dots Optional arguments
#' @seealso \code{\link{shapiro.test}}.
#' @keywords hplot
#' @examples
#' 
#' # An exponential growth curve
#' e = rnorm(100, 0, 0.1)
#' x = rnorm(100)
#' y = exp(5 + 3 * x + e)
#' fit = lm(y ~ x)
#' normcheck(fit)
#' 
#' # An exponential growth curve with the correct transformation
#' fit = lm(log(y) ~ x)
#' normcheck(fit)
#' 
#' # Same example as above except we use normcheck.default
#' normcheck(residuals(fit))
#' 
#' # Peruvian Indians data
#' data(peru.df)
#' normcheck(lm(BP ~ weight, data = peru.df))
#' 
#' @export normcheck
normcheck = function(x, ...) {
    UseMethod("normcheck")
}

#' @export
#' @describeIn normcheck Testing for normality plot
normcheck.default = function(x, xlab = c("Theoretical Quantiles", ""), 
                                ylab = c("Sample Quantiles", ""),
                                main = c("", ""), col = "light blue", 
                                shapiro.wilk = FALSE, ...) {
    
    if (xlab[2] == "") 
        xlab[2] = deparse(substitute(x))
    
    col = match.arg(col, c("light blue", colors()))
    
    ## only grab the parameters that are going to be set
    oldPar = par(c("mfrow", "xaxs", "yaxs", "pty", "mai"))
    
    
    
    ## change the layout of the plotting window only if it has not already been set
    if (all(oldPar$mfrow == c(1, 1))) {
        par(mfrow = c(1, 2), xaxs = "i", yaxs = "i", pty = "s",
            mai = c(0.1, 0.2, 0, 0.05))
        on.exit(par(mfrow = oldPar))
    }
    
    qqp = qqnorm(x, axes = FALSE, xlab = "", ylab = "", main = "")
    qqline(x, col = "black")
    box()
    title(xlab = xlab[1], line = 0.05)
    title(ylab = ylab[1], line = 0.05)
    if(main[1] != ""){
      title(main = main[1])
    }
    
    mx = mean(x)
    sx = sd(x)
    
    if (shapiro.wilk) {
        stest = shapiro.test(x)
        txt = paste("Shapiro-Wilk normality test", "\n", "W = ", round(stest$statistic, 4), "\n", "P-value = ", round(stest$p.value, 3), sep = "")
        text(sort(qqp$x)[2], 0.99 * sort(qqp$y)[length(qqp$y)], txt, adj = c(0, 1))
    }
    
    h = hist(x, plot = FALSE)
    rx = range(x)
    xmin = min(rx[1], mx - 3.5 * sx, h$breaks[1])
    xmax = max(rx[2], mx + 3.5 * sx, h$breaks[length(h$breaks)])
    
    
    ymax = max(h$density, dnorm(mx, mx, sx)) * 1.05
    
    hist(x, prob = TRUE, ylim = c(0, ymax), xlim = c(xmin, xmax), col = col,
         xlab = "", ylab = "", main = "", axes = FALSE)
    w = strwidth(xlab[2], units = "figure")
    
    if(w < 0.95){
      title(xlab = xlab[2], line = 0.05)
    }else{
      m = 1 / (w * 1.1)
      title(xlab = xlab[2], line = 0.05, cex.lab = m)
    }
    title(ylab = ylab[2], line = 0.05)
    title(main = main[2], line = 0.05)
    box()
    
    x1 = seq(xmin, xmax, length = 100)
    y1 = dnorm(x1, mx, sx)
    lines(x1, y1, lwd = 1.5, lty = 3)
}

#' @export
#' @describeIn normcheck Testing for normality plot
normcheck.lm = function(x, xlab = c("Theoretical Quantiles", ""), 
                           ylab = c("Sample Quantiles", ""),
                           main = c("", ""), col = "light blue",  
                           shapiro.wilk = FALSE, ...){
    if (missing(x) || (class(x) != "lm")) 
        stop("missing or incorrect lm object")
    
    
    if (xlab[2] == "") 
        xlab[2] = paste("Residuals from lm(", as.character(x$call[2]), ")", sep = "")
    
    x = residuals(x)
    normcheck(x, xlab = xlab, main = main, col = col, shapiro.wilk = shapiro.wilk, ...)
}

