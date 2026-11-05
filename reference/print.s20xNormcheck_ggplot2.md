# Print ggplot2 normcheck plots

Draws multiple ggplot2 normcheck plots side by side so the ggplot2
engine mirrors the base graphics layout for the default
`whichPlot = 1:2` case.

## Usage

``` r
# S3 method for class 's20xNormcheck_ggplot2'
print(x, ...)
```

## Arguments

- x:

  an object returned by `normcheck(..., engine = "ggplot2")` when
  multiple plots are selected.

- ...:

  additional arguments passed to `print.ggplot`.

## Value

Invisibly returns `x`.
