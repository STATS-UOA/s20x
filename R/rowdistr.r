prepCrosstabList = function(crosstablist) {
    rowTotals = apply(crosstablist, 1, sum)
    colTotals = apply(crosstablist, 2, sum)

    crosstablist = list(
        row.props = sweep(crosstablist, 1, rowTotals, "/"),
        col.props = sweep(crosstablist, 2, colTotals, "/"),
        whole.props = crosstablist / sum(colTotals),
        Totals = rbind(
            cbind(crosstablist, rowTotals),
            apply(cbind(crosstablist, rowTotals), 2, sum)
        )
    )

    if (is.null(dimnames(crosstablist$row.props))) {
        dimnames(crosstablist$row.props) = list(
            1:nrow(crosstablist$whole.props),
            1:ncol(crosstablist$whole.props)
        )
    }

    if (is.null(dimnames(crosstablist$col.props))) {
        dimnames(crosstablist$col.props) = dimnames(crosstablist$row.props)
    }

    if (is.null(dimnames(crosstablist$whole.props))) {
        dimnames(crosstablist$whole.props) = dimnames(crosstablist$row.props)
    }

    if (!is.null(dimnames(crosstablist$Totals)[[1]]) &&
        is.null(dimnames(crosstablist$Totals)[[2]])) {
        dimnames(crosstablist$Totals) = list(
            c(
                dimnames(crosstablist$Totals)[[1]][1:nrow(crosstablist$whole.props)],
                "Total"
            ),
            c(1:ncol(crosstablist$whole.props), "Total")
        )
        dimnames(crosstablist$row.props) = list(
            dimnames(crosstablist$Totals)[[1]][1:nrow(crosstablist$row.props)],
            1:ncol(crosstablist$row.props)
        )
        dimnames(crosstablist$col.props) = dimnames(crosstablist$row.props)
    }

    if (is.null(dimnames(crosstablist$Totals))) {
        dimnames(crosstablist$Totals) = list(
            c(1:nrow(crosstablist$whole.props), "Total"),
            c(1:ncol(crosstablist$whole.props), "Total")
        )
    }

    if (is.null(names(dimnames(crosstablist$Totals)))) {
        names(dimnames(crosstablist$Totals)) = c("fac1", "fac2")
    }

    crosstablist
}

drawPlot = function(crosstablist, comp = c("basic", "within", "between"),
                     conf.level = 0.95) {
    comp = match.arg(comp)

    adjValue = 0.5
    propmat = crosstablist$row.props
    rowCount = nrow(propmat)
    oldPar = NULL

    if (comp == "basic" || comp == "within") {
        oldPar = par(
            mfrow = c(rowCount, 1),
            mar = c(1.5, 1.5, 1.5, 1.5),
            oma = c(3, 3, 4, 3)
        )
        on.exit(par(oldPar))
    }

    if (comp == "between") {
        oldPar = par(mfrow = c(1, 1))
        on.exit(par(oldPar))
    }

    chiUse = NULL
    pvalUse = NULL

    for (rowIndex in 1:rowCount) {
        maxPlot = 1.17 * max(propmat)
        plusMinus = 0.3
        xUse = propmat[rowIndex, ]
        len = length(xUse)

        if (comp == "basic" || comp == "within") {
            plot(
                c(1 - 2 * plusMinus, len + 2 * plusMinus),
                c(0, maxPlot),
                type = "n",
                bty = "n",
                axes = FALSE,
                xlab = "",
                ylab = "proportion",
                cex.lab = 1.15
            )
            axis(2, las = 2)
            axis(1, at = 1:len, labels = substr(colnames(propmat), 1, 8),
                 cex.axis = 1.15)
            for (i in 1:len) {
                rect(i - plusMinus, 0, i + plusMinus, xUse[i], col = rowIndex)
                box()
            }
        }

        if (comp == "basic") {
            text(
                (len + 1) / 2,
                maxPlot - 0.12 * max(propmat),
                paste(
                    rownames(propmat)[rowIndex],
                    " (n = ",
                    crosstablist$Totals[, ncol(crosstablist$Totals)][rowIndex],
                    ")",
                    sep = ""
                ),
                cex = 1.15
            )
        }

        expected = crosstablist$Totals[, ncol(crosstablist$Totals)][
            1:nrow(crosstablist$row.props)
        ][rowIndex] / ncol(crosstablist$col.props)
        dfs = ncol(crosstablist$col.props) - 1
        observed = crosstablist$Totals[
            1:nrow(crosstablist$whole.props),
            1:ncol(crosstablist$whole.props)
        ][rowIndex, ]
        chiValue = round(sum((observed - expected)^2 / expected), 3)
        chiUse = cbind(chiUse, chiValue)
        pval = round(1 - pchisq(chiValue, dfs), 5)
        pvalUse = cbind(pvalUse, pval)

        if (comp == "within") {
            text(
                (len + 1) / 2,
                maxPlot - 0.12 * max(propmat),
                paste(
                    rownames(propmat)[rowIndex],
                    "(n = ",
                    crosstablist$Totals[, ncol(crosstablist$Totals)][rowIndex],
                    ")",
                    ", ",
                    "uniformity p-value=",
                    pval,
                    sep = ""
                ),
                cex = 1.15
            )
        }
    }

    if (comp == "basic" || comp == "within") {
        mtext(
            paste(names(dimnames(crosstablist$Totals))[2], "distribution for each",
                  sep = " "),
            outer = TRUE,
            at = 0.5,
            line = 2,
            cex = 1.15,
            adj = adjValue,
            font = 2
        )
        mtext(
            paste("level of", names(dimnames(crosstablist$Totals))[1],
                  "(row proportions)", sep = " "),
            outer = TRUE,
            at = 0.5,
            cex = 1.15,
            adj = adjValue,
            font = 2
        )
    }

    if (comp == "between") {
        propslsd.new(crosstablist, conf.level = 1 - (1 - conf.level) / choose(rowCount, 2))
    }
}

