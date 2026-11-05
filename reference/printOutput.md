# Print row-distribution summaries

Prints the teaching summaries used by \`rowdistr()\` for the selected
comparison mode.

## Usage

``` r
printOutput(
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

  confidence level used for interval summaries.

## Value

Invisibly returns the row-proportion matrix printed in the summary.
