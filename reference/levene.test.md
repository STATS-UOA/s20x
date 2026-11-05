# Levene test for the ANOVA Assumption

Perform a Levene test for equal group variances in both one-way and
two-way ANOVA. A table with the results is (normally) displayed.

## Usage

``` r
levene.test(formula, data, digit = 5, show.table = TRUE)
```

## Arguments

- formula:

  a symbolic description of the model to be fitted: response ~ fac1 +
  fac2.

- data:

  an optional data frame containing the variables in the model.

- digit:

  the number of decimal places to display.

- show.table:

  If this argument is FALSE then the output will be suppressed

## Value

A list with the following elements:

- df:

  degrees of freedom.

- ss:

  sum squares.

- ms:

  mean squares.

- f.value:

  F-statistic value.

- p.value:

  P-value.

## Note

Deprecated in s20x 3.4.0. It will be removed in a later release.

## See also

[`crossFactors`](https://stats-uoa.github.io/s20x/reference/crossFactors.md),
[`anova`](https://rdrr.io/r/stats/anova.html).

## Examples

``` r

##
data(computer.df)
levene.test(score ~ factor(selfassess), computer.df)
#> Warning: levene.test() is deprecated and will be removed from s20x.
#>                 Df  Sum Squares  Mean Square  F-statistic  p-value   
#> Between Groups  2   54.55827     27.27914     0.24192      0.78794   
#> Within Groups   16  1804.17857   112.76116                           
#> Total           18  1858.73684                                       
```
