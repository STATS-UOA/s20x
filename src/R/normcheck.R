#' Testing for normality plot
#' 
#' Plots two plots side by side. Firstly it draws a Normal QQ-plot of the
#' residuals, along with a line which has an intercept at the mean of the
#' residuals and a slope equal to the standard deviation of the residuals. If
#' \code{shapiro.wilk = TRUE} then, in the top left hand corner of the Q-Q
#' plot, the P-value from the Shapiro-Wilk test for normality is given.
#' Secondly, it draws a histogram of the residuals. A normal distribution is
#' fitted and superimposed over the histogram. NOTE: if you want to leave the 
#' x-axis blank in the histogram then, use \code{xlab = c("Theoretical Quantiles", " ")}
#' , i.e. leave a space between the quotes. If you don't leave a space, then information 
#' will be extracted from \code{x}. 
#' 
#' 
#' @param x the residuals from fitting a linear model.  Alternatively, a fitted \code{lm} object.
#' @param xlab a title for the x-axis of both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param ylab a title for the y-axis of both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param main a title for both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param col a color for the bars of the histogram.
#' @param bootstrap if \code{TRUE} then \code{B} samples will be taken from a Normal distribution 
#' with the same mean and standard deviation as \code{x}. These will be plotted in a lighter colour behind the
#' empirical quantiles so that we can see how much variation we would expect in the Q-Q plot for a
#' sample of the same size from a truly normal distribution.
#' @param B the number of bootstrap samples to take. Five should be sufficient, but hey maybe you want more?
#' @param shapiro.wilk if \code{TRUE}, then in the top left hand corner of the
#' Q-Q plot, the P-value from the Shapiro-Wilk test for normality is displayed.
#' @param \dots additional arguments which are passed to both \code{qqnorm} and \code{hist}
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
normcheck.default = function(x,
                             xlab = c("Theoretical Quantiles", ""), 
                             ylab = c("Sample Quantiles", ""),
                             main = c("", ""), col = "light blue",
                             bootstrap = FALSE, B = 5, bpch = 3, bcol = "lightgrey",
                             shapiro.wilk = FALSE, 
                             whichPlot = 1:2,
                             usePar = TRUE, ...) {
  
  if(!all(whichPlot %in% 1:2)){
    stop("whichPlot must be in 1:2")
  }
  
  if(length(xlab) == length(whichPlot)){
    ## if the length of the labels matches the number of plots
    ## then assume the user wants them ordered in the order given
    ## by whichPlot. This might be stupid, but I can't see this being
    ## done very often
    if(length(whichPlot) == 2){
      xlab = xlab[whichPlot]
      ylab = ylab[whichPlot]
      main = main[whichPlot]
    }
  }else{
    if(length(xlab) == 2 & length(whichPlot) == 1){
      xlab = xlab[whichPlot]
      ylab = ylab[whichPlot]
      main = main[whichPlot] 
    }
  }
  
  ## Make sure if we're drawing the histogram
  ## That the default label is not left blank
  if(2 %in% whichPlot){
    idx = which(whichPlot == 2)
    if (!is.na(xlab[idx]) && xlab[idx] == "") {
      xlab[idx] = deparse(substitute(x))
    }
  }
  
  col = match.arg(col, c("light blue", grDevices::colors()))
  bcol = match.arg(bcol, grDevices::colors())
  
  ## only grab the parameters that are going to be set
  oldPar = par(c("mfrow", "xaxs", "yaxs", "pty", "mai"))
  
  mx = mean(x)
  sx = sd(x)
  nx = length(x)
  
  qqPlot = function(i){
    qqp = qqnorm(x, axes = FALSE, xlab = "", ylab = "", main = "", 
                 xaxs = "r", yaxs = "r", ...)
    box()
    title(xlab = xlab[i], line = 0.05)
    title(ylab = ylab[i], line = 0.05)
    if(main[1] != ""){
      title(main = main[i])
    }
    
    if(bootstrap){
      p = ppoints(nx)
      qz = qnorm(p)
      
      for(b in 1:B){
        z = rnorm(nx, mx, sx)
        points(qz, sort(z), pch = bpch, col = bcol)
      }
      points(qqp$x, qqp$y)
      legend("topleft", pch = c(1, 3), col = c("black", bcol), 
             legend = c("Data", "Bootstrap samples"), 
             cex = 0.7, bty = "n")
    }
    
    qqline(x, col = "black")
    
    if (shapiro.wilk) {
      stest = shapiro.test(x)
      txt = paste("Shapiro-Wilk normality test", "\n", "W = ", round(stest$statistic, 4), "\n", "P-value = ", round(stest$p.value, 3), sep = "")
      text(sort(qqp$x)[2], 0.99 * sort(qqp$y)[length(qqp$y)], txt, adj = c(0, 1))
    }
  }
  
  
  histPlot = function(i){
    
    h = hist(x, plot = FALSE)
    rx = range(x)
    xmin = min(rx[1], mx - 3.5 * sx, h$breaks[1])
    xmax = max(rx[2], mx + 3.5 * sx, h$breaks[length(h$breaks)])
    
    
    ymax = max(h$density, dnorm(mx, mx, sx)) * 1.05
    
    hist(x, prob = TRUE, ylim = c(0, ymax), xlim = c(xmin, xmax), col = col,
         xlab = "", ylab = "", main = "", axes = FALSE, yaxs = "i", ...)
    w = strwidth(xlab[i], units = "figure")
    
    if(w < 0.95){
      title(xlab = xlab[i], line = 0.05)
    }else{
      m = 1 / (w * 1.1)
      title(xlab = xlab[i], line = 0.05, cex.lab = m)
    }
    title(ylab = ylab[i], line = 0.05)
    title(main = main[i], line = 0.05)
    box()
    
    usr = par("usr")
    x1 = seq(usr[1], usr[2], length = 100)
    y1 = dnorm(x1, mx, sx)
    lines(x1, y1, lwd = 1.5, lty = 3)
  }
  
  mfrow = c(1, 2)[1:length(whichPlot)]
  
  ## Change the layout of the plotting window only if it has not already been set
  ## This has changed to allow for a single plot to be drawn
  
  if(usePar) {
    if(length(mfrow) > 1){
      par(mfrow = mfrow)
    }
    par(xaxs = "r", yaxs = "r", pty = "s",
        mai = c(0.1, 0.2, 0, 0.05))
    on.exit(par(par = oldPar))
  }
  
  Plots = c(qqPlot, histPlot)[whichPlot]
  i = 1
  for(p in Plots){
    p(i)
    i = i + 1
  }
}

