#' Testing for equality of variance plot
#'
#' Plots the residuals versus the fitted (or predicted) values from a linear
#' model. A horizontal line is drawn at y = 0, reflecting the fact that we
#' expect the residuals to have a mean of zero. An optional lowess line is
#' drawn if smoother is set to TRUE. This can be useful in determining whether
#' a trend still exists in the residuals. An optional pair of lines is drawn at
#' +/- 2 times the standard deviation of the residuals - which is estimated
#' from the Residual Mean Sqare (Within group mean square = WGMS). This can be
#' useful in highlighting potential outliers.
#'
#' The default base graphics engine preserves the original teaching plot and
#' draws directly on the active graphics device. The optional ggplot2 engine is
#' intended for users who want a reusable plot object for reports or further
#' customisation; it requires \pkg{ggplot2} to be installed and returns a ggplot
#' object instead of drawing a base graphics side effect.
#'
#' @param x A linear model formula. Alternatively, a fitted lm object from
#' a linear model.
#' @param data A data frame in which to evaluate the formula.
#' @param xlab a title for the x axis: see \code{\link{title}}.
#' @param ylab a title for the y axis: see \code{\link{title}}.
#' @param col a colour for the lowess smoother line.
#' @param smoother if TRUE then a smoothed lowess line will be added to the
#' plot
#' @param twosd if \code{TRUE} then horizontal dotted lines will be drawn at +/-2sd
#' @param engine plotting engine to use. The default, \code{"base"}, preserves
#' the original base graphics output. Use \code{"ggplot2"} for an optional
#' ggplot2 object.
#' @param \dots Optional arguments passed to the base plotting engine. Extra
#' arguments are currently ignored by the ggplot2 engine.
#' @return Draws the residual-versus-fitted diagnostic plot when using the base
#' engine. With \code{engine = "ggplot2"}, returns a ggplot object.
#' @keywords hplot
#' @examples
#'
#' # one way ANOVA - oysters
#' data(oysters.df)
#' oyster.fit = lm(Oysters ~ Site, data = oysters.df)
#' eovcheck(oyster.fit)
#'
#' # Same model as the previous example, but using eovcheck.formula
#' data(oysters.df)
#' eovcheck(Oysters ~ Site, data = oysters.df)
#'
#'
#' # A two-way model without interaction
#' data(soyabean.df)
#' soya.fit = lm(yield ~ planttime + cultivar, data = soyabean.df)
#' eovcheck(soya.fit)
#'
#' # A two-way model with interaction
#' data(arousal.df)
#' arousal.fit = lm(arousal ~ gender * picture, data = arousal.df)
#' eovcheck(arousal.fit)
#'
#' # A regression model
#' data(peru.df)
#' peru.fit = lm(BP ~ height + weight + age + years, data = peru.df)
#' eovcheck(peru.fit)
#'
#'
#' # A time series model
#' data(airpass.df)
#' t = 1:144
#' month = factor(rep(1:12, 12))
#' airpass.df = data.frame(passengers = airpass.df$passengers, t = t, month = month)
#' airpass.fit = lm(log(passengers)[-1] ~ t[-1] + month[-1]
#'                  + log(passengers)[-144], data  = airpass.df)
#' eovcheck(airpass.fit)
#'
#' # Optional ggplot2 engine for reusable plot objects
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   eovPlot = eovcheck(oyster.fit, engine = "ggplot2")
#'   class(eovPlot)
#'
#'   eovcheck(peru.fit, engine = "ggplot2", smoother = TRUE)
#'   eovcheck(oyster.fit, engine = "ggplot2", twosd = TRUE)
#' }
#'
#' @importFrom methods is
#' @importFrom rlang .data
#' @export eovcheck
eovcheck = function(x, ...) {
  UseMethod("eovcheck")
}

#' @rdname eovcheck
#' @importFrom methods is
#' @export
eovcheck.formula = function(x, data = NULL,
                             xlab = "Fitted values", ylab = "Residuals",
                             col = NULL, smoother = FALSE, twosd = FALSE,
                             engine = c("base", "ggplot2"), ...) {
  if (missing(x) || !is(x, "formula")) {
    stop("missing or incorrect formula formula")
  }

  engine = matchPlottingEngine(engine)

  call = match.call()
  m = match.call()
  mn = match(c("x", "data"), names(m), 0)
  m = m[c(1, mn)]
  m$drop.unused.levels = TRUE

  form = formula(eval(m[[2]], parent.frame()))
  terms.form = terms(form)

  data.f = data.frame(eval(m[[3]], parent.frame()))

  if (attr(terms.form, "response") == 0) {
    stop("There must be a response variable in the formula")
  }

  m[[1]] = as.name("model.frame")
  names(m)[[2]] = "formula"
  m = eval(m, parent.frame())

  eovcheckFromFit(
    fit = lm(form, data = data.f),
    m = m,
    xlab = xlab,
    ylab = ylab,
    col = col,
    smoother = smoother,
    twosd = twosd,
    engine = engine,
    ...
  )
}

#' @rdname eovcheck
#' @importFrom methods is
#' @export
eovcheck.lm = function(x, smoother = FALSE, twosd = FALSE,
                        engine = c("base", "ggplot2"), ...) {
  if (missing(x) || !is(x, "lm")) {
    stop("missing or incorrect lm object")
  }

  engine = matchPlottingEngine(engine)

  ## Use the fitted model itself so subset, na.action and the caller's variables
  ## are respected. Weights and offsets are model-frame columns, not covariates.
  modelFrame = model.frame(x)

  ## glm objects inherit from lm, and have always been checked with least squares
  fit = if (inherits(x, "glm")) {
    lm(model.response(modelFrame) ~ model.matrix(x) - 1)
  } else {
    x
  }

  eovcheckFromFit(
    fit = fit,
    m = modelFrame[!grepl("^[(]", names(modelFrame))],
    smoother = smoother,
    twosd = twosd,
    engine = engine,
    ...
  )
}

