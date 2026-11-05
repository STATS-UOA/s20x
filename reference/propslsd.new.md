# LSD-Display Intervals

This function is called by
[`rowdistr`](https://stats-uoa.github.io/s20x/reference/rowdistr.md).

## Usage

``` r
propslsd.new(crosstablist, conf.level = 0.95, arrowlength = 0.1)
```

## Arguments

- crosstablist:

  A list produced by
  [`crosstabs`](https://stats-uoa.github.io/s20x/reference/crosstabs.md)
  or a matrix containing a 2-way table of counts (without marginal
  totals).

- conf.level:

  Confidence level of the intervals.

- arrowlength:

  Length of the arrows.

## Note

This is an internal legacy helper used by
[`rowdistr()`](https://stats-uoa.github.io/s20x/reference/rowdistr.md).
It is not exported and should not be called directly by users.

## See also

[`crosstabs`](https://stats-uoa.github.io/s20x/reference/crosstabs.md),
[`rowdistr`](https://stats-uoa.github.io/s20x/reference/rowdistr.md)
