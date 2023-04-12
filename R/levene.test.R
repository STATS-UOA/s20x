#' Levene test for the ANOVA Assumption
#' 
#' Perform a Levene test for equal group variances in both one-way and two-way
#' ANOVA. A table with the results is (normally) displayed.
#' 
#' 
#' @param formula a symbolic description of the model to be fitted: response ~
#' fac1 + fac2.
#' @param data an optional data frame containing the variables in the model.
#' @param digit the number of decimal places to display.
#' @param show.table If this argument is FALSE then the output will be
#' suppressed
#' @return A list with the following elements:
#' \item{df}{degrees of freedom.} \item{ss}{sum squares.}
#' \item{ms}{mean squares.} \item{f.value}{F-statistic value.}
#' \item{p.value}{P-value.}
#' @seealso \code{\link{crossFactors}}, \code{\link{anova}}.
#' @keywords htest
#' @examples
#' 
#' ##
#' data(computer.df)
#' levene.test(score ~ factor(selfassess), computer.df)
#' 
#' @export levene.test
levene.test = function(formula, data, digit = 5, show.table = TRUE) {
    call = match.call()
    m = match.call()
    mn = match(c("formula", "data"), names(m), 0)
    m = m[c(1, mn)]
    m$drop.unused.levels = TRUE
    m[[1]] = as.name("model.frame")
    m = eval(m, parent.frame())
    
    if (ncol(m) != 2 & ncol(m) != 3) 
        stop("Formula incorrect")
    Terms = attr(m, "terms")
    x = model.extract(m, "response")
    fac1 = m[, 2]
    if (ncol(m) == 3) {
        fac2 = m[, 3]
        fac1 = factor(crossFactors(fac1, fac2))
        fit = lm(x ~ fac1)
    } else fit = lm(x ~ factor(fac1))
    y = fit$model[, 1]
    f1 = fit$model[, 2]
    # fit the new model
    medians = tapply(y, f1, median)
    newy = abs(y - medians[as.double(f1)])
    newfit = lm(newy ~ f1)
    # calculate the ANOVA table
    alist = anova(newfit)
    a.df = c(alist$Df, sum(alist$Df))
    a.ss = round(c(alist$"Sum Sq", sum(alist$"Sum Sq")), digit)
    a.ms = round(alist$"Mean Sq", digit)
    fvalue = round(alist$"F value"[1], digit)
    pvalue = round(alist$"Pr(>F)"[1], digit)
    a.table = cbind(a.df, a.ss, c(paste(a.ms), ""), c(paste(fvalue), "", ""), c(paste(pvalue), "", ""))
    dimnames(a.table) = list(c("Between Groups ", "Within Groups ", "Total "), c("Df ", "Sum Squares ", "Mean Square ", "F-statistic ", "p-value   "))
    # print the result
    if (show.table) 
        print(a.table, quote = FALSE)
    
    invisible(list(df = a.df, ss = a.ss, ms = a.ms, f.value = fvalue, p.value = pvalue))
}

