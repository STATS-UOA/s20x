# s20x

<!-- badges: start -->
[![R-CMD-check](https://github.com/STATS-UOA/s20x/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/STATS-UOA/s20x/actions/workflows/R-CMD-check.yaml)
[![CRAN status](https://www.r-pkg.org/badges/version/s20x)](https://CRAN.R-project.org/package=s20x)
<!-- badges: end -->

s20x supports data analysis teaching at the University of Auckland, in STATS 201, STATS 208 and BIOSCI 209. It provides model-checking plots, teaching summaries, predictions with intervals, datasets and worked case studies.

## Installation

```r
# From CRAN
install.packages("s20x")

# Development version
remotes::install_github("STATS-UOA/s20x")
```

## A quick example

```r
library(s20x)

peruFit = lm(BP ~ weight + age, data = peru.df)

# Check the model
modelcheck(peruFit)

# Predict, with confidence and prediction intervals
predict20x(peruFit, data.frame(weight = 70, age = 30))
```

## What is in the package

| Task | Functions |
| --- | --- |
| Explore the data | `pairs20x()`, `trendscatter()`, `interactionPlots()`, `summaryStats()` |
| Check a model | `modelcheck()`, `normcheck()`, `eovcheck()`, `cooks20x()` |
| Summarise an analysis | `summary1way()`, `summary2way()`, `multipleComp()`, `displayPairs()`, `rowdistr()` |
| Predict | `predict20x()` for `lm`, `glm` and `tslm` fits |
| Time series | `tslm()` for linear models with AR(p) errors |
| Case studies | `listCaseStudies()`, `casestudy()`, `openCaseStudy()` |

## Plotting engines

The diagnostic functions draw the familiar base graphics teaching plots by default. They can also return reusable plot objects: functions such as `normcheck()`, `eovcheck()`, `modelcheck()`, and `pairs20x()` continue to draw the familiar base graphics plots unless another engine is requested.

Where supported, use `engine = "ggplot2"` to request the modern plotting engine. The optional engine is intended for workflows where a plot object is useful for saving, arranging, or further customisation.

Use the plotting engines this way:

| Task | Recommended call | Notes |
| --- | --- | --- |
| Teaching, labs, and lecture notes | `normcheck(fit)` or `modelcheck(fit)` | Uses the original base graphics output. |
| Save or arrange a normality diagnostic | `normcheck(fit, engine = "ggplot2")` | Requires `ggplot2`; returns reusable Q-Q and histogram plot objects. |
| Save or arrange an equality-of-variance diagnostic | `eovcheck(fit, engine = "ggplot2")` | Requires `ggplot2`; returns a reusable residual-versus-fitted plot object. |
| Save or arrange model-checking diagnostics | `modelcheck(fit, engine = "ggplot2")` | Requires `ggplot2`; returns a reusable named list for multiple diagnostics, or a single plot object when `which` selects one diagnostic. |
| Save or arrange a pairs plot | `pairs20x(data, engine = "ggplot2")` | Requires both `ggplot2` and `GGally`; returns a reusable plot matrix. |

Examples:

```r
peruFit = lm(BP ~ Age + Weight + Years, data = peru.df)
normcheck(peruFit)

if (requireNamespace("ggplot2", quietly = TRUE)) {
  normPlots = normcheck(peruFit, engine = "ggplot2")
  normPlots
}
```

```r
if (requireNamespace("ggplot2", quietly = TRUE) &&
    requireNamespace("GGally", quietly = TRUE)) {
  pairsPlot = pairs20x(peru.df, engine = "ggplot2")
  pairsPlot
}
```

The base engine draws directly on the active graphics device and usually returns no reusable object. The ggplot2 engine is for users who need to keep, print, save, or combine the result later. When a helper creates more than one ggplot2 diagnostic, the return value is a named list so individual plots can be selected by name, for example `diagnosticPlots$residuals` or `normPlots$qq`. This distinction is intentional so existing course material keeps the familiar plots while newer workflows can opt into object-based graphics.


## Changes

See `NEWS.md` for the release history.
