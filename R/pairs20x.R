#' Pairwise Scatter Plots with Histograms and Correlations
#'
#' Plots pairwise scatter plots with histograms and correlations for the data
#' frame.
#'
#' The default base graphics engine preserves the original s20x teaching plot and
#' draws directly on the active graphics device. The optional ggplot2 engine uses
#' GGally when both optional packages are installed and returns a reusable plot
#' matrix for reports or further customisation. The ggplot2/GGally output is
#' intentionally optional so existing teaching material can continue to rely on
#' the base graphics default.
#'
#' @param x a data frame.
#' @param na.rm if TRUE then only complete cases will be displayed.
#' @param engine plotting engine to use. The default, \code{"base"}, preserves
#'   the original base graphics output. Use \code{"ggplot2"} for the optional
#'   ggplot2/GGally output.
#' @param \dots optional arguments passed to the underlying plotting function.
#' @return Returns the plot.
#' @seealso \code{'pairs', 'panel.smooth', 'panel.cor', 'panel.hist'}
#' @keywords hplot
#' @examples
#'
#' ## Peruvian Indians
#' data(peru.df)
#' pairs20x(peru.df)
#'
#' # Optional ggplot2/GGally engine for a reusable plot matrix
#' if (requireNamespace("ggplot2", quietly = TRUE) &&
#'     requireNamespace("GGally", quietly = TRUE)) {
#'   pairsPlot = pairs20x(peru.df, engine = "ggplot2")
#'   class(pairsPlot)
#' }
#'
#' @export pairs20x
pairs20x = function(x, na.rm = TRUE, engine = c("base", "ggplot2"), ...) {
    engine = matchPlottingEngine(engine)

    if (na.rm) {
        x = x[complete.cases(x), ]
    }

    if (engine == "ggplot2") {
        return(pairs20x_ggplot2(x, ...))
    }

    pairs20xBase(x, ...)
}

#' Draw the original base graphics pairs20x plot
#'
#' @param x a data frame.
#' @param \dots optional arguments passed to \code{pairs()}.
#' @return Returns the base graphics plot.
#' @noRd
pairs20xBase = function(x, ...) {
    panel.hist = function(x, ...) {
        usr = par("usr")
        on.exit(par(usr = usr))

        par(usr = c(usr[1:2], 0, 1.5))
        h = hist(x, plot = FALSE)
        breaks = h$breaks
        nB = length(breaks)
        y = h$counts
        y = y / max(y)
        rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
    }

    panel.cor = function(x, y, digits = 2, prefix = "", cex.cor) {
        usr = par("usr")
        on.exit(par(usr = usr))
        par(usr = c(0, 1, 0, 1))
        r = abs(cor(x, y))
        txt = format(c(r, 0.123456789), digits = digits)[1]
        txt = paste(prefix, txt, sep = "")
        if (missing(cex.cor)) {
            cex.cor = 0.8 / strwidth(txt)
        }
        text(0.5, 0.5, txt, cex = cex.cor * r)
    }

    pairs(x, upper.panel = panel.smooth, lower.panel = panel.cor,
        diag.panel = panel.hist, ...)
}

#' Draw the optional ggplot2/GGally pairs20x plot
#'
#' @param x a data frame.
#' @param \dots optional arguments passed to \code{ggpairs()}.
#' @return Returns a GGally plot matrix.
#' @noRd
pairs20x_ggplot2 = function(x, ...) {
    requirePlottingPackage("ggplot2")
    requirePlottingPackage("GGally")

    plotMatrix = ggpairs(
        x,
        upper = list(continuous = pairs20x_ggplot2SmoothPanel),
        lower = list(continuous = pairs20x_ggplot2CorrelationPanel),
        diag = list(continuous = pairs20x_ggplot2HistogramPanel),
        columnLabels = NULL,
        axisLabels = "none",
        progress = FALSE,
        ...
    )

    plotMatrix$axisLabels = "none"

    plotMatrix + pairs20x_ggplot2MatrixTheme()
}

#' Build a ggplot2 scatterplot smoother panel for pairs20x
#'
#' @param data panel data supplied by GGally.
#' @param mapping panel mapping supplied by GGally.
#' @param \dots unused panel arguments.
#' @return A ggplot object.
#' @noRd
pairs20x_ggplot2SmoothPanel = function(data, mapping, ...) {
    ggplot(data = data, mapping = mapping) +
        geom_point(shape = 5, size = 1, stroke = 0.35) +
        geom_smooth(method = "loess", formula = y ~ x, se = FALSE,
            colour = "red", linewidth = 0.25) +
        pairs20x_ggplot2BaseTheme()
}