printOutput = function(crosstablist, comp = c("basic", "within", "between"),
                        conf.level = 0.95) {
    comp = match.arg(comp)

    cat("Row Proportions\n")

    propmat = crosstablist$row.props
    rowCount = nrow(propmat)

    matprint = cbind(
        round(propmat, 2),
        apply(propmat, 1, sum),
        as.numeric(crosstablist$Totals[, ncol(crosstablist$Totals)][
            1:(nrow(crosstablist$Totals) - 1)
        ])
    )
    dimnames(matprint) = list(
        dimnames(propmat)[[1]],
        c(dimnames(propmat)[[2]], "Totals", "n")
    )
    print(matprint)

    chiUse = NULL
    pvalUse = NULL

    p = propmat
    ns = crosstablist$Totals[, ncol(crosstablist$Totals)][
        1:(nrow(crosstablist$Totals) - 1)
    ]
    matw = matrix(NA, ncol(propmat) - 1, ncol(propmat) - 1)
    mat = matrix(NA, rowCount - 1, rowCount - 1)
    colvar = names(dimnames(crosstablist$Totals))[2]
    rowvar = names(dimnames(crosstablist$Totals))[1]
    rowNames = dimnames(p)[[1]]
    dimnames(mat) = list(rowNames[-rowCount], rowNames[-1])
    colNames = dimnames(p)[[2]]
    dimnames(matw) = list(colNames[-length(colNames)], colNames[-1])

    for (j in 1:ncol(p)) {
        for (i1 in 1:(rowCount - 1)) {
            for (i2 in 2:rowCount) {
                zCrit = abs(qnorm((1 - conf.level) / (2 * choose(rowCount, 2))))
                seDiff = sqrt(
                    p[i1, j] * (1 - p[i1, j]) / ns[i1] +
                        p[i2, j] * (1 - p[i2, j]) / ns[i2]
                )
                temp = p[i1, j] - p[i2, j] + zCrit * c(-1, 1) * seDiff
                temp = round(temp, 3)
                mat[i1, i2 - 1] = ifelse(
                    i1 < i2,
                    paste("(", temp[1], ",", temp[2], ")", sep = ""),
                    " "
                )
                if ((0 <= temp[1] || 0 >= temp[2]) && i1 < i2) {
                    mat[i1, i2 - 1] = paste(mat[i1, i2 - 1], "*", sep = "")
                }
            }
        }

        if (comp == "between") {
            cat("\n")
            cat(
                paste(
                    paste(100 * conf.level, "%", sep = ""),
                    "CIs for diffs between proportions with",
                    colvar,
                    "=",
                    dimnames(p)[[2]][j]
                ),
                "\n"
            )
            cat("(rowname-colname)", "\n")
            print(mat, quote = FALSE)
        }
    }

    for (k in 1:nrow(p)) {
        for (i1 in 1:(ncol(p) - 1)) {
            for (i2 in 2:ncol(p)) {
                zCrit = abs(qnorm((1 - conf.level) / (2 * choose(ncol(p), 2))))
                seDiff = sqrt(
                    ((p[k, i1] + p[k, i2]) - ((p[k, i1] - p[k, i2])^2)) / ns[k]
                )
                tempw = p[k, i1] - p[k, i2] + zCrit * c(-1, 1) * seDiff
                tempw = round(tempw, 3)
                matw[i1, i2 - 1] = ifelse(
                    i1 < i2,
                    paste("(", tempw[1], ",", tempw[2], ")", sep = ""),
                    " "
                )
                if ((0 <= tempw[1] || 0 >= tempw[2]) && i1 < i2) {
                    matw[i1, i2 - 1] = paste(matw[i1, i2 - 1], "*", sep = "")
                }
            }
        }
        if (comp == "within") {
            print(matprint[k, ])
            cat("\n")
            cat(
                paste(
                    "Chisq test for uniformity:",
                    "chisq = ",
                    chiUse[k],
                    ",",
                    "df =",
                    ncol(propmat) - 1,
                    ",",
                    "p-value =",
                    pvalUse[k]
                ),
                "\n"
            )
            cat(
                paste(
                    paste(100 * conf.level, "%", sep = ""),
                    "CIs for diffs in propns within the",
                    rowvar,
                    "=",
                    dimnames(p)[[1]][k]
                ),
                "distribution",
                "\n"
            )
            cat("(rowname-colname)", "\n")
            print(matw, quote = FALSE)
            cat("\n")
            cat("----------------------------------------------------------------------")
            cat("\n")
        }
    }

    invisible(propmat)
}

