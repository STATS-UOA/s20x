s20x
====

## 3.2.2
A small number of the datasets have been slightly altered, and their associated documentation accordingly. The changes 
consist of adding some useful extra variables to the three time series datasets `airpass.df`, `beer.df` and `larain.df`.
These variables are `t` which is just a time index to save the user creating it if they want to fit a lag response model,
and either `month` and `year` or both. These are factor variables giving the year the observation recorded, and if relevant
the month. These extra variables can be used for time series analysis or plots. 

In addition we have made an attempt to use SI units rather than imperial units where sensible. Some examples of where 
it is sensible: converting inches to millimetres, pounds to kilograms, and acre-feet/gallons to litres (or megalitres).
Some examples of where it is not sensible are carats (industry standard) and converting blood pressue to kiloPascals 
instead of millimetres of mecury (mm Hg), which again is the health profession standard. If these conversions have been made,
then they have been done as extra variables added to the dataset, rather than replacing the original measurements. The
logic for this is to preserve the datasets as is to avoid lecture notes mismatches - at least for the time being.

A repository for the University of Auckland s20x R library. This library is used in our large undergrad classes STATS 201, STATS 208 and BIOSCI 209


## Diagnostic plotting engines

Recent modernisation work has preserved the original base graphics teaching output while adding optional reusable plot objects for selected diagnostic helpers. The default behaviour remains unchanged: functions such as `normcheck()`, `eovcheck()`, `modelcheck()`, and `pairs20x()` continue to draw the familiar base graphics plots unless another engine is requested.

Where supported, use `engine = "ggplot2"` to request the modern plotting engine. The optional engine is intended for workflows where a plot object is useful for saving, arranging, or further customisation. It requires the optional plotting packages documented by each help page, while the base engine remains available without those optional packages.

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

The optional engines are deliberately guarded with `requireNamespace()` in examples. That keeps package checks and student installations working even when optional plotting packages are not installed.


# Build Notes

We will attempt to add information about the changes in each new release (whether it makes it to CRAN or not) here, from version 3.1-21 onwards

## 3.1-21

Ben Stevenson added some code to summary2way so the attribute information from `TukeyHSD` is preserved. That is so you see this

```
> summary2way(fit, page = "interaction")
  Tukey multiple comparisons of means
    95% family-wise confidence level

Fit: aov(formula = fit)

$`store:crust`
```

instead of this

```
> summary2way(fit, page = "interaction")
$`store:crust`
```

## 3.1-24

A new function called `modcheck` has been added. This allows all four standard 20x model checking plots -- residuals versus fitted values, a normal Q-Q plot, a histogram of residuals, and a Cook's distance plot -- to be drawn on the same plot at once. This function needed a much more flexible version of `normcheck`, and needed modifications to `eovcheck` and `cooks20x`. I have not put it on CRAN yet because of the chance that it will fail for our current students. We *really* need some unit testing in this package so that this process can be sped up.

## 3.3.1

This release fixes bugs found in a code review. Output for models that already worked is unchanged.

- `summary2way(fit, page = "nointeraction", FUN = exp)` now back-transforms the comparisons once. They were previously transformed twice, so results from a release before this one should be rechecked.
- `plot()` on a `tslm` fit now puts residuals in order of the `time` variable, so the ACF and residuals-over-time panels are correct when the data are not already in time order. `tslm()` now fits `ar(p)` models in `time` order, so for such data `residuals()` and `fitted()` also come back in time order. Coefficients do not change.
- `tslm()` now keeps `offset()` terms in the mean model. Using `offset()` together with `ar(p)` gives an error, because `nlme::gls()` does not support offsets.
- `eovcheck()` now uses the fitted `lm` object directly. It respects `subset`, works for `lm(y ~ x)` with no `data` argument and for stored formulas, and uses the weighted fit when `weights` were supplied.

## 3.3.2

- `eovcheck(..., levene = TRUE)` now plots residuals from the model you asked for. Additive two-factor models previously showed interaction-model residuals. The Levene P-value is unchanged.
- `onewayPlot()` on an `lm` object, and `summary1way()`, now use `conf.level`, `pooled` and the interval type. These settings were previously ignored, so plots drawn with non-default values should be redrawn. The default plot is unchanged.

## 3.3.3

- `rowdistr(z, comp = "within")` now prints the uniformity chi-square statistic and p-value, which were blank.
- `summary1way()` now works with transformed terms such as `lm(score ~ factor(selfassess))`.
- `summary2way(fit, page = "interaction")` now works when a factor level contains a hyphen. Its headings now read `Comparisons within gender` rather than `Comparisons within c("gender", "picture")`, so lecture notes showing the old headings will differ.
- `onewayPlot(y, g)` now works for vectors without supplying `ylabel` and `flabel`.

## 3.3.4

- `predict20x()`, `predictCount()` and `predictGLM()` now work with transformed terms such as `log(x)` and `factor(g)`. Supply the original variable in `newdata`. `predict20x()` and `predictCount()` match columns by name when they can, and otherwise take them in order as before.
- `pairs20x(df, pch = 19)` and `pairs20x(df, col = "red")` now work, and apply to the scatter plots only.
- `displayPairs()` keeps all comparisons when the two factors share a level name.
- `summaryStats()` accepts `na.action`, and `cooks20x()` accepts `axisOpts = list(xAxis = FALSE)`.
- `summary2way(print.out = FALSE)` no longer prints, and `eovcheck(col = )` now sets the smoother colour with base graphics.
- `normcheck()` on a vector labels the histogram from the call rather than with `x`, and accepts hex and palette-number colours.
- `tslm()` now finds variables local to a calling function when `data` or `time` is supplied.

## 3.3.5

- `summaryStats()` now applies `na.action` to a single group as well as to grouped data.
- Case studies 5.2 and 10.3 now open. They failed to render because of a damaged header.
- Case study 5.2 now reports the correct R-squared (43.1%, not 36.7%) and describes the dummy variable correctly.
- Case study 9.1 had the intervals for method 3 against methods 1 and 2 swapped. Method 3 is 9.7 to 24.3 marks lower than method 1, and 17.4 to 32 marks lower than method 2.
- Case study 10.1 no longer has a stray digit in the interval for the change after 42 weeks.

## 3.3.6

The following functions are deprecated. They still work, but they warn and will be removed in a later release, because the current course no longer uses them directly: `ciReg()`, `layout20x()`, `freq1way()`, `residPlot()`, `levene.test()`, `estimateContrasts()`, `crossFactors()`, `crosstabs()`, `onewayPlot()`, `twosampPlot()`, `autocorPlot()` and `skewness()`. The `levene` argument of `eovcheck()` is also deprecated.

`summary1way()` still draws its plot, and `summaryStats()` still reports skewness.

## 3.3.7

- `eovcheck()` no longer offers Levene's test. Passing `levene` gives a warning and is otherwise ignored.
- The `shapiro.wilk` argument of `normcheck()` is deprecated.
- The demo scripts have been removed.
