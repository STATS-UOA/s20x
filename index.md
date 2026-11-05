# s20x

s20x supports data analysis teaching at the University of Auckland, in
STATS 201, STATS 208 and BIOSCI 209. It provides model-checking plots,
teaching summaries, predictions with intervals, datasets and worked case
studies.

The [package website](https://stats-uoa.github.io/s20x/) has the
function reference and all the case studies.

## Installation

``` r

# From CRAN
install.packages("s20x")

# Development version
remotes::install_github("STATS-UOA/s20x")
```

## A quick example

``` r

library(s20x)

peruFit = lm(BP ~ weight + age, data = peru.df)

# Check the model
modelcheck(peruFit)

# Predict, with confidence and prediction intervals
predict20x(peruFit, data.frame(weight = 70, age = 30))
```

## What is in the package

| Task | Functions |
|----|----|
| Explore the data | [`pairs20x()`](https://stats-uoa.github.io/s20x/reference/pairs20x.md), [`trendscatter()`](https://stats-uoa.github.io/s20x/reference/trendscatter.md), [`interactionPlots()`](https://stats-uoa.github.io/s20x/reference/interactionPlots.md), [`summaryStats()`](https://stats-uoa.github.io/s20x/reference/summaryStats.md) |
| Check a model | [`modelcheck()`](https://stats-uoa.github.io/s20x/reference/modelcheck.md), [`normcheck()`](https://stats-uoa.github.io/s20x/reference/normcheck.md), [`eovcheck()`](https://stats-uoa.github.io/s20x/reference/eovcheck.md), [`cooks20x()`](https://stats-uoa.github.io/s20x/reference/cooks20x.md) |
| Summarise an analysis | [`summary1way()`](https://stats-uoa.github.io/s20x/reference/summary1way.md), [`summary2way()`](https://stats-uoa.github.io/s20x/reference/summary2way.md), [`multipleComp()`](https://stats-uoa.github.io/s20x/reference/multipleComp.md), [`displayPairs()`](https://stats-uoa.github.io/s20x/reference/displayPairs.md), [`rowdistr()`](https://stats-uoa.github.io/s20x/reference/rowdistr.md) |
| Predict | [`predict20x()`](https://stats-uoa.github.io/s20x/reference/predict20x.md) for `lm`, `glm` and `tslm` fits |
| Time series | [`tslm()`](https://stats-uoa.github.io/s20x/reference/tslm.md) for linear models with AR(p) errors |
| Case studies | [`listCaseStudies()`](https://stats-uoa.github.io/s20x/reference/listCaseStudies.md), [`casestudy()`](https://stats-uoa.github.io/s20x/reference/casestudy.md), [`openCaseStudy()`](https://stats-uoa.github.io/s20x/reference/openCaseStudy.md) |

## Plotting engines

The diagnostic functions draw the familiar base graphics teaching plots
by default. They can also return reusable plot objects: functions such
as
[`normcheck()`](https://stats-uoa.github.io/s20x/reference/normcheck.md),
[`eovcheck()`](https://stats-uoa.github.io/s20x/reference/eovcheck.md),
[`modelcheck()`](https://stats-uoa.github.io/s20x/reference/modelcheck.md),
and
[`pairs20x()`](https://stats-uoa.github.io/s20x/reference/pairs20x.md)
continue to draw the familiar base graphics plots unless another engine
is requested.

Where supported, use `engine = "ggplot2"` to request the ggplot2
plotting engine. It is intended for workflows where a plot object is
useful for saving, arranging, or further customisation.

Use the plotting engines this way:

| Task | Recommended call | Notes |
|----|----|----|
| Teaching, labs, and lecture notes | `normcheck(fit)` or `modelcheck(fit)` | Uses the original base graphics output. |
| Save or arrange a normality diagnostic | `normcheck(fit, engine = "ggplot2")` | Returns reusable Q-Q and histogram plot objects. |
| Save or arrange an equality-of-variance diagnostic | `eovcheck(fit, engine = "ggplot2")` | Returns a reusable residual-versus-fitted plot object. |
| Save or arrange model-checking diagnostics | `modelcheck(fit, engine = "ggplot2")` | Returns a reusable named list for multiple diagnostics, or a single plot object when `which` selects one diagnostic. |
| Save or arrange a pairs plot | `pairs20x(data, engine = "ggplot2")` | Returns a reusable plot matrix. |

Examples:

``` r

peruFit = lm(BP ~ Age + Weight + Years, data = peru.df)
normcheck(peruFit)

normPlots = normcheck(peruFit, engine = "ggplot2")
normPlots
```

``` r

pairsPlot = pairs20x(peru.df, engine = "ggplot2")
pairsPlot
```

The base engine draws directly on the active graphics device and usually
returns no reusable object. The ggplot2 engine is for users who need to
keep, print, save, or combine the result later. When a helper creates
more than one ggplot2 diagnostic, the return value is a named list so
individual plots can be selected by name, for example
`diagnosticPlots$residuals` or `normPlots$qq`. This distinction is
intentional so existing course material keeps the familiar plots while
newer workflows can opt into object-based graphics.

## Changes

See `NEWS.md` for the release history.
