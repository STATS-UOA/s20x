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
| Save or arrange a diagnostic plot object | `normcheck(fit, engine = "ggplot2")` | Requires `ggplot2`; returns a plot object or a list of plot objects. |
| Save or arrange a pairs plot | `pairs20x(data, engine = "ggplot2")` | Requires both `ggplot2` and `GGally`. |

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

The base engine draws directly on the active graphics device and usually returns no reusable object. The ggplot2 engine is for users who need to keep, print, save, or combine the result later. This distinction is intentional so existing course material keeps the familiar plots while newer workflows can opt into object-based graphics.


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