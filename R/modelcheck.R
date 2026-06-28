#' Model checking plots
#'
#' Draw the teaching diagnostic plots used by older `s20x` workflows.
#' `modelcheck()` is retained as an exported compatibility helper for model
#' checking, while newer teaching material may use focused diagnostic helpers
#' such as [eovcheck()], [normcheck()], and [cooks20x()] directly.
#'
#' The default base graphics engine preserves the original teaching plots and
#' draws directly on the active graphics device. The optional ggplot2 engine is
#' intended for users who want reusable plot objects for reports or further
#' customisation; it requires \pkg{ggplot2} to be installed and returns ggplot
#' objects instead of drawing base graphics side effects.
#'
#' @param x The fitted model.
#' @param which The plot(s) to be drawn. Residuals versus fitted values
#' (\code{which = 1}), histogram and Q-Q plot of residuals
#' (\code{which = 2}), and Cook's distance plot (\code{which = 3}).
#' @param mar Margins applied to each selected plot. Ignored by the ggplot2
#' engine.
#' @param engine plotting engine to use. The default, \code{"base"}, preserves
#' the original base graphics output. Use \code{"ggplot2"} for optional ggplot2
#' objects.
#' @param \ldots any other arguments to pass to \code{\link{plot}} for the base
#' engine. Extra arguments are currently ignored by the ggplot2 engine.
#' @return Draws diagnostic plots for teaching model checking when using the
#' base engine. With \code{engine = "ggplot2"}, returns a ggplot object for a
#' single selected plot, or a named list of ggplot objects for multiple selected
#' plots.
#' @examples
#' data(peru.df)
#' lmFit = lm(BP ~ weight, data = peru.df)
#'
#' # Plot residuals versus fitted values only
#' modelcheck(lmFit, 1)
#'
#' # Plot residuals versus fitted values, histogram, and Q-Q plot
#' modelcheck(lmFit, 1:2)
#'
#' # Plot all diagnostics
#' modelcheck(lmFit)
#'
#' # Optional ggplot2 engine for reusable plot objects
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   diagnosticPlots = modelcheck(lmFit, engine = "ggplot2")
#'   names(diagnosticPlots)
#'
#'   modelcheck(lmFit, which = 1, engine = "ggplot2")
#'   modelcheck(lmFit, which = 2, engine = "ggplot2")
#'   modelcheck(lmFit, which = 3, engine = "ggplot2")
#' }
#' @importFrom rlang .data
#' @importFrom ggplot2 geom_text
#' @export
modelcheck = function(x, ...) {
  UseMethod("modelcheck")
}

#' @rdname modelcheck
#' @export
modelcheck.lm = function(x, which = 1:3, mar = c(3, 4, 1.5, 4),
                          engine = c("base", "ggplot2"), ...) {
  engine = matchPlottingEngine(engine)

  if (!all(which %in% 1:3)) {
    stop("which must be in 1:3")
  }

  if (engine == "ggplot2") {
    return(modelcheck_ggplot2(x = x, which = which))
  }

  createLayoutMatrix = function() {
    M = matrix(NA, nrow = length(which), ncol = 2)
    k = 1

    if (1 %in% which) {
      M[1, ] = c(1, 1)
      k = k + 1
    }

    if (2 %in% which) {
      M[k, ] = c(k, k + 1)
      k = k + 2
    }

    if (3 %in% which) {
      M[length(which), ] = c(k, k)
    }

    M
  }

  M = createLayoutMatrix()
  layout(M)
  restoreGraphicsParameters = saveGraphicsParameters("mar", "mgp")
  on.exit(restoreGraphicsParameters())

  par(mar = mar, mgp = c(2, 1, 0))

  if (1 %in% which) {
    plot(x, which = 1, ...)
  }

  if (2 %in% which) {
    plot(x, which = 2, ...)
    hist(resid(x), xlab = "Residuals", main = "Histogram of residuals")
  }

  if (3 %in% which) {
    plot(x, which = 4, ...)
  }

  layout(1)
  invisible(x)
}

#' Build model checking diagnostics using ggplot2
#'
#' @param x fitted linear model.
#' @param which selected diagnostic plots.
#' @return A ggplot object or a named list of ggplot objects.
#' @noRd
modelcheck_ggplot2 = function(x, which) {
  requirePlottingPackage("ggplot2")

  plots = list()

  if (1 %in% which) {
    plots$residuals = modelcheck_ggplot2_Residuals(x)
  }

  if (2 %in% which) {
    normalityPlots = normcheck(x, engine = "ggplot2")
    plots$qq = normalityPlots$qq
    plots$histogram = normalityPlots$histogram
  }

  if (3 %in% which) {
    plots$cooks = modelcheck_ggplot2_Cooks(x)
  }

  if (length(plots) == 1) {
    return(plots[[1]])
  }

  class(plots) = c("s20xModelcheck_ggplot2", class(plots))
  plots
}

