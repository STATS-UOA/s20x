#' Testing for normality plot
#'
#' Plots two plots side by side. First, it draws a normal Q-Q plot of the
#' residuals, along with a line with intercept equal to the mean of the
#' residuals and slope equal to the standard deviation of the residuals. If
#' \code{shapiro.wilk = TRUE}, the P-value from the Shapiro-Wilk test for
#' normality is shown in the top-left corner of the Q-Q plot. Second, it draws
#' a histogram of the residuals. A normal distribution is fitted and
#' superimposed over the histogram. Note: if you want to leave the
#' x-axis blank in the histogram then use \code{xlab = c("Theoretical Quantiles", " ")}
#' , i.e. leave a space between the quotes. If you do not leave a space,
#' information will be extracted from \code{x}.
#'
#' The default base graphics engine preserves the original teaching plots and
#' draws directly on the active graphics device. The optional ggplot2 engine is
#' intended for users who want reusable plot objects for reports or further
#' customisation; it requires \pkg{ggplot2} to be installed and returns ggplot
#' objects instead of drawing base graphics side effects.
#'
#' @param x the residuals from fitting a linear model.  Alternatively, a fitted \code{lm} object.
#' @param xlab a title for the x-axis of both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param ylab a title for the y-axis of both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param main a title for both the Q-Q plot and the histogram: see \code{\link{title}}.
#' @param col a colour for the bars of the histogram.
#' @param bootstrap if \code{TRUE} then \code{B} samples will be taken from a Normal distribution
#' with the same mean and standard deviation as \code{x}. These will be plotted
#' in a lighter colour behind the empirical quantiles to show how much variation
#' would be expected in the Q-Q plot for a sample of the same size from a truly
#' normal distribution.
#' @param B the number of bootstrap samples to take. Five should usually be sufficient.
#' @param bpch the plotting symbol used for the bootstrap samples. Legal values are the same as any legal
#' value for \code{pch} as defined in \code{\link{par}}.
#' @param bcol the plotting colour used for the bootstrap samples. Legal values are the same as any legal
#' value for \code{col} as defined in \code{\link{par}}.
#' @param shapiro.wilk if \code{TRUE}, the P-value from the Shapiro-Wilk
#' test for normality is displayed in the top-left corner of the Q-Q plot.
#' @param whichPlot legal values are  \code{1}, \code{2}, and any pair of the two, i.e. \code{1:2}, \code{2:1},
#' \code{c(1,2)}, \code{c(2,1)}, or variants of \code{c(1,1)}.
#' \code{1:2} is used by default and draws a normal Q-Q plot and a histogram of the residuals
#' in that order. The order of the labels in \code{xlab} and \code{ylab} assume this order, and will be
#' reordered automatically if the order is anything other than \code{1:2}.
#' @param usePar if \code{TRUE}, this function sets \code{\link{par}} for the user. If \code{FALSE},
#' this function assumes \code{\link{par}} has been set by the user and should
#' not be overridden. Ignored by the ggplot2 engine.
#' @param residualType for \code{tslm} objects, the residual scale to use in the normality plots.
#' The default is \code{"normalised"}, which checks the residuals after accounting for
#' the fitted error correlation structure. \code{"normalised"} and \code{"normalized"}
#' are both accepted for compatibility. Other choices are \code{"response"} and
#' \code{"pearson"}.
#' @param engine plotting engine to use. The default, \code{"base"}, preserves
#' the original base graphics output. Use \code{"ggplot2"} for optional ggplot2
#' objects.
#' @param \dots additional arguments which are passed to both \code{qqnorm} and \code{hist}
#' for the base engine. Extra arguments are currently ignored by the ggplot2
#' engine.
#' @return Draws the selected normality diagnostic plots when using the base
#' engine. With \code{engine = "ggplot2"}, returns a ggplot object for a single
#' selected plot or a named list of ggplot objects for multiple selected plots.
#' @seealso \code{\link{shapiro.test}}.
#' @keywords hplot
#' @examples
#'
#' # Synthetic teaching example: an exponential growth curve
#' set.seed(123)
#' e = rnorm(100, 0, 0.1)
#' x = rnorm(100)
#' y = exp(5 + 3 * x + e)
#' fit = lm(y ~ x)
#' normcheck(fit)
#'
#' # An exponential growth curve with the correct transformation
#' fit = lm(log(y) ~ x)
#' normcheck(fit)
#'
#' # Same example as above except we use normcheck.default
#' normcheck(residuals(fit))
#'
#' # Peruvian Indians data
#' data(peru.df)
#' peruFit = lm(BP ~ weight, data = peru.df)
#' normcheck(peruFit)
#'
#' # Optional ggplot2 engine for reusable plot objects
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   normPlots = normcheck(peruFit, engine = "ggplot2")
#'   names(normPlots)
#' }
#'
#' @export normcheck
normcheck = function(x, ...) {
  UseMethod("normcheck")
}

