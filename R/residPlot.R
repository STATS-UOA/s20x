#' Fitted values versus residuals plot
#'
#' Plots a scatter plot for the variables of the residuals and fitted values
#' from the linear model, lmfit. A lowess smooth line for the underlying trend,
#' as well as one standard deviation error bounds for the scatter about this
#' trend, are added to this scatter plot. A test for a quadratic relationship
#' between the residuals and the fitted values is also computed.
#'
#'
#' @param lmfit an \code{lm} object, i.e. the output from \code{lm}.
#' @param f the smoother span. This gives the proportion of points in the plot
#' which influence the smooth at each value. Larger values give more
#' smoothness.
#' @return Returns the plot.
#' @seealso \code{\link{trendscatter}}
#' @keywords hplot
#' @note This is a legacy diagnostic plotting helper retained for compatibility
#'   with older teaching material. New code should usually prefer the current
#'   diagnostic workflow used by \code{modelcheck()}.
#' @examples
#'
#' # Peruvian Indians data
#' data(peru.df)
#' fit = lm(BP ~ age + years + weight + height, data = peru.df)
#' residPlot(fit)
#'
#' @export residPlot
residPlot = function(lmfit, f = 0.5) {
    diagnosticData = getModelResidualFittedData(lmfit, context = "linear model")
    yhat = diagnosticData$fitted
    res = diagnosticData$residuals
    y = yhat + res
    qq = qr.Q(lmfit$qr)
    rr = qr.R(lmfit$qr)
    xx = qq %*% rr
    newdata = data.frame(y, yhat^2, xx[, -1])

    xnam = dimnames(newdata)[[2]][-1]
    form = as.formula(paste("y ~", paste(xnam, collapse = "+")))
    foo = lm(form, data = newdata)
    goo = summary(foo)
    curvp = goo$coefficients[dimnames(goo$coefficients)[[1]] == "yhat.2", 4]

    yhatSort = sort(yhat, index = TRUE)
    newyhat = yhatSort$x
    ix = yhatSort$ix
    newres = res[ix]

    trend = lowess(newyhat, newres, f)
    e = (newres - trend$y)^2
    scatter = lowess(newyhat, e, f)

    uplim = trend$y + sqrt(abs(scatter$y))
    lowlim = trend$y - sqrt(abs(scatter$y))

    plot(
        yhat,
        res,
        pch = 1,
        xlab = "Fitted Values",
        ylab = "Residuals",
        main = paste(
            "Resids vs. Fitted ~ Test for Quadratic (p=",
            signif(curvp, 3),
            ")"
        )
    )
    lines(trend, col = "Blue")
    lines(scatter$x, uplim, lty = 2, col = "Red")
    lines(scatter$x, lowlim, lty = 2, col = "Red")
}
