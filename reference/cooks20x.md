# Cook's distance plot

Draws a Cook's distance plot.

## Usage

``` r
cooks20x(
  x,
  main = "Cook's Distance plot",
  xlab = "observation number",
  ylab = "Cook's distance",
  line = c(0.5, 1.2, 2),
  cex.labels = 1,
  axisOpts = list(xAxis = TRUE, yAxisTight = FALSE),
  ...
)
```

## Arguments

- x:

  an object of class `lm`, usually obtained by using the
  [`lm`](https://rdrr.io/r/stats/lm.html) function.

- main:

  the plot title

- xlab:

  the x-axis title.

- ylab:

  the y-axis title.

- line:

  a vector of length 3 controlling the distances of the plot title, the
  x-axis title and the y-axis title from the axis in line units.

- cex.labels:

  a factor controlling the font size of the labels on suspected high
  influence points.

- axisOpts:

  a list of additional arguments that can be used to control the axes.
  At this point this list only contains one element `xAxis` which is
  logical. If `xAxis == TRUE` then the x-axis will be displayed, and
  clearly, if it is `FALSE`, then it will not.

- ...:

  additional arguments are passed to `plot` and may provide some extra
  flexibility.

## Value

Returns the plot and identifies the three highest Cook's values

## Examples

``` r

# Peruvian Indians data
data(peru.df)
peru.fit = lm(BP ~ age + years + I(years^2) + weight + height, data = peru.df)
cooks20x(peru.fit)

```
