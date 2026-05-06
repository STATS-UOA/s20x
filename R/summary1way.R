#' One-way Analysis of Variance Summary
#'
#' Displays summary information for a one-way anova analysis. The lm object
#' must come from a numerical response variable and a single factor. The output
#' includes: (i) anova table; (ii) numeric summary; (iii) table of effects;
#' (iv) plot of data with intervals.
#'
#'
#' @param fit an lm object, i.e. the output from \code{\link{lm}}.
#' @param digit decimal numbers after the point.
#' @param conf.level confidence level of the intervals.
#' @param inttype three options for intervals appeared on plot: 'hsd','lsd' or
#' 'ci'.
#' @param pooled two options: pooled or unpooled standard deviation used for
#' plotted intervals.
#' @param print.out if \code{TRUE}, print out the output on the screen.
#' @param draw.plot if \code{TRUE}, plot data with intervals.
#' @param \dots more options.
#' @return Invisibly returns a list containing the one-way ANOVA summary
#' components used in the printed teaching output. The list contains:
#' \item{Df}{degrees of freedom for between groups, within groups, and total.}
#' \item{Sum of Sq}{sum of squares for between groups, within groups, and total.}
#' \item{Mean Sq}{mean squares for between groups and within groups.}
#' \item{F value}{the one-way ANOVA F statistic.}
#' \item{Pr(F)}{the P-value associated with the F test.}
#' \item{Main Effect}{the grand mean of the response.}
#' \item{Group Effects}{group deviations from the grand mean.}
#'
#' The printed ANOVA table, numeric summary, effects table, and optional plot are
#' the primary teaching interface. The returned list is invisible so classroom
#' use can focus on the printed output while programmatic callers can still
#' inspect the computed values.
#' @seealso \code{\link{summary2way}}, \code{\link{anova}}, \code{\link{aov}}, \code{\link{dummy.coef}}, \code{\link{onewayPlot}}
#' @keywords models
#' @examples
#'
#' ## Computer questionnaire data:
#' data(computer.df)
#' computer.df = within(computer.df, {
#'     selfassess = factor(selfassess)
#' })
#' computer.fit = lm(score ~ selfassess, data = computer.df)
#' result = summary1way(computer.fit)
#' result
#'
#' @export
summary1way = function(fit, digit = 5, conf.level = 0.95,
                       inttype = "tukey", pooled = TRUE,
                       print.out = TRUE, draw.plot = TRUE, ...) {
    if (!inherits(fit, "lm")) {
        stop("Input is not an \"lm\" object")
    }

    anovaList = anova(fit)
    if (nrow(anovaList) > 2) {
        stop("Not belong to One-way ANOVA problem!")
    } else if (length(fit$contrasts) != 1) {
        stop("Explanatory variable should be a factor!")
    }

    y = fit$model[, 1]
    f1 = fit$model[, 2]

    # calculate the ANOVA table
    aDf = c(anovaList$Df, sum(anovaList$Df))
    aSs = round(c(anovaList$"Sum Sq", sum(anovaList$"Sum Sq")), digit)
    aMs = round(anovaList$"Mean Sq", digit)
    fValue = round(anovaList$"F value"[1], digit)
    pValue = round(anovaList$"Pr(>F)"[1], digit)
    aTable = cbind(
        aDf,
        aSs,
        c(paste(aMs), ""),
        c(paste(fValue), "", ""),
        c(paste(pValue), "", "")
    )
    dimnames(aTable) = list(
        c("Between Groups ", "Within Groups ", "Total "),
        c("Df ", "Sum Squares ", "Mean Square ", "F-statistic ", "p-value   ")
    )

    # calculate the numeric summary
    group = split(y, f1)
    n = length(group)
    size = c(length(y), numeric(n))
    mea = c(mean(y), numeric(n))
    med = c(median(y), numeric(n))
    std = c(sd(y), numeric(n))
    mid = c(quantile(y, 0.75) - quantile(y, 0.25), numeric(n))

    for (i in 2:(n + 1)) {
        size[i] = length(group[[i - 1]])
        g = group[[i - 1]]
        mea[i] = mean(g)
        med[i] = median(g)
        std[i] = sd(g)
        mid[i] = quantile(g, 0.75) - quantile(g, 0.25)
    }

    numericSummary = cbind(size, mea, med, std, mid)
    dimnames(numericSummary) = list(
        c("All Data", names(split(y, f1))),
        c(" Sample size", "    Mean", " Median", " Std Dev", " Midspread")
    )

    # calculate the effects
    grandMean = mean(y)
    # Small 'hack' for R 4.0+ as we may not have factors and dummy.coef
    # doesn't handle this.
    groupEffectColumn = data.frame(names(group))
    colnames(groupEffectColumn) = colnames(fit$model)[2]
    groupEffects = predict(fit, newdata = groupEffectColumn) - grandMean
    effectMatrix = c(grandMean, groupEffects)
    names(effectMatrix) = c("typ.val", names(split(y, f1)))

    if (print.out) {
        cat("ANOVA Table:\n")
        print(aTable, quote = FALSE)
        cat("\nNumeric Summary:\n")
        print(round(numericSummary, digit))
        cat("\nTable of Effects: (GrandMean and deviations from GM)\n")
        print(round(effectMatrix, digit))
    }

    if (draw.plot) {
        onewayPlot(fit, conf.level = conf.level, interval.type = inttype)
    }

    invisible(list(
        Df = aDf,
        `Sum of Sq` = aSs,
        `Mean Sq` = aMs,
        `F value` = anovaList$"F value"[1],
        `Pr(F)` = anovaList$"Pr(>F)"[1],
        `Main Effect` = grandMean,
        `Group Effects` = groupEffects
    ))
}