#' @export
#' @describeIn normcheck Testing for normality plot
normcheck.lm = function(x, xlab = c("Theoretical Quantiles", ""), 
                        ylab = c("Sample Quantiles", ""),
                        main = c("", ""), col = "light blue",
                        bootstrap = FALSE, B = 5, bpch = 3, bcol = "lightgrey",
                        shapiro.wilk = FALSE, 
                        whichPlot = 1:2, 
                        usePar = TRUE, ...){
  if (missing(x) || (class(x) != "lm")) 
    stop("missing or incorrect lm object")
  
  if(!all(whichPlot %in% 1:2)){
    stop("whichPlot must be in 1:2")
  }
  
  if(2 %in% whichPlot){
    if(length(xlab) == 2){
      if(!is.na(xlab[2]) && xlab[2] == "") {
        xlab[2] = paste("Residuals from lm(", as.character(x$call[2]), ")", sep = "")
      }
    }else{
      if(!is.na(xlab) && xlab == "") {
        xlab = paste("Residuals from lm(", as.character(x$call[2]), ")", sep = "")
      }
    }
  }

  x = residuals(x)
  normcheck(x, xlab = xlab, main = main, col = col, bootstrap = bootstrap, bpch = bpch, bcol = bcol, shapiro.wilk = shapiro.wilk, 
            whichPlot = whichPlot, usePar = usePar, ...)
}

