# Crosstabulation of two variables

Produces a 2-way table of counts and the corresponding chi-square test
of independence or homogeneity.

## Usage

``` r
crosstabs(formula, data)
```

## Arguments

- formula:

  a symbolic description of the model to be fit: ~ fac1 + fac2; where
  fac1 and fac2 are vectors to be crosstabulated and treated internally
  as factors.

- data:

  an optional data frame containing the variables in the model.

## Value

Invisibly returns an object of class `ct.20x`, which is a list
containing the following components:

- row.props:

  a matrix of row proportions, i.e. cell counts divided by row
  marginals.

- col.props:

  a matrix of column proportions, i.e. cell counts divided by column
  marginals.

- whole.props:

  a matrix of whole-table proportions.

- Totals:

  a matrix containing the cell counts and the marginal totals.

- exp:

  a matrix of expected counts from the chi-square calculation.

- chi:

  a matrix of cell contributions to the chi-square statistic.

## Note

This is a legacy teaching helper retained for compatibility with older
course material. New code should usually prefer
[`table()`](https://rdrr.io/r/base/table.html) and
[`chisq.test()`](https://rdrr.io/r/stats/chisq.test.html) directly, or a
purpose-built teaching wrapper.

Deprecated in s20x 3.3.6. Use
[`table()`](https://rdrr.io/r/base/table.html) and
[`chisq.test()`](https://rdrr.io/r/stats/chisq.test.html) instead.

## Examples

``` r

##body image data:
data(body.df)
crosstabs(~ ethnicity + married, body.df)
#> Warning: crosstabs() is deprecated; use table() and chisq.test() instead. rowdistr() accepts a two-way table.
#>          married
#> ethnicity   1  2  3  4 Total
#>   Asian    40  1  2  7    50
#>   Europn   62 10  6 22   100
#>   Maori    47  3  4 11    65
#>   Pacific  20  0  3  8    31
#>   Total   169 14 15 48   246
#> Chisq = 11.1035  df = 9   p-value = 0.26868 
#> Warning: Chi-square approximation may be incorrect
```
