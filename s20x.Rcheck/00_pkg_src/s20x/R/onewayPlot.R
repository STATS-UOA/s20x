#' One-way Analysis of Variance Plot
#' 
#' Displays stripplot/boxplot of the reponse variable with intervals by factor
#' levels. It is used as part of a one-way ANOVA analysis.
#' 
#' @param formula a symbolic description of the model to be fit.
#' @param x a vector of responses, a formula object or an lm object
#' @param f if x is a vector of responses then f contains the group labels for
#' each observation in x. That is, the ith value in f says which group the ith
#' observation of x belongs to.
#' @param conf.level confidence level of the intervals.
#' @param interval.type three options for intervals appearing on plot:
#' 'hsd','lsd' or 'ci'.
#' @param pooled two options: pooled or unpooled standard deviation used for
#' plotted intervals.
#' @param strip if strip=F, boxplots are displayed instead.
#' @param vert if vert=F, horizontal stripplots are displayed instead (boxplots
#' can only be displayed vertically).
#' @param verbose if true, print intervals on console.
#' @param ylabel can be used to replace variable name of y by another string.
#' @param flabel can be used to replace variable name of f by another string.
#' @param data an optional data frame in which to evaluate the formula.
#' @param \dots optional arguments.
#' @seealso \code{\link{summary1way}}, \code{\link{welch.test}}.
#' @keywords hplot
#' @examples
#' 
#' ##see example in 'summary1way'
#' 
#' ##computer data:
#' data(computer.df)
#' onewayPlot(score~selfassess, data = computer.df)
#' 
#' 
#' ##apple data:
#' data(apples.df)
#' twosampPlot(Weight~Propagated, data = apples.df)
#' 
#' ##oyster data:
#' data(oysters.df)
#' onewayPlot(log(Oysters)~Site, data = oysters.df)
#' 
#' ##oyster data:
#' data(oysters.df)
#' oyster.fit = lm(log(Oysters)~Site, data = oysters.df)
#' onewayPlot(oyster.fit)
#' 
#' @export onewayPlot
#' @export twosampPlot
#' @aliases onewayPlot twosampPlot
onewayPlot = twosampPlot = function(x, ...) {
    UseMethod("onewayPlot")
}

