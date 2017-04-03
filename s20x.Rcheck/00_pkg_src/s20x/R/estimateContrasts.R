#' Contrast Estimates
#' 
#' Calculates and prints Tukey multiple confidence intervals for contrasts in
#' one or two-way ANOVA.
#' 
#' 
#' @param contrast.matrix a matrix of contrast coefficients. Separate rows of
#' the matrix contain the contrast coefficients for that particular contrast,
#' and a column for level of the factor.
#' @param fit output from the \code{lm} function.
#' @param row if \code{TRUE}, and the ANOVA is two-way, then contrasts in the row effects
#' are printed, otherwise contrasts in the column effects are printed. Ignored
#' if the ANOVA is one-way.
#' @param alpha the nominal error rate for the multiple confidence intervals.
#' @param L number of contrasts. If NULL, L will be set to the number of rows
#' in the contrast matrix, otherwise L will be as specified.
#' @return Returns a matrix whose rows correspond to the different contrasts
#' being estimated and whose columns correspond to the point estimate of the
#' contrast, the Tukey lower and upper limits of the confidence interval, the
#' unadjusted p-value, the Tukey and Bonferroni p-values.
#' @seealso \code{\link{summary1way}}, \code{\link{summary2way}}, \code{\link{multipleComp}}
#' @note: This function is no longer exported as it should never be called by the user. It will ultimately be removed.
#' @keywords models
#' @examples
#' 
#' ## computer data:
#' data(computer.df)
#' computer.df = within(computer.df, {selfassess = factor(selfassess)})
#' computer.fit = lm(score ~ selfassess, data = computer.df)
#' contrast.matrix = matrix(c(-1/2, -1/2, 1), byrow = TRUE, nrow = 1, ncol = 3)
#' contrast.matrix
#' s20x:::estimateContrasts(contrast.matrix,computer.fit)
estimateContrasts = function(contrast.matrix, fit, row = TRUE, alpha = 0.05, L = NULL) {
    if (!inherits(fit, "lm")) {
        stop("Second input is not an \"lm\" object")
    }
    
    if (length(dimnames(fit$model)[[2]]) == 2) {
        estimateContrasts1(contrast.matrix, fit, alpha = alpha, L)
    } else {
        estimateContrasts2(contrast.matrix, fit, alpha = alpha, row, L)
    }
}

