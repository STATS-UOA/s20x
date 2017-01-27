#' Interactions Plot for Two-way Analysis of Variance
#' 
#' Displays data with intervals for each combination of the two factors and
#' shows the mean differences between levels of the first factor for each level
#' of the second factor. Note that there should be more than one observation
#' for each combination of factors.
#' 
#' 
#' @aliases interactionPlots interactionPlots.default interactionPlots.formula
#' @param y either a formula of the form: y~fac1+fac2 where y is the response
#' and fac1 and fac2 are the two explanatory variables used as factors, or a
#' single response vector
#' @param fac1 if 'y' is a vector, then fac1 contains the levels of factor 1
#' which correspond to the y value
#' @param fac2 if 'y' is a vector, then fac1 contains the levels of factor 2
#' which correspond to the y value
#' @param data an optional data frame containing the variables in the model.
#' @param xlab an optional label for the x-axis. If not specified the name of
#' fac1 will be used.
#' @param xlab2 an optional label for the lines. If not specified the name of
#' fac2 will be used.
#' @param ylab An optional label for the y-axis. If not specified the name of y
#' will be used.
#' @param data.order if TRUE the levels of fac1 and fac2 will be set to
#' unique(fac1) and unique(fac2) respectively.
#' @param exlim provide extra limits.
#' @param jitter the amount of horizontal jitter to show in the plot.  The
#' actual jitter is determined as the function is called, and will likely be
#' different each time the function is used.
#' @param conf.level confidence level of the intervals.
#' @param interval.type four options for intervals appearing on plot: 'tukey',
#' 'hsd', 'lsd' or 'ci'.
#' @param pooled two options: pooled or unpooled standard deviation used for
#' plotted intervals.
#' @param tick.length size of tick, in inches.
#' @param interval.distance distance, as a fraction of the column width,
#' between the points and interval.  This is in addition to the extra space
#' allocated for the jitter.
#' @param col.width width of a factor `column', as a fraction of the space
#' between the centres of two columns.
#' @param xlab.distance distance of x-axis labels from bottom of plot, as a
#' fraction of the overall height of the plot.
#' @param xlen,ylen xxx
#' @param \dots optional arguments.
#' @seealso 'summary2way'.
#' @keywords hplot
#' @examples
#' 
#' data(mtcars)
#' interactionPlots(wt~vs+gear, mtcars)
#' 
#' ## note this usage is deprecated
#' data(mtcars)
#' with(mtcars, interactionPlots(wt,vs,gear))
#' 
#' @export interactionPlots
interactionPlots = function(y, ...) {
    UseMethod("interactionPlots")
}

