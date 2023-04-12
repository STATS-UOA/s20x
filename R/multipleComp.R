#' Multiple Comparisons
#' 
#' Calculates and prints the estimate, multiple 95\% confidence intervals;
#' unadjusted, Tukey and Bonferroni p-values for all possible differences in
#' means in a one-way ANOVA.
#' 
#' 
#' @param fit output from the command 'lm()'.
#' @param conf.level confidence level for the confidence interval, expressed as
#' a percentage.
#' @param FUN optional function to be applied to estimates and confidence intervals.
#' Typically for backtransformation operations.
#' @return Returns a list of estimates, confidence intervals and p-values.
#' @keywords htest
#' @examples
#' 
#' ## computer data
#' data(computer.df)
#' fit = lm(score ~ factor(selfassess), data = computer.df)
#' multipleComp(fit)
#' 
#' ## butterfat data
#' data("butterfat.df")
#' fit <- lm(log(Butterfat) ~ Breed, data=butterfat.df)
#' multipleComp(fit, FUN=exp)
#'
#' @export multipleComp
multipleComp = function(fit, conf.level = 0.95, FUN = identity) {
    FUN <- match.fun(FUN)

    if (nrow(anova(fit)) != 2) 
        stop("This is not a 1-way ANOVA fit")
    y = fit$model[, 1]
    f = fit$model[, 2]
    f = factor(f)
    fnames = levels(f)
    k = length(unique(f))
    df = length(y) - k
    nr = k * (k - 1)/2
    contrast.matrix = matrix(0, nrow = nr, ncol = k)
    row = 1
    names = NULL
    for (i in 1:(k - 1)) {
        for (j in (i + 1):k) {
            contrast.matrix[row, i] = 1
            contrast.matrix[row, j] = -1
            names = c(names, paste(fnames[i], " - ", fnames[j]))
            row = row + 1
        }
    }
    row.names(contrast.matrix) = names
    contrast.matrix = as.matrix(contrast.matrix)
    estimateContrasts(contrast.matrix, fit, row = TRUE, alpha = 1 - conf.level, FUN = FUN)[, 1:4]
}

