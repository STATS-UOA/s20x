# Confidence Intervals for Regression models

Calculates and prints the confidence intervals for the fitted model.

## Usage

``` r
ciReg(fit, conf.level = 0.95, print.out = TRUE)
```

## Arguments

- fit:

  an object of class `lm`, i.e. the output from
  [`lm`](https://rdrr.io/r/stats/lm.html).

- conf.level:

  confidence level of the intervals.

- print.out:

  if `TRUE`, print out the output on the screen.

## Value

The function returns a two-column matrix containing the upper and lower
endpoints of the intervals.

## Note

Deprecated in s20x 3.4.0. Use
[`confint()`](https://rdrr.io/r/stats/confint.html) instead.

## See also

[`lm`](https://rdrr.io/r/stats/lm.html),
[`summary`](https://rdrr.io/r/base/summary.html),
[`anova`](https://rdrr.io/r/stats/anova.html).

## Examples

``` r

##Peruvian Indians data
data(peru.df)
fit = lm(BP ~ age + years + weight + height, data = peru.df)
ciReg(fit)
#> Warning: ciReg() is deprecated; use confint() instead.
#>             95 % C.I.lower    95 % C.I.upper
#> (Intercept)      -16.46474         196.81961
#> age               -0.72930           0.40664
#> years             -0.98412          -0.09194
#> weight             0.85391           2.14339
#> height            -0.10227           0.04705
```