#' @export
#' @rdname normcheck
#' @importFrom grDevices colors
normcheck.default = function(x,
                             xlab = c("Theoretical Quantiles", ""),
                             ylab = c("Sample Quantiles", ""),
                             main = c("", ""), col = "light blue",
                             bootstrap = FALSE, B = 5, bpch = 3,
                             bcol = "lightgrey", shapiro.wilk = FALSE,
                             whichPlot = 1:2, usePar = TRUE,
                             engine = c("base", "ggplot2"), ...) {
  engine = match.arg(engine)

  if (!all(whichPlot %in% 1:2)) {
    stop("whichPlot must be in 1:2")
  }

  labels = prepareNormcheckLabels(x, xlab, ylab, main, whichPlot)
  xlab = labels$xlab
  ylab = labels$ylab
  main = labels$main

  col = match.arg(col, c("light blue", colors()))
  bcol = match.arg(bcol, colors())

  if (engine == "ggplot2") {
    return(normcheckGgplot2(
      x = x,
      xlab = xlab,
      ylab = ylab,
      main = main,
      col = col,
      bootstrap = bootstrap,
      B = B,
      bpch = bpch,
      bcol = bcol,
      shapiro.wilk = shapiro.wilk,
      whichPlot = whichPlot
    ))
  }

  normcheckBase(
    x = x,
    xlab = xlab,
    ylab = ylab,
    main = main,
    col = col,
    bootstrap = bootstrap,
    B = B,
    bpch = bpch,
    bcol = bcol,
    shapiro.wilk = shapiro.wilk,
    whichPlot = whichPlot,
    usePar = usePar,
    ...
  )
}

#' @rdname normcheck
#' @export
normcheck.lm = function(x, xlab = c("Theoretical Quantiles", ""),
                        ylab = c("Sample Quantiles", ""),
                        main = c("", ""), col = "light blue",
                        bootstrap = FALSE, B = 5, bpch = 3,
                        bcol = "lightgrey", shapiro.wilk = FALSE,
                        whichPlot = 1:2, usePar = TRUE,
                        engine = c("base", "ggplot2"), ...) {
  if (missing(x) || !is(x, "lm")) {
    stop("missing or incorrect lm object")
  }

  engine = match.arg(engine)

  if (!all(whichPlot %in% 1:2)) {
    stop("whichPlot must be in 1:2")
  }

  if (2 %in% whichPlot) {
    if (length(xlab) == 2) {
      if (!is.na(xlab[2]) && xlab[2] == "") {
        xlab[2] = paste("Residuals from lm(", as.character(x$call[2]), ")", sep = "")
      }
    } else {
      if (!is.na(xlab) && xlab == "") {
        xlab = paste("Residuals from lm(", as.character(x$call[2]), ")", sep = "")
      }
    }
  }

  normcheck(
    residuals(x),
    xlab = xlab,
    ylab = ylab,
    main = main,
    col = col,
    bootstrap = bootstrap,
    B = B,
    bpch = bpch,
    bcol = bcol,
    shapiro.wilk = shapiro.wilk,
    whichPlot = whichPlot,
    usePar = usePar,
    engine = engine,
    ...
  )
}