#' Build a ggplot2 histogram panel for pairs20x
#'
#' @param data panel data supplied by GGally.
#' @param mapping panel mapping supplied by GGally.
#' @param \dots unused panel arguments.
#' @return A ggplot object.
#' @noRd
pairs20x_ggplot2HistogramPanel = function(data, mapping, ...) {
    xValues = eval_data_col(data, mapping$x)
    xLabel = pairs20x_ggplot2MappingLabel(mapping, "x")
    histBreaks = hist(xValues, plot = FALSE)$breaks
    histCounts = hist(xValues, breaks = histBreaks, plot = FALSE)$counts
    histMaximum = max(histCounts)
    labelData = data.frame(
        x = mean(range(xValues, finite = TRUE)),
        y = 1.3 * histMaximum,
        label = xLabel
    )

    ggplot(data = data, mapping = mapping) +
        geom_histogram(breaks = histBreaks, fill = "cyan", colour = "black") +
        geom_text(
            data = labelData,
            mapping = aes(x = .data$x, y = .data$y, label = .data$label),
            inherit.aes = FALSE,
            size = 5
        ) +
        coord_cartesian(ylim = c(0, 1.5 * histMaximum), expand = FALSE) +
        pairs20x_ggplot2BaseTheme()
}

#' Build a ggplot2 correlation panel for pairs20x
#'
#' @param data panel data supplied by GGally.
#' @param mapping panel mapping supplied by GGally.
#' @param digits number of correlation digits to display.
#' @param prefix optional text prefix.
#' @param \dots unused panel arguments.
#' @return A ggplot object.
#' @noRd
pairs20x_ggplot2CorrelationPanel = function(data, mapping, digits = 2,
                                           prefix = "", ...) {
    xValues = eval_data_col(data, mapping$x)
    yValues = eval_data_col(data, mapping$y)
    r = abs(cor(xValues, yValues))
    txt = format(c(r, 0.123456789), digits = digits)[1]
    txt = paste(prefix, txt, sep = "")
    labelData = data.frame(
        x = mean(range(xValues, finite = TRUE)),
        y = mean(range(yValues, finite = TRUE)),
        label = txt,
        size = max(0.1, 10 * r)
    )

    ggplot(data = data, mapping = mapping) +
        geom_blank() +
        geom_text(
            data = labelData,
            mapping = aes(
                x = .data$x,
                y = .data$y,
                label = .data$label,
                size = .data$size
            ),
            inherit.aes = FALSE
        ) +
        scale_size_identity() +
        pairs20x_ggplot2BaseTheme()
}

#' Extract a readable variable name from a GGally panel mapping
#'
#' @param mapping panel mapping supplied by GGally.
#' @param component mapping component to read.
#' @return A character label.
#' @noRd
pairs20x_ggplot2MappingLabel = function(mapping, component) {
    mappingExpr = get_expr(mapping[[component]])
    mappingLabel = as.character(mappingExpr)
    mappingLabel[length(mappingLabel)]
}

#' Build a base-like ggplot2 theme for pairs20x panels
#'
#' @return A ggplot2 theme object.
#' @noRd
pairs20x_ggplot2BaseTheme = function() {
    theme(
        panel.background = element_rect(fill = "white", colour = NA),
        plot.background = element_rect(fill = "white", colour = NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(fill = NA, colour = "black", linewidth = 0.35),
        axis.title = element_blank(),
        axis.text = element_text(colour = "black", size = 8),
        axis.ticks = element_line(colour = "black", linewidth = 0.35),
        strip.background = element_blank(),
        strip.text = element_blank(),
        plot.margin = margin(1, 1, 1, 1, unit = "pt")
    )
}

#' Build a base-like GGally matrix theme for pairs20x
#'
#' @return A ggplot2 theme object.
#' @noRd
pairs20x_ggplot2MatrixTheme = function() {
    theme(
        panel.spacing = unit(0, "pt"),
        strip.background = element_blank(),
        strip.text = element_blank(),
        axis.title = element_blank()
    )
}
