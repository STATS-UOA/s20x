#' Deprecated box plots and normal quantile-quantile plots
#'
#' `boxqq()` is deprecated and is no longer exported. It draws boxplots and normal quantile-quantile plots of x for each value of the
#' grouping variable g
#'
#'
#' @param formula A symbolic specification of the form \code{x ~ g} can be given,
#' indicating the observations in the vector \code{x} are to be grouped according to
#' the levels of the factor \code{g}. \code{NA}'s are allowed in the data.
#' @param data An optional data frame in which to evaluate the formula.
#' @param ... Arguments to be passed to methods, such as graphical parameters
#' (see \code{\link{par}}).
#' @return Returns the plot.
#' @keywords hplot
#' @note This is a legacy teaching helper retained for compatibility with
#'   older course material. New teaching material should prefer current
#'   diagnostic plotting workflows.
#' @examplesIf FALSE
#'
#' ## Zoo data
#' data(zoo.df)
#' s20x:::boxqq(attendance ~ day.type, data = zoo.df)
#'
boxqq = function(formula, ...) {
  .Deprecated(
    msg = "boxqq() is deprecated and is no longer exported."
  )
  UseMethod("boxqq")
}

#' @describeIn boxqq Box plots and normal quantile-quantile plots
boxqq.formula = function(formula, data = NULL, ...) {
  restoreGraphicsParameters = saveGraphicsParameters(noReadonly = TRUE)
  on.exit(restoreGraphicsParameters())

  if (missing(formula) || length(formula) != 3) {
    stop("'formula' missing or incorrect")
  }

  modelCall = match.call(expand.dots = FALSE)
  if (is.matrix(eval(modelCall$data, parent.frame()))) {
    modelCall$data = as.data.frame(data)
  }

  modelCall[[1]] = as.name("model.frame")
  modelFrame = eval(modelCall, parent.frame())
  data = modelFrame

  par(mfrow = c(1, 2))
  par(mar = c(5.1, 4.1, 4.1, 0))
  boxplot(
    formula,
    data = data,
    xlab = names(data)[2],
    ylab = names(data)[1],
    main = paste(names(data)[1], "vs.", names(data)[2]),
    cex = 0.75,
    col = "yellow",
    ...
  )

  groupNames = unique(data[, 2])
  nGroups = length(groupNames)
  xValues = NULL
  yValues = NULL

  for (i in 1:nGroups) {
    qqValues = qqnorm(data[data[, 2] == groupNames[i], 1], plot.it = FALSE)
    xValues = c(xValues, qqValues$x)
    yValues = c(yValues, qqValues$y)
  }

  xLimits = range(xValues)
  yLimits = range(yValues)

  qqValues = qqnorm(data[data[, 2] == groupNames[1], 1], plot.it = FALSE)
  par(mar = c(5.1, 0, 4.1, 2.1))

  plot(
    sort(qqValues$x),
    sort(qqValues$y),
    pch = 1,
    xlim = xLimits,
    ylim = yLimits,
    xlab = "Normal Quantiles",
    yaxt = "n",
    type = "b",
    main = "Normal QQ Plots"
  )
  legendText = as.character(groupNames)
  legend(
    x = -1.9,
    y = max(yValues) - 0.1 * sd(yValues),
    legend = legendText,
    pch = 1:nGroups,
    col = 1:nGroups,
    bg = "antiquewhite2"
  )
  abline(
    mean(data[data[, 2] == groupNames[1], 1]),
    sd(data[data[, 2] == groupNames[1], 1])
  )

  if (nGroups >= 2) {
    for (j in 2:nGroups) {
      groupQqValues = qqnorm(data[data[, 2] == groupNames[j], 1], plot.it = FALSE)
      points(sort(groupQqValues$x), sort(groupQqValues$y), pch = j, col = j, type = "b")
      abline(
        mean(data[data[, 2] == groupNames[j], 1]),
        sd(data[data[, 2] == groupNames[j], 1]),
        col = j
      )
    }
  }
}