#' @export
#' @describeIn onewayPlot One-way Analysis of Variance Plot
onewayPlot.default = function(x, f, conf.level = 0.95, interval.type = "tukey", pooled = TRUE, strip = TRUE, vert = TRUE, verbose = FALSE, 
                              ylabel = deparse(terms(formula)[[2]]), flabel = deparse(terms(formula)[[3]]), ...) {
    
    index = switch(interval.type, tukey = 1, hsd = 2, lsd = 3, ci = 4, 0)
    if (!index) 
        stop("bad interval.type argument")
    if ((conf.level < 0) || (conf.level > 1)) 
        stop("bad conf.level argument (must be between 0 and 1)")
    
    y = x
    flabel = as.character(flabel)
    ylabel = as.character(ylabel)
    
    name = c("TUKEY intervals", "HSD intervals", "LSD intervals", "Confidence intervals")[index]
    mylevels = split(y, f)
    nfactor = as.numeric(f)
    xmax = max(nfactor)
    if (length(mylevels) < 2) 
        stop("must have at least 2 levels")
    
    title.string = paste("Plot of `", ylabel, "' by levels of `", flabel, "',\nwith ", name, " (", conf.level * 100, "%, ", if (!pooled) 
        "un", "pooled SDs)", sep = "", collapse = "")
    ## XXX: assumes levels are consecutively numbered from 1 upwards.
    if (strip) {
        if (vert) 
            stripchart(y ~ f, vert = TRUE, main = title.string, xlab = flabel, ylab = ylabel, pch = 1, method = "stack", col = 1, xlim = c(0.5, xmax + 0.5)) else stripchart(y ~ f, main = title.string, xlab = ylabel, ylab = flabel, pch = 1, method = "stack", col = 1, ylim = c(0.5, xmax + 0.5))
    } else boxplot(y ~ f, main = title.string, xlab = flabel, ylab = ylabel)
    D = if (index == 4) 
        1 else if (index == 1) 
        2 else sqrt(2)
    M = if (index == 2) 
        xmax * (xmax - 1)/2 else 1
    if (pooled) {
        df = length(f) - length(mylevels)
        sdev = summary(lm(y ~ f))$sigma
    }
    if (verbose) {
        cat("\n", title.string, sep = "")
        if (pooled) 
            cat("\n\nPooled: df = ", df, ", sd = ", sdev, "\n", sep = "") else cat("\n\nUnpooled:\n")
    }
    for (level in seq(mylevels)) {
        levelname = levels(f)[level]
        mylevel = mylevels[[level]]
        avg = mean(mylevel)
        if (!pooled) {
            df = length(mylevel) - 1
            sdev = sd(mylevel)
        }
        if (index == 1) 
            conf.disp = qtukey(conf.level, xmax, df)/D * sdev/sqrt(length(mylevel)) else conf.disp = qt(1 - (1 - conf.level)/(2 * M), df)/D * sdev/sqrt(length(mylevel))
        if (strip) {
            if (vert) {
                # addon to the vertical stripchart
                x.coord = level - 0.2
                lines(c(x.coord + 0.075, x.coord - 0.075), c(avg, avg), col = 1)
                arrows(x.coord, avg - conf.disp, x.coord, avg + conf.disp, length = 0.075, code = 3, col = 1, angle = if (index == 3) 
                  90 else 75)
            } else {
                # addon to a horizontal stripchart
                y.coord = level - 0.2
                lines(c(avg, avg), c(y.coord + 0.075, y.coord - 0.075), col = 1)
                arrows(avg - conf.disp, y.coord, avg + conf.disp, y.coord, length = 0.075, code = 3, col = 1, angle = if (index == 3) 
                  90 else 75)
            }
        } else {
            # addon to a boxplot
            x.coord = level
            lines(c(x.coord + 0.085, x.coord - 0.085), c(avg, avg), col = 2)
            arrows(x.coord, avg - conf.disp, x.coord, avg + conf.disp, length = 0.09, code = 3, col = 2, angle = if (index == 3) 
                90 else 75)
        }
        if (verbose) {
            cat(levelname, ": mean = ", avg, ", disp = ", conf.disp, sep = "")
            if (!pooled) 
                cat(", df = ", df, ", sd = ", sdev, sep = "")
            cat("\n")
        }
    }
    
    
}

