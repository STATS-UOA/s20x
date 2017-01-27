#' Confidence Intervals for Regression models
#' 
#' Calculates and prints the confidence intervals for the fitted model.
#' 
#' 
#' @param fit an lm object, i.e. the output from 'lm()'.
#' @param conf.level confidence level of the intervals.
#' @param print.out if TRUE, print out the output on the screen.
#' @return The function returns a two-column matrix containing the upper and
#' lower endpoints of the intervals.
#' @seealso 'lm', 'summary', 'anova'.
#' @keywords htest
#' @examples
#' 
#' ##Peruvian Indians data
#' data(peru.df)
#' fit<-lm(BP ~ age + years + weight + height, data = peru.df)
#' ciReg(fit)
#' 
#' @export ciReg
ciReg = function(fit, conf.level = 0.95, print.out = TRUE) {
    if (!inherits(fit, "lm")) 
        stop("Input is not an \"lm\" object")
    
    if (names(fit$coef[1]) != "(Intercept)") 
        cat("\n(There is no intercept in  this regression model!)\n")
    
    lmsummary = summary(fit)$coefficients
    df = fit$df
    tt = 1 - (1 - conf.level)/2
    C.I.upper = coef(fit) + lmsummary[, 2] * qt(tt, df)
    C.I.lower = coef(fit) - lmsummary[, 2] * qt(tt, df)
    level = conf.level * 100
    ci = cbind(C.I.lower, C.I.upper)
    dimnames(ci) = list(names(lmsummary[, 1]), c(paste(level, "% C.I.lower"), paste("  ", level, "% C.I.upper")))
    
    if (print.out) {
        print(round(ci, 5))
    }
    
    invisible(ci)
}

