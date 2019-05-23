#' Summary Statistics
#' 
#' Produces a table of summary statistics for the data. If the argument
#' \code{group} is missing, calculates a matrix of summary statistics for the
#' data in \code{x}. If \code{group} is present, the elements of \code{group}
#' are interpreted as group labels and the summary statistics are displayed for
#' each group separately.
#' 
#' @param x either a single vector of values, or a formula of the form
#' data~group, or a matrix.
#' @param data an optional data frame containing the variables in the model.
#' @param group a vector of group labels.
#' @param data.order if \code{TRUE}, the group order is the order which the groups are
#' first encountered in the vector 'group'. If \code{FALSE}, the order is alphabetical.
#' @param digits the number of decimal places to display.
#' @param \dots Optional arguments.
#' @return If \code{x} is a single variable, i.e. there are no groups, then a
#' single list is invisibly returned with the following named items:
#' \item{min}{Minimum value.} \item{max}{Maximum value.} \item{mean}{Mean
#' value.} \item{var}{Variance -- the average of the squares of the deviations
#' of the data values from the sample mean.} \item{sd}{Standard deviation --
#' the square root of the variance.} \item{n}{Number of data values -- size of
#' the data set.} \item{iqr}{Midspread (IQR) -- the range spanned by central
#' half of data; the interquartile range.} \item{skewness}{Skewness statistic
#' -- indicates how skewed the data set is. Positive values indicate right-skew
#' data. Negative values indicate left-skew data.} \item{lq}{Lower quartile}
#' \item{median}{Median -- the middle value when the batch is ordered.}
#' \item{uq}{Upper quartile} If grouping is provided, either by using the
#' \code{group} argument, or providing a factor in a formula, or by passing a
#' matrix where the different columns represent the groups, then the function
#' will return a \code{data.frame} a row containing all the statistics above
#' for each group.
#' @keywords multivariate
#' @examples
#' 
#' ## STATS20x data:
#' data(course.df)
#' 
#' ## Single variable summary
#' with(course.df, summaryStats(Exam))
#' 
#' ## Using a formula
#' summaryStats(Exam ~ Stage1, course.df)
#' 
#' ## Using a matrix
#' X = cbind(rnorm(50), rnorm(50))
#' summaryStats(X)
#' 
#' ## Saving and extracting the information
#' sumStats = summaryStats(Exam ~ Degree, course.df)
#' sumStats
#' 
#' ## Just the BAs
#' sumStats['BA', ]
#' 
#' ## Just the means
#' sumStats$mean
#' 
#' @export summaryStats
summaryStats = function(x, ...) {
    UseMethod("summaryStats")
}

#' @export
#' @describeIn summaryStats Summary Statistics
summaryStats.default = function(x, group = rep("Data", length(x)), data.order = TRUE, digits = 2, ...) {
    if (!is.factor(group)) {
        group = factor(group, levels = if (data.order) {
            unique(group)
        } else {
            sort(unique(group))
        })
        
    }
    
    getStats = function(x, ...) {
        quantiles = quantile(x, probs = c(0.25, 0.5, 0.75), ...)
        names(quantiles) = NULL  ## strip off the percentages
        
        results = c(min = min(x, ...), 
                    max = max(x, ...), 
                    mean = mean(x, ...), 
                    var = var(x, ...), 
                    sd = sd(x, ...), 
                    n = length(x), 
                    iqr = IQR(x, ...), 
                    skewness = skewness(x, ...), 
                    lq = quantiles[1], 
                    median = quantiles[2], 
                    uq = quantiles[3])
        
        if(hasArg(na.rm)){
            args = list(...)
            if(args$na.rm == TRUE){
                results["nMissing"] = sum(is.na(x))
            }
        }
        
        return(results)
    }
    
    stats = NULL
    
    if (length(unique(group)) == 1) {
        stats = as.list(getStats(x, ...))
        
        with(stats, {
            cat(paste("Minimum value:          ", round(min, digits), "\n"))
            cat(paste("Maximum value:          ", round(max, digits), "\n"))
            cat(paste("Mean value:             ", round(mean, digits), "\n"))
            cat(paste("Median:                 ", round(median, digits), "\n"))
            cat(paste("Upper quartile:         ", round(uq, digits), "\n"))
            cat(paste("Lower quartile:         ", round(lq, digits), "\n"))
            cat(paste("Variance:               ", round(var, digits), "\n"))
            cat(paste("Standard deviation:     ", round(sd, digits), "\n"))
            cat(paste("Midspread (IQR):        ", round(iqr, digits), "\n"))
            cat(paste("Skewness:               ", round(skewness, digits), "\n"))
            cat(paste("Number of data values:  ", n, "\n"))
        })
        
        if("nMissing" %in% names(stats)){
            cat(paste("Number of missing values:  ", stats$nMissing, "\n"))
        }
        
    } else {
        temp.df = data.frame(x = x, group = group)
        na.action = if(hasArg(na.action)){
            args = list(...)
            args$na.action
        }else{
            na.pass
        }
        stats = aggregate(x ~ group, data = temp.df, FUN = getStats, na.action = na.action, ... = ...)
        
        ##resTable = aggregate(x ~ group, data = temp.df, FUN = getStats)
        resTable = stats
        rownames(resTable$x) = resTable$group
        
        if("nMissing" %in% colnames(stats$x)){
            resTable = as.data.frame(resTable$x[,c("n", "nMissing", "mean", "median", "sd", "iqr")])
            resTable$n = resTable$n - resTable$nMissing
            names(resTable) = c("Sample Size", "No. Miss.", "Mean", "Median", "Std Dev", "Midspread")
        }else{
            resTable = as.data.frame(resTable$x[,c("n", "mean", "median", "sd", "iqr")])
            colnames(resTable) = c("Sample Size", "Mean", "Median", "Std Dev", "Midspread")
        }
        
        print(resTable)
        
        rownames(stats$x) = stats$group
        stats = as.data.frame(stats$x)
        
    }
    
    invisible(stats)
}

#' @export
#' @describeIn summaryStats Summary Statistics
summaryStats.formula = function(x, data = NULL, data.order = TRUE, digits = 2, ...) {
    if (missing(x) || (length(x) != 3)) {
        stop("missing or incorrect formula")
    }
    
    if (is.null(data)) {
        vars = eval(attr(terms(x), "variables"), parent.frame())
    } else {
        vars = eval(attr(terms(x), "variables"), data)
    }
    
    summaryStats(vars[[1]], vars[[2]], data.order = data.order, digits = digits, ...)
}

#' @export
#' @describeIn summaryStats Summary Statistics
summaryStats.matrix = function(x, data.order = TRUE, digits = 2, ...) {
    nrows = nrow(x)
    ncols = ncol(x)
    
    x = as.vector(x)
    group = factor(rep(1:ncols, rep(nrows, ncols)))
    
    summaryStats(x, group, data.order = data.order, digits = digits, ...)
}