#' @rdname normcheck
#' @export
normcheck.tslm = function(x, xlab = c("Theoretical Quantiles", ""),
                          ylab = c("Sample Quantiles", ""),
                          main = c("", ""), col = "light blue",
                          bootstrap = FALSE, B = 5, bpch = 3,
                          bcol = "lightgrey", shapiro.wilk = FALSE,
                          whichPlot = 1:2, usePar = TRUE,
                          residualType = "normalised",
                          engine = c("base", "ggplot2"), ...) {
  if (missing(x) || !is(x, "tslm")) {
    stop("missing or incorrect tslm object")
  }

  residualType = matchTslmResidualType(residualType)
  engine = match.arg(engine)

  normcheck(
    residuals(x, type = residualType),
    xlab = xlab,
    ylab = ylab,
    main = main,
    col = col,
    bootstrap = bootstrap,
    B = B,
    bpch = bpch,
    bcol = bcol,
    shapiro.wilk = shapiro.wilk,
    whichPlot = whichPlot,
    usePar = usePar,
    engine = engine,
    ...
  )
}

#' Prepare normcheck labels in selected plot order
#'
#' @param x residual vector.
#' @param xlab x-axis labels.
#' @param ylab y-axis labels.
#' @param main plot titles.
#' @param whichPlot selected plot identifiers.
#' @return A list of ordered labels.
#' @noRd
prepareNormcheckLabels = function(x, xlab, ylab, main, whichPlot) {
  if (length(xlab) == length(whichPlot)) {
    if (length(whichPlot) == 2) {
      xlab = xlab[whichPlot]
      ylab = ylab[whichPlot]
      main = main[whichPlot]
    }
  } else {
    if (length(xlab) == 2 && length(whichPlot) == 1) {
      xlab = xlab[whichPlot]
      ylab = ylab[whichPlot]
      main = main[whichPlot]
    }
  }

  if (2 %in% whichPlot) {
    idx = which(whichPlot == 2)
    if (!is.na(xlab[idx]) && xlab[idx] == "") {
      xlab[idx] = deparse(substitute(x))
    }
  }

  list(xlab = xlab, ylab = ylab, main = main)
}

#' Draw normcheck plots using base graphics
#'
#' @param x residual vector.
#' @param xlab x-axis labels.
#' @param ylab y-axis labels.
#' @param main plot titles.
#' @param col histogram bar colour.
#' @param bootstrap whether bootstrap Q-Q samples should be shown.
#' @param B number of bootstrap samples.
#' @param bpch bootstrap plotting character.
#' @param bcol bootstrap plotting colour.
#' @param shapiro.wilk whether Shapiro-Wilk text should be shown.
#' @param whichPlot selected plot identifiers.
#' @param usePar whether to set plotting parameters.
#' @param \dots arguments passed to base plotting functions.
#' @return Draws base graphics plots for side effects.
#' @noRd
normcheckBase = function(x, xlab, ylab, main, col, bootstrap, B, bpch, bcol,
                         shapiro.wilk, whichPlot, usePar, ...) {
  oldPar = par(no.readonly = TRUE)

  mx = mean(x)
  sx = sd(x)
  nx = length(x)

  qqPlot = function(i) {
    qqp = qqnorm(x, axes = FALSE, xlab = "", ylab = "", main = "",
                 xaxs = "r", yaxs = "r", ...)
    box()
    title(xlab = xlab[i], line = 0.05)
    title(ylab = ylab[i], line = 0.05)
    if (main[1] != "") {
      title(main = main[i])
    }

    if (bootstrap) {
      p = ppoints(nx)
      qz = qnorm(p)

      for (b in 1:B) {
        z = rnorm(nx, mx, sx)
        points(qz[order(order(z))], z, pch = bpch, col = bcol)
      }
      points(qqp$x, qqp$y)
      legend("topleft", pch = c(1, 3), col = c("black", bcol),
             legend = c("Data", "Bootstrap samples"),
             cex = 0.7, bty = "n")
    }

    qqline(x, col = "black")

    if (shapiro.wilk) {
      stest = shapiro.test(x)
      txt = paste(
        "Shapiro-Wilk normality test",
        "\n",
        "W = ",
        round(stest$statistic, 4),
        "\n",
        "P-value = ",
        round(stest$p.value, 3),
        sep = ""
      )
      text(sort(qqp$x)[2], 0.99 * sort(qqp$y)[length(qqp$y)], txt, adj = c(0, 1))
    }
  }

  histPlot = function(i) {
    h = hist(x, plot = FALSE)
    rx = range(x)
    xmin = min(rx[1], mx - 3.5 * sx, h$breaks[1])
    xmax = max(rx[2], mx + 3.5 * sx, h$breaks[length(h$breaks)])
    ymax = max(h$density, dnorm(mx, mx, sx)) * 1.05

    hist(x, prob = TRUE, ylim = c(0, ymax), xlim = c(xmin, xmax), col = col,
         xlab = "", ylab = "", main = "", axes = FALSE, yaxs = "i", ...)
    w = strwidth(xlab[i], units = "figure")

    if (w < 0.95) {
      title(xlab = xlab[i], line = 0.05)
    } else {
      m = 1 / (w * 1.1)
      title(xlab = xlab[i], line = 0.05, cex.lab = m)
    }
    title(ylab = ylab[i], line = 0.05)
    title(main = main[i], line = 0.05)
    box()

    usr = par("usr")
    x1 = seq(usr[1], usr[2], length = 100)
    y1 = dnorm(x1, mx, sx)
    lines(x1, y1, lwd = 1.5, lty = 3)
  }

  mfrow = c(1, 2)[1:length(whichPlot)]

  if (usePar) {
    if (length(mfrow) > 1) {
      par(mfrow = mfrow)
    }
    par(xaxs = "r", yaxs = "r", pty = "s", mai = c(0.2, 0.2, 0.05, 0.05))
    on.exit(par(oldPar))
  }

  plots = c(qqPlot, histPlot)[whichPlot]
  i = 1
  for (p in plots) {
    p(i)
    i = i + 1
  }
}

#' Build normcheck plots using ggplot2
#'
#' @param x residual vector.
#' @param xlab x-axis labels.
#' @param ylab y-axis labels.
#' @param main plot titles.
#' @param col histogram bar colour.
#' @param bootstrap whether bootstrap Q-Q samples should be shown.
#' @param B number of bootstrap samples.
#' @param bpch bootstrap plotting character.
#' @param bcol bootstrap plotting colour.
#' @param shapiro.wilk whether Shapiro-Wilk text should be shown.
#' @param whichPlot selected plot identifiers.
#' @return A ggplot object or a named list of ggplot objects.
#' @noRd
normcheckGgplot2 = function(x, xlab, ylab, main, col, bootstrap, B, bpch, bcol,
                            shapiro.wilk, whichPlot) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("The ggplot2 engine requires the ggplot2 package.", call. = FALSE)
  }

  plots = vector("list", length(whichPlot))
  names(plots) = ifelse(whichPlot == 1, "qq", "histogram")

  for (i in seq_along(whichPlot)) {
    if (whichPlot[i] == 1) {
      plots[[i]] = normcheckGgplot2Qq(
        x = x,
        xlab = xlab[i],
        ylab = ylab[i],
        main = main[i],
        bootstrap = bootstrap,
        B = B,
        bpch = bpch,
        bcol = bcol,
        shapiro.wilk = shapiro.wilk
      )
    } else {
      plots[[i]] = normcheckGgplot2Histogram(
        x = x,
        xlab = xlab[i],
        ylab = ylab[i],
        main = main[i],
        col = col
      )
    }
  }

  if (length(plots) == 1) {
    return(plots[[1]])
  }

  class(plots) = c("s20xNormcheckGgplot2", class(plots))
  plots
}