#' Build and draw an equality-of-variance diagnostic from a fitted model
#'
#' @param fit fitted model supplying residuals and fitted values.
#' @param m model frame holding the response and explanatory variables.
#' @param xlab x-axis label.
#' @param ylab y-axis label.
#' @param col smoother line colour.
#' @param smoother whether to draw a lowess smoother.
#' @param twosd whether to draw +/- 2 sigma reference lines.
#' @param engine matched plotting engine.
#' @param levene removed argument, caught here so that old code gets a clear
#'   warning instead of passing it on to the plotting functions.
#' @param \dots arguments passed to the base graphics engine.
#' @return The value of the selected plotting engine.
#' @noRd
eovcheckFromFit = function(fit, m,
                           xlab = "Fitted values", ylab = "Residuals",
                           col = NULL, smoother = FALSE, twosd = FALSE,
                           engine = "base", levene = NULL, ...) {
  if (!is.null(levene)) {
    warning(
      "The levene argument of eovcheck() has been removed and is ignored.",
      call. = FALSE
    )
  }

  if (ncol(m) == 1) {
    stop("You must have at least two variables for this function to work")
  }

  diagnosticData = getModelResidualFittedData(fit, context = "equality-of-variance model")
  diagnosticInfo = list(
    fit = fit,
    diagnosticData = diagnosticData
  )

  if (engine == "ggplot2") {
    return(eovcheck_ggplot2(
      diagnosticInfo = diagnosticInfo,
      xlab = xlab,
      ylab = ylab,
      col = col,
      smoother = smoother,
      twosd = twosd
    ))
  }

  eovcheckBase(
    diagnosticInfo = diagnosticInfo,
    xlab = xlab,
    ylab = ylab,
    col = col,
    smoother = smoother,
    twosd = twosd,
    ...
  )
}

#' Draw an equality-of-variance diagnostic using base graphics
#'
#' @param diagnosticInfo fitted model and diagnostic data.
#' @param xlab x-axis label.
#' @param ylab y-axis label.
#' @param col smoother line colour.
#' @param smoother whether to draw a lowess smoother.
#' @param twosd whether to draw +/- 2 sigma reference lines.
#' @param \dots arguments passed to \code{plot}.
#' @return Draws a base graphics plot for side effects.
#' @noRd
eovcheckBase = function(diagnosticInfo, xlab, ylab, col, smoother, twosd, ...) {
  opar = par(xaxs = "r", yaxs = "r")
  on.exit(par(opar))

  diagnosticData = diagnosticInfo$diagnosticData
  plot(diagnosticData$residuals ~ diagnosticData$fitted, xlab = xlab, ylab = ylab, main = "", ...)
  abline(h = 0, lty = 3, col = "lightgrey")
  resids = diagnosticData$residuals
  yhat = diagnosticData$fitted

  if (smoother) {
    smootherColour = if (is.null(col)) {
      "lightblue"
    } else {
      col
    }
    lines(lowess(yhat, resids), col = smootherColour)
  }

  if (twosd) {
    sigma = sigma(diagnosticInfo$fit)
    abline(h = c(-2, 2) * sigma, lty = 3, col = "grey", lwd = 2)
  }
}

#' Build an equality-of-variance diagnostic using ggplot2
#'
#' @param diagnosticInfo fitted model and diagnostic data.
#' @param xlab x-axis label.
#' @param ylab y-axis label.
#' @param col smoother line colour.
#' @param smoother whether to draw a lowess smoother.
#' @param twosd whether to draw +/- 2 sigma reference lines.
#' @return A ggplot object.
#' @noRd
eovcheck_ggplot2 = function(diagnosticInfo, xlab, ylab, col, smoother, twosd) {
  requirePlottingPackage("ggplot2")


  diagnosticData = diagnosticInfo$diagnosticData
  plotData = data.frame(
    fitted = as.numeric(diagnosticData[["fitted"]]),
    residuals = as.numeric(diagnosticData[["residuals"]])
  )

  yRange = range(plotData$residuals, finite = TRUE)

  if (twosd) {
    sigma = sigma(diagnosticInfo$fit)
    twoSdValues = c(-2, 2) * sigma
    yRange = range(c(yRange, twoSdValues), finite = TRUE)
  } else {
    sigma = NULL
    twoSdValues = NULL
  }

  plotObject = ggplot(
    plotData,
    aes(x = .data$fitted, y = .data$residuals)
  ) +
    geom_point(shape = 1) +
    geom_hline(yintercept = 0, linetype = 3, colour = "lightgrey", linewidth = 0.4) +
    labs(x = xlab, y = ylab, title = "") +
    coord_cartesian(ylim = yRange) +
    s20x_ggplot2_base_theme()

  if (smoother) {
    smootherColour = if (is.null(col)) {
      "lightblue"
    } else {
      col
    }
    plotObject = plotObject + geom_smooth(
      method = "loess",
      se = FALSE,
      colour = smootherColour,
      linewidth = 0.5
    )
  }

  if (twosd) {
    plotObject = plotObject + geom_hline(
      yintercept = twoSdValues,
      linetype = 3,
      colour = "grey",
      linewidth = 0.5
    )
  }

  plotObject
}
