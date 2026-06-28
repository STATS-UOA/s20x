#' s20x: Functions for University of Auckland Course STATS 201/208 Data Analysis
#'
#' The s20x package provides teaching-oriented helper functions and datasets for
#' University of Auckland STATS 201 and STATS 208 data analysis courses. The
#' package keeps student-facing defaults stable so existing lecture notes, labs,
#' and examples continue to behave as expected.
#'
#' Selected diagnostic plotting helpers now support optional plotting engines.
#' The default base graphics engine preserves the original teaching output. Use
#' \code{engine = "ggplot2"} only when a reusable plot object is useful for
#' saving, arranging, or further customisation. The optional engine requires the
#' plotting packages documented on the relevant help pages: \pkg{ggplot2} for
#' \code{normcheck()}, \code{eovcheck()}, and \code{modelcheck()}, and both
#' \pkg{ggplot2} and \pkg{GGally} for \code{pairs20x()}.
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import stats
#' @import graphics
#' @importFrom utils packageDescription vignette
#' @importFrom utils read.table
#' @importFrom methods is
#' @importFrom ggplot2 aes annotate coord_cartesian element_blank element_line element_rect element_text geom_abline geom_blank geom_hline geom_histogram geom_line geom_point geom_rect geom_segment geom_smooth geom_text ggplot labs margin scale_size_identity theme theme_void
#' @importFrom GGally eval_data_col ggpairs
#' @importFrom grid unit
#' @importFrom rlang .data get_expr
## usethis namespace: end
NULL