#' Row distributions from a cross-tabulation of two variables
#'
#' Produces summaries and plots from a cross-tabulation.  The output produced
#' depends on the parameter 'comp'. Columns relate to response categories and
#' rows to different populations.
#'
#' The 'basic' option (default) produces the response distribution for each row
#' population together with comparative bar charts.
#'
#' If comp = 'between' the resulting output displays how the probability of
#' falling into a response class (column) differs between populations.
#' Confidence intervals for differences in proportions are produced together
#' with a set of barcharts with LSD intervals.
#'
#' If comp = 'within' the resulting output shows the extent to which the
#' component probabilities of the same row distribution differ. Separate
#' Chi-square tests for uniformity are produced for each row distribution as
#' are confidence intervals for differences in proportions within the same
#' distribution.
#'
#' Arguments \code{plot} and \code{suppressText} are really only used when
#' producing knitr or Sweave documents so that just the plot or just the text
#' can be displayed in the document.
#'
#' @param crosstablist a list produced by 'crosstabs' or a matrix containing a
#' 2-way table of counts (without marginal totals).
#' @param comp three options: 'basic' (default), 'within', and 'between'.
#' @param conf.level confidence level of the intervals.
#' @param plot if \code{FALSE} then the row distribution plots are not displayed
#' @param suppressText if \code{TRUE} then text results are not displayed
#' @return Invisibly returns the matrix of row proportions printed by the
#' teaching summary when \code{suppressText = FALSE}. When
#' \code{suppressText = TRUE}, the function invisibly returns \code{NULL}
#' because no text summary is constructed. Plotting remains a side effect
#' controlled by \code{plot}.
#' @seealso \code{\link{crosstabs}}
#' @keywords htest
#' @examples
#'
#' data(body.df)
#' z = crosstabs(~ ethnicity + married, data = body.df)
#' rowdistr(z)
#' rowdistr(z, comp = "between")
#' rowdistr(z, comp = "within")
#'
#' ## from matrix of counts
#' z = matrix(c(4, 3, 2, 6, 47, 20, 40, 62, 11, 8, 7, 22, 3, 0, 1, 10), 4, 4)
#' rowdistr(z)
#' @importFrom methods is
#' @export rowdistr
rowdistr = function(crosstablist, comp = c("basic", "within", "between"),
                    conf.level = 0.95, plot = TRUE, suppressText = FALSE) {
    comp = match.arg(comp)

    if (!is.matrix(crosstablist) && !methods::is(crosstablist, "ct.20x")) {
        stop("check form of crosstablist: input list must be output from crosstabs or a list of similar form")
    }

    if (is.matrix(crosstablist) && !is.list(crosstablist)) {
        crosstablist = prepCrosstabList(crosstablist)
    }

    propmat = NULL

    if (!suppressText) {
        propmat = printOutput(crosstablist, comp, conf.level)
    }

    if (plot) {
        drawPlot(crosstablist, comp, conf.level)
    }

    invisible(propmat)
}