interactionPlots.default = function(y, fac1 = NULL, fac2 = NULL, xlab = NULL, xlab2 = NULL, ylab = NULL, data.order = TRUE, exlim = 0.1, jitter = 0.02, conf.level = 0.95, interval.type = "tukey", pooled = TRUE, 
    tick.length = 0.1, interval.distance = 0.2, col.width = 2/3, xlab.distance = 0.1, xlen = 1.5, ylen = 1, ...) {
    if (is.null(fac1) || is.null(fac2)) {
        stop("You must specify two factors")
    } else {
        
        if (is.null(ylab)) 
            ylab = deparse(substitute(y))
        if (is.null(xlab)) 
            xlab = deparse(substitute(fac1))
        if (is.null(xlab2)) 
            xlab2 = deparse(substitute(fac2))
        
        arrowhead.length = 0.5 * tick.length
        index = switch(interval.type, tukey = 1, hsd = 2, lsd = 3, ci = 4, 0)
        
        if (!index) 
            stop("bad interval.type argument")
        if ((conf.level < 0) || (conf.level > 1)) 
            stop("bad conf.level argument (must be between 0 and 1)")
        
        name = c("TUKEY intervals", "HSD intervals", "LSD intervals", "Confidence intervals")[index]
        
        
        if (length(unique(fac1)) < 2 || length(unique(fac2)) < 2) 
            stop("must have at least 2 levels for the factor")
        
        if (data.order) {
            fac1 = factor(fac1, unique(fac1))
            fac2 = factor(fac2, unique(fac2))
        }
        
        code1 = as.numeric(fac1)
        code2 = as.numeric(fac2)
        fac1.level = split(y, fac1)
        fac2.level = split(y, fac2)
        
        xmax = max(code1)
        nlevel = max(code2)
        tolevel = xmax * nlevel
        yrange = range(y)
        ydiff = yrange[2] - yrange[1]
        addon = rep(c(2, 3), xmax)[1:xmax]
        xlimit = xmax * 1.5
        
        title.string = paste("Plot of '", ylab, "'\nby levels of '", xlab, "' and '", xlab2, "'", sep = "", collapse = "")
        
        plot(c(0.5, xlimit), c(yrange[1] - exlim * ydiff, yrange[2] + exlim * ydiff), type = "n", axes = FALSE, main = title.string, xlab = xlab, ylab = ylab)
        
        axis(2)
        
        points(code1 + (code2 - 0.5)/length(fac2.level) * col.width - col.width/2 + if (!jitter) 
            jitter else runif(length(y), -jitter, jitter), y, pch = code2, col = code2)
        
        for (i in (1:xmax)) text(i, yrange[1] - addon[i] * ydiff/30, levels(fac1)[i])
        
        D = if (index == 4) 
            1 else if (index == 1) 
            2 else sqrt(2)
        M = if (index == 2) 
            tolevel * (xmax + nlevel - 2)/2 else 1
        
        if (pooled) {
            df = length(y) - length(fac1.level) * length(fac2.level)
            sdev = summary(lm(y ~ fac1 * fac2))$sigma
        }
        
        avg = matrix(rep(0, xmax * nlevel), nrow = xmax)
        x.coord = conf.disp = avg
        
        for (i in (1:xmax)) {
            splitlevels = split(fac1.level[[i]], split(fac2, fac1)[[i]])
            
            for (j in (1:nlevel)) {
                mylevel = splitlevels[[j]]
                avg[i, j] = mean(mylevel)
                if (!pooled) {
                  df = length(mylevel) - 1
                  sdev = sd(mylevel)
                }
                if (index == 1) 
                  conf.disp[i, j] = qtukey(conf.level, nlevel, df, xmax)/D * sdev/sqrt(length(mylevel)) else conf.disp[i, j] = qt(1 - (1 - conf.level)/(2 * M), df)/D * sdev/sqrt(length(mylevel))
                # print(conf.disp[i,j])
                x.coord[i, j] = i + jitter + ((j - 0.5)/length(fac2.level) * col.width - col.width/2) + interval.distance/length(fac2.level)
                arrows(x.coord[i, j], avg[i, j] - conf.disp[i, j], x.coord[i, j], avg[i, j] + conf.disp[i, j], length = arrowhead.length, code = 3, angle = if (index == 3) 
                  90 else 75, col = j)
                segments(x.coord[i, j] - arrowhead.length, avg[i, j], x.coord[i, j] + arrowhead.length, avg[i, j], lty = 1, col = j)
                
            }
        }
        
        for (j in (1:nlevel)) {
            lines(x.coord[, j], avg[, j], lty = 2, col = j)
        }
        
        label = names(sort(tapply(y[code1 == xmax], fac2[code1 == xmax], max)))
        label1 = as.numeric(names(sort(tapply(y[code1 == xmax], code2[code1 == xmax], max))))
        legend(xmax * 1.125 + interval.distance, yrange[2] + exlim * ydiff, substr(label[nlevel:1], 1, 5), col = label1[nlevel:1], pch = label1[nlevel:1], x.intersp = xlen, y.intersp = ylen)
        
    }
}


interactionPlots.formula = function(y, data = NULL, xlab = NULL, xlab2 = NULL, ylab = NULL, data.order = TRUE, exlim = 0.1, jitter = 0.02, conf.level = 0.95, interval.type = "tukey", pooled = TRUE, tick.length = 0.1, 
    interval.distance = 0.2, col.width = 2/3, xlab.distance = 0.1, xlen = 1.5, ylen = 1, ...) {
    
    ## This makes the naive assumption that the formula is correct.
    if (is.null(data)) 
        vars = eval(attr(terms(y), "variables"), parent.frame()) else vars = eval(attr(terms(y), "variables"), data)
    response = vars[[1]]
    fac1 = factor(vars[[2]])
    fac2 = factor(vars[[3]])
    
    nms = rownames(eval(attr(terms(y), "factors")))
    if (is.null(ylab)) 
        ylab = nms[1]
    if (is.null(xlab)) 
        xlab = nms[2]
    if (is.null(xlab2)) 
        xlab2 = nms[3]
    
    interactionPlots(y = response, fac1 = fac1, fac2 = fac2, xlab = xlab, xlab2 = xlab2, ylab = ylab, data.order = data.order, exlim = exlim, jitter = jitter, conf.level = conf.level, interval.type = interval.type, 
        pooled = pooled, tick.length = tick.length, interval.distance = interval.distance, col.width = col.width, xlab.distance = xlab.distance, xlen = xlen, ylen = ylen)
}