#' @export
#' @describeIn onewayPlot One-way Analysis of Variance Plot
onewayPlot.formula = function(formula, data = parent.frame(), conf.level = 0.95, interval.type = "tukey", pooled = TRUE, strip = TRUE, vert = TRUE, verbose = FALSE, ylabel = deparse(terms(formula)[[2]]), flabel = deparse(terms(formula)[[3]]), 
    ...) {
    
    if (missing(formula) || (length(formula) != 3)) 
        stop("'formula' missing or incorrect")
    
    index = switch(interval.type, tukey = 1, hsd = 2, lsd = 3, ci = 4, 0)
    if (!index) 
        stop("bad interval.type argument")
    if ((conf.level < 0) || (conf.level > 1)) 
        stop("bad conf.level argument (must be between 0 and 1)")
    
    # mf = data
    cl = match.call()
    mf = match.call(expand.dots = FALSE)
    m = match(c("formula", "data"), names(mf), 0L)
    mf = mf[c(1L, m)]
    mf$drop.unused.levels = TRUE
    mf[[1L]] = as.name("model.frame")
    mf = eval(mf, parent.frame())
    mt = attr(mf, "terms")
    y = model.response(mf, "numeric")
    
    
    ## How robust is this?
    factors = which(rowSums(attr(mt, "factors")) > 0)
    if (length(factors) > 1) {
        warning("Only the first factor in the formula will be used")
        factors = factors[1]
    }
    
    f = factor(mf[, factors])
    
    flabel = as.character(flabel)
    ylabel = as.character(ylabel)
    ## factors = match(deparse(terms(formula)[[3]]),names(mf)) y = eval(terms(formula)[[2]], data) f = factor(data[,factors])
    
    name = c("TUKEY intervals", "HSD intervals", "LSD intervals", "Confidence intervals")[index]
    mylevels = split(y, f)
    nfactor = as.numeric(f)
    xmax = max(nfactor)
    if (length(mylevels) < 2) 
        stop("must have at least 2 levels")
    
    title.string = paste("Plot of `", ylabel, "' by levels of `", flabel, "',\nwith ", name, " (", conf.level * 100, "%, ", if (!pooled) 
        "un", "pooled SDs)", sep = "", collapse = "")
    ## XXX: assumes levels are consecutively numbered from 1 upwards.
    if (strip) {
        if (vert) 
            stripchart(y ~ f, vert = TRUE, main = title.string, xlab = flabel, ylab = ylabel, pch = 1, method = "stack", col = 1, xlim = c(0.5, xmax + 0.5)) else stripchart(y ~ f, main = title.string, xlab = ylabel, ylab = flabel, pch = 1, method = "stack", col = 1, ylim = c(0.5, xmax + 0.5))
    } else boxplot(y ~ f, main = title.string, xlab = flabel, ylab = ylabel)
    D = if (index == 4) 
        1 else if (index == 1) 
        2 else sqrt(2)
    M = if (index == 2) 
        xmax * (xmax - 1)/2 else 1
    if (pooled) {
        df = length(f) - length(mylevels)
        sdev = summary(lm(y ~ f))$sigma
    }
    if (verbose) {
        cat("\n", title.string, sep = "")
        if (pooled) 
            cat("\n\nPooled: df = ", df, ", sd = ", sdev, "\n", sep = "") else cat("\n\nUnpooled:\n")
    }
    for (level in seq(mylevels)) {
        levelname = levels(f)[level]
        mylevel = mylevels[[level]]
        avg = mean(mylevel)
        if (!pooled) {
            df = length(mylevel) - 1
            sdev = sd(mylevel)
        }
        if (index == 1) 
            conf.disp = qtukey(conf.level, xmax, df)/D * sdev/sqrt(length(mylevel)) else conf.disp = qt(1 - (1 - conf.level)/(2 * M), df)/D * sdev/sqrt(length(mylevel))
        if (strip) {
            if (vert) {
                # addon to the vertical stripchart
                x.coord = level - 0.2
                lines(c(x.coord + 0.075, x.coord - 0.075), c(avg, avg), col = 1)
                arrows(x.coord, avg - conf.disp, x.coord, avg + conf.disp, length = 0.075, code = 3, col = 1, angle = if (index == 3) 
                  90 else 75)
            } else {
                # addon to a horizontal stripchart
                y.coord = level - 0.2
                lines(c(avg, avg), c(y.coord + 0.075, y.coord - 0.075), col = 1)
                arrows(avg - conf.disp, y.coord, avg + conf.disp, y.coord, length = 0.075, code = 3, col = 1, angle = if (index == 3) 
                  90 else 75)
            }
        } else {
            # addon to a boxplot
            x.coord = level
            lines(c(x.coord + 0.085, x.coord - 0.085), c(avg, avg), col = 2)
            arrows(x.coord, avg - conf.disp, x.coord, avg + conf.disp, length = 0.09, code = 3, col = 2, angle = if (index == 3) 
                90 else 75)
        }
        if (verbose) {
            cat(levelname, ": mean = ", avg, ", disp = ", conf.disp, sep = "")
            if (!pooled) 
                cat(", df = ", df, ", sd = ", sdev, sep = "")
            cat("\n")
        }
    }
}

#' @export
#' @describeIn onewayPlot One-way Analysis of Variance Plot
onewayPlot.lm = function(x, ..., ylabel = nms[1], flabel = nms[2]) {
    ## Thanks to Ross Ihaka for sorting this out
    data = x$model
    nms = names(data)
    if (dim(data)[2] != 2) 
        warning("only the first variable will be used")
    onewayPlot.default(data[, 1], data[, 2], ylabel = ylabel, flabel = flabel)
}
