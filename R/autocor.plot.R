#' Autocorrelation Plot
#'
#' Plots current vs lagged residuals along with quadrants dividing these
#' residuals about the value zero.
#'
#'
#' @param fit output from the function 'lm()'.
#' @param main the plot title.
#' @param \ldots extra parameters to be passed to the \code{plot} function.
#' @return Plots current vs lagged residuals along with quadrants dividing
#' these residuals about the value zero.
#' @keywords hplot
#' @examples
#'
#' data(airpass.df)
#' time = 1:144
#' airpass.fit = lm(passengers ~ time, data = airpass.df)
#' autocorPlot(airpass.fit)
#'
#' @export autocorPlot
#' @aliases autocor.plot
#' @note \code{autocor.plot} is a legacy alias retained for older teaching material.
#'   Use \code{autocorPlot()} in new code.
autocorPlot = autocor.plot = function(fit, main = "Current vs Lagged residuals", ...) {
    currentRes = fit$residuals[-1]
    residualCount = length(fit$residuals)
    laggedRes = fit$residuals[-residualCount]
    plot(currentRes ~ laggedRes, main = main, ...)
    ab = lm(currentRes ~ laggedRes)$coeff
    ## abline(ab[1],ab[2],lty=2)
    abline(v = 0, lty = 3)
    abline(h = 0, lty = 3)
}
