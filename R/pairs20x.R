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
        return(pairs20xGgplot2(x, ...))
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
#' @param \dots optional arguments passed to \code{GGally::ggpairs()}.
#' @return Returns a GGally plot matrix.
#' @noRd
pairs20xGgplot2 = function(x, ...) {
    requirePlottingPackage("ggplot2")
    requirePlottingPackage("GGally")

    ggpairs = getExportedValue("GGally", "ggpairs")

    ggpairs(
        x,
        upper = list(continuous = pairs20xGgplot2SmoothPanel),
        lower = list(continuous = pairs20xGgplot2CorrelationPanel),
        diag = list(continuous = pairs20xGgplot2HistogramPanel),
        progress = FALSE,
        ...
    )
}

#' Build a ggplot2 scatterplot smoother panel for pairs20x
#'
#' @param data panel data supplied by GGally.
#' @param mapping panel mapping supplied by GGally.
#' @param \dots unused panel arguments.
#' @return A ggplot object.
#' @noRd
pairs20xGgplot2SmoothPanel = function(data, mapping, ...) {
    ggplot = getExportedValue("ggplot2", "ggplot")
    geomPoint = getExportedValue("ggplot2", "geom_point")
    geomSmooth = getExportedValue("ggplot2", "geom_smooth")

    ggplot(data = data, mapping = mapping) +
        geomPoint(shape = 1) +
        geomSmooth(method = "loess", formula = y ~ x, se = FALSE,
            colour = "red", linewidth = 0.4) +
        pairs20xGgplot2BaseTheme()
}

#' Build a ggplot2 histogram panel for pairs20x
#'
#' @param data panel data supplied by GGally.
#' @param mapping panel mapping supplied by GGally.
#' @param \dots unused panel arguments.
#' @return A ggplot object.
#' @noRd
pairs20xGgplot2HistogramPanel = function(data, mapping, ...) {
    ggplot = getExportedValue("ggplot2", "ggplot")
    geomHistogram = getExportedValue("ggplot2", "geom_histogram")

    ggplot(data = data, mapping = mapping) +
        geomHistogram(bins = 10, fill = "cyan", colour = "black") +
        pairs20xGgplot2BaseTheme()
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
pairs20xGgplot2CorrelationPanel = function(data, mapping, digits = 2,
                                           prefix = "", ...) {
    ggplot = getExportedValue("ggplot2", "ggplot")
    annotate = getExportedValue("ggplot2", "annotate")
    themeVoid = getExportedValue("ggplot2", "theme_void")
    evalDataCol = getExportedValue("GGally", "eval_data_col")

    xValues = evalDataCol(data, mapping$x)
    yValues = evalDataCol(data, mapping$y)
    r = abs(cor(xValues, yValues))
    txt = format(c(r, 0.123456789), digits = digits)[1]
    txt = paste(prefix, txt, sep = "")

    ggplot(data.frame(x = 0.5, y = 0.5)) +
        annotate("text", x = 0.5, y = 0.5, label = txt, size = 3 + 7 * r) +
        themeVoid()
}

#' Build a base-like ggplot2 theme for pairs20x panels
#'
#' @return A ggplot2 theme object.
#' @noRd
pairs20xGgplot2BaseTheme = function() {
    theme = getExportedValue("ggplot2", "theme")
    elementBlank = getExportedValue("ggplot2", "element_blank")
    elementRect = getExportedValue("ggplot2", "element_rect")

    theme(
        panel.background = elementRect(fill = "white", colour = NA),
        plot.background = elementRect(fill = "white", colour = NA),
        panel.grid.major = elementBlank(),
        panel.grid.minor = elementBlank(),
        strip.background = elementRect(fill = "white", colour = NA)
    )
}
