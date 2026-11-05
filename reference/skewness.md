# Skewness Statistic

Calculates the skewness statistic of the data in 'x'. Values close to
zero correspond to reasonably symmetric data, positive values of this
measure indicate right-skewed data whereas negative values indicate
left-skewness.

## Usage

``` r
skewness(x, ...)
```

## Arguments

- x:

  vector containing the data.

- ...:

  any other variables to be passed to `mean` and `sd`, e.g.
  `na.rm = TRUE`.

## Value

Returns the value of the skewness.

## Note

Deprecated in s20x 3.3.6.
[`summaryStats()`](https://stats-uoa.github.io/s20x/reference/summaryStats.md)
still reports skewness.

## Examples

``` r

## Merger data:
data(mergers.df)
skewness(mergers.df$mergerdays)
#> Warning: skewness() is deprecated; summaryStats() still reports skewness.
#> [1] 1.67523
```
