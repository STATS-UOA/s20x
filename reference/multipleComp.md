# Multiple Comparisons

Calculates and prints the estimate, multiple 95% confidence intervals,
unadjusted, Tukey and Bonferroni p-values for all possible differences
in means in a one-way ANOVA.

## Usage

``` r
multipleComp(fit, conf.level = 0.95, FUN = identity)
```

## Arguments

- fit:

  Output from the command \[lm()\].

- conf.level:

  Confidence level for the confidence interval, expressed as a
  percentage.

- FUN:

  Optional function to be applied to estimates and confidence intervals.
  Typically used for back-transformation operations.

## Value

Returns a list of estimates, confidence intervals and p-values.

## Examples

``` r
## computer data
data(computer.df)
fit = lm(score ~ factor(selfassess), data = computer.df)
multipleComp(fit)
#>          Estimate  Tukey.L  Tukey.U Tukey.p
#> 1  -  2 -26.35714 -45.1889  -7.5254  0.0063
#> 1  -  3 -52.25000 -74.5320 -29.9680  0.0000
#> 2  -  3 -25.89286 -48.6992  -3.0865  0.0252

## butterfat data
data("butterfat.df")
fit = lm(log(Butterfat) ~ Breed, data = butterfat.df)
multipleComp(fit, FUN = exp)
#>                          Estimate   Tukey.L   Tukey.U Tukey.p
#> ayrshire  -  canadian   0.9133948 0.8454384 0.9867881  0.0132
#> ayrshire  -  guernesy   0.8223070 0.7610928 0.8884295  0.0000
#> ayrshire  -  holst.fres 1.1067086 1.0243928 1.1956620  0.0039
#> ayrshire  -  jersey     0.7701896 0.7129101 0.8321022  0.0000
#> canadian  -  guernesy   0.9002755 0.8332680 0.9726801  0.0025
#> canadian  -  holst.fres 1.2116432 1.1215369 1.3090478  0.0000
#> canadian  -  jersey     0.8432165 0.7805160 0.9110113  0.0000
#> guernesy  -  holst.fres 1.3458582 1.2457030 1.4539733  0.0000
#> guernesy  -  jersey     0.9366205 0.8669274 1.0118699  0.1370
#> holst.fres  -  jersey   0.6959280 0.6441652 0.7518639  0.0000
```
