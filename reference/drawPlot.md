# Draw row-distribution comparison plots

Draws the plotting side effects used by \`rowdistr()\` for the selected
comparison mode.

## Usage

``` r
drawPlot(
  crosstablist,
  comp = c("basic", "within", "between"),
  conf.level = 0.95
)
```

## Arguments

- crosstablist:

  prepared row-distribution summaries.

- comp:

  comparison mode, one of \`"basic"\`, \`"within"\`, or \`"between"\`.

- conf.level:

  confidence level used for between-row intervals.

## Value

Called for its plotting side effects.