#' Build a ggplot2 residual-versus-fitted plot for modelcheck
#'
#' @param x fitted linear model.
#' @return A ggplot object.
#' @noRd
modelcheck_ggplot2_Residuals = function(x) {
  diagnosticData = getModelResidualFittedData(x, context = "linear model")
  plotData = data.frame(
    fitted = as.numeric(diagnosticData[["fitted"]]),
    residuals = as.numeric(diagnosticData[["residuals"]])
  )

  ggplot(
    plotData,
    aes(
      x = .data$fitted,
      y = .data$residuals
    )
  ) +
    geom_point(shape = 1) +
    geom_hline(
      yintercept = 0,
      linetype = 3,
      colour = "lightgrey",
      linewidth = 0.4
    ) +
    geom_smooth(
      method = "loess",
      formula = y ~ x,
      se = FALSE,
      colour = "red",
      linewidth = 0.4
    ) +
    labs(x = "Fitted values", y = "Residuals", title = "Residuals vs Fitted") +
    s20x_ggplot2_base_theme()
}

#' Build a ggplot2 Cook's distance plot for modelcheck
#'
#' @param x fitted linear model.
#' @return A ggplot object.
#' @noRd
modelcheck_ggplot2_Cooks = function(x) {
  cooksDistance = as.numeric(cooks.distance(x))
  cooksData = data.frame(
    observation = seq_along(cooksDistance),
    cooksDistance = cooksDistance
  )

  labelCount = min(3L, length(cooksDistance))
  labelObservations = order(cooksDistance, decreasing = TRUE)[seq_len(labelCount)]
  labelData = cooksData[labelObservations, , drop = FALSE]
  labelData$label = as.character(labelData$observation)

  ggplot(
    cooksData,
    aes(
      x = .data$observation,
      y = .data$cooksDistance
    )
  ) +
    geom_segment(
      aes(
        xend = .data$observation,
        yend = 0
      ),
      linewidth = 0.4
    ) +
    geom_hline(
      yintercept = 0,
      linetype = 3,
      colour = "lightgrey",
      linewidth = 0.4
    ) +
    geom_text(
      data = labelData,
      mapping = aes(label = .data$label),
      vjust = -0.3,
      size = 3
    ) +
    labs(
      x = "Obs. number",
      y = "Cook's distance",
      title = "Cook's distance"
    ) +
    s20x_ggplot2_base_theme()
}



#' Compute ggplot2 modelcheck print layout positions
#'
#' @param plotNames names of selected modelcheck plots.
#' @return A list containing row count and viewport positions.
#' @noRd
modelcheck_ggplot2_layout_positions = function(plotNames) {
  rowNumber = 1L
  positions = list()

  if ("residuals" %in% plotNames) {
    positions$residuals = list(row = rowNumber, col = 1:2)
    rowNumber = rowNumber + 1L
  }

  if (all(c("qq", "histogram") %in% plotNames)) {
    positions$qq = list(row = rowNumber, col = 1L)
    positions$histogram = list(row = rowNumber, col = 2L)
    rowNumber = rowNumber + 1L
  } else {
    if ("qq" %in% plotNames) {
      positions$qq = list(row = rowNumber, col = 1:2)
      rowNumber = rowNumber + 1L
    }

    if ("histogram" %in% plotNames) {
      positions$histogram = list(row = rowNumber, col = 1:2)
      rowNumber = rowNumber + 1L
    }
  }

  if ("cooks" %in% plotNames) {
    positions$cooks = list(row = rowNumber, col = 1:2)
    rowNumber = rowNumber + 1L
  }

  list(
    nRows = rowNumber - 1L,
    positions = positions[plotNames]
  )
}

#' Print ggplot2 modelcheck plots
#'
#' Draws multiple ggplot2 modelcheck plots together so the optional ggplot2
#' engine gives a single printed diagnostic display rather than showing list
#' structure at the console.
#'
#' @param x an object returned by \code{modelcheck(..., engine = "ggplot2")}
#'   when multiple plots are selected.
#' @param \dots additional arguments passed to \code{print.ggplot}.
#' @return Invisibly returns \code{x}.
#' @export
#' @importFrom grid grid.newpage grid.layout pushViewport popViewport viewport
print.s20xModelcheck_ggplot2 = function(x, ...) {
  nPlots = length(x)

  if (nPlots == 0) {
    return(invisible(x))
  }

  layoutPositions = modelcheck_ggplot2_layout_positions(names(x))

  grid.newpage()
  pushViewport(viewport(layout = grid.layout(layoutPositions$nRows, 2)))
  on.exit(popViewport())

  for (plotName in names(x)) {
    plotPosition = layoutPositions$positions[[plotName]]
    print(
      x[[plotName]],
      vp = viewport(
        layout.pos.row = plotPosition$row,
        layout.pos.col = plotPosition$col
      ),
      ...
    )
  }

  invisible(x)
}