#' Build a ggplot2 normal Q-Q plot for normcheck
#'
#' @param x residual vector.
#' @param xlab x-axis label.
#' @param ylab y-axis label.
#' @param main plot title.
#' @param bootstrap whether bootstrap samples should be shown.
#' @param B number of bootstrap samples.
#' @param bpch bootstrap plotting character.
#' @param bcol bootstrap plotting colour.
#' @param shapiro.wilk whether Shapiro-Wilk text should be shown.
#' @return A ggplot object.
#' @noRd
normcheckGgplot2Qq = function(x, xlab, ylab, main, bootstrap, B, bpch, bcol,
                              shapiro.wilk) {
  ggplot = getExportedValue("ggplot2", "ggplot")
  aes = getExportedValue("ggplot2", "aes")
  geomPoint = getExportedValue("ggplot2", "geom_point")
  geomAbline = getExportedValue("ggplot2", "geom_abline")
  labs = getExportedValue("ggplot2", "labs")
  annotate = getExportedValue("ggplot2", "annotate")

  qqp = qqnorm(x, plot.it = FALSE)
  plotData = data.frame(theoretical = qqp$x, sample = qqp$y)
  plotObject = ggplot(plotData, aes(x = plotData[["theoretical"]], y = plotData[["sample"]]))

  if (bootstrap) {
    bootstrapData = normcheckBootstrapQqData(x, B)
    plotObject = plotObject + geomPoint(
      data = bootstrapData,
      mapping = aes(
        x = bootstrapData[["theoretical"]],
        y = bootstrapData[["sample"]]
      ),
      shape = bpch,
      colour = bcol
    )
  }

  plotObject = plotObject +
    geomPoint(shape = 1) +
    geomAbline(intercept = mean(x), slope = sd(x)) +
    labs(x = xlab, y = ylab, title = main)

  if (shapiro.wilk) {
    stest = shapiro.test(x)
    txt = paste(
      "Shapiro-Wilk normality test",
      "\n",
      "W = ",
      round(stest$statistic, 4),
      "\n",
      "P-value = ",
      round(stest$p.value, 3),
      sep = ""
    )
    plotObject = plotObject + annotate(
      "text",
      x = sort(qqp$x)[2],
      y = 0.99 * sort(qqp$y)[length(qqp$y)],
      label = txt,
      hjust = 0,
      vjust = 1
    )
  }

  plotObject
}

#' Build bootstrap Q-Q point data
#'
#' @param x residual vector.
#' @param B number of bootstrap samples.
#' @return A data frame of theoretical and sample quantiles.
#' @noRd
normcheckBootstrapQqData = function(x, B) {
  mx = mean(x)
  sx = sd(x)
  nx = length(x)
  p = ppoints(nx)
  qz = qnorm(p)
  bootstrapData = vector("list", B)

  for (b in seq_len(B)) {
    z = rnorm(nx, mx, sx)
    bootstrapData[[b]] = data.frame(
      theoretical = qz[order(order(z))],
      sample = z,
      sampleId = b
    )
  }

  do.call(rbind, bootstrapData)
}

#' Build a ggplot2 histogram with normal curve for normcheck
#'
#' @param x residual vector.
#' @param xlab x-axis label.
#' @param ylab y-axis label.
#' @param main plot title.
#' @param col histogram fill colour.
#' @return A ggplot object.
#' @noRd
normcheckGgplot2Histogram = function(x, xlab, ylab, main, col) {
  ggplot = getExportedValue("ggplot2", "ggplot")
  aes = getExportedValue("ggplot2", "aes")
  geomRect = getExportedValue("ggplot2", "geom_rect")
  geomLine = getExportedValue("ggplot2", "geom_line")
  labs = getExportedValue("ggplot2", "labs")
  coordCartesian = getExportedValue("ggplot2", "coord_cartesian")

  mx = mean(x)
  sx = sd(x)
  h = hist(x, plot = FALSE)
  rx = range(x)
  xmin = min(rx[1], mx - 3.5 * sx, h$breaks[1])
  xmax = max(rx[2], mx + 3.5 * sx, h$breaks[length(h$breaks)])
  ymax = max(h$density, dnorm(mx, mx, sx)) * 1.05

  histData = data.frame(
    xmin = h$breaks[-length(h$breaks)],
    xmax = h$breaks[-1],
    ymin = 0,
    ymax = h$density
  )
  normalData = data.frame(
    x = seq(xmin, xmax, length.out = 100),
    y = dnorm(seq(xmin, xmax, length.out = 100), mx, sx)
  )

  ggplot() +
    geomRect(
      data = histData,
      mapping = aes(
        xmin = histData[["xmin"]],
        xmax = histData[["xmax"]],
        ymin = histData[["ymin"]],
        ymax = histData[["ymax"]]
      ),
      fill = col,
      colour = "black"
    ) +
    geomLine(
      data = normalData,
      mapping = aes(x = normalData[["x"]], y = normalData[["y"]]),
      linetype = 3,
      linewidth = 1.5
    ) +
    coordCartesian(xlim = c(xmin, xmax), ylim = c(0, ymax), expand = FALSE) +
    labs(x = xlab, y = ylab, title = main)
}
