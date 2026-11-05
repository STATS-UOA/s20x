# Two-way Analysis of Variance Summary

Displays summary information for a two-way anova analysis. The lm object
must come from a numerical response variable and factors. The output
depends on the value of `page`:

## Usage

``` r
summary2way(
  fit,
  page = c("table", "means", "effects", "interaction", "nointeraction"),
  digits = 5,
  conf.level = 0.95,
  print.out = TRUE,
  new = TRUE,
  all = FALSE,
  FUN = "identity",
  ...
)
```

## Arguments

- fit:

  an lm object, i.e. the output from
  [`lm()`](https://rdrr.io/r/stats/lm.html).

- page:

  options for output: `"table"`, `"means"`, `"effects"`,
  `"interaction"`, or `"nointeraction"`.

- digits:

  the number of decimal places in the display.

- conf.level:

  confidence level of the intervals.

- print.out:

  if `TRUE`, print the output on the screen.

- new:

  if `TRUE` then this will run the new version of `summary2way` which
  should be more robust than the old version. However, it does not work
  in the same way. In particular, when `page = 'means'` it does not
  return summary statistics for each grouping of the data (pooled, by
  row factor, by column factor, and by interaction factor). Instead, it
  simply returns the means for each grouping.

- all:

  Only applicable to `page = "interaction"`. If `TRUE`, pairwise
  comparisons for all combinations of factor levels are shown.
  Otherwise, comparisons are only shown between combinations that have
  the same level for one of the factors.

- FUN:

  optional function to be applied to estimates and confidence intervals.
  Typically for backtransformation operations.

- ...:

  other arguments such as `inttype` and `pooled`.

## Value

\`summary2way()\` prints the requested teaching summary page and
invisibly returns the current summary components. The returned list has
the following components:

- Df:

  degrees of freedom for regression, residual and total.

- Sum of Sq:

  sum squares for regression, residual and total.

- Mean Sq:

  mean squares for regression and residual.

- F value:

  F-statistic value.

- Pr(F):

  The P-value associated with each F-test.

- Grand Mean:

  The overall mean of the response variable.

- Row Effects:

  The main effects for the first (row) factor.

- Col Effects:

  The main effects for the second (column) factor.

- Interaction Effects:

  The interaction effects if an interaction model has been fitted,
  otherwise `NULL`.

- results:

  If `new = TRUE`, then this is a list with five components: `table` -
  the ANOVA table, `means` the table of means from `model.tables`,
  `effects` - the table of effects from `model.tables`, and
  `comparisons` - the differences in the means with standard errors,
  confidence bounds, and P-values from `TukeyHSD`

.

## Details

- `page = "table"`: ANOVA table.

- `page = "means"`: cell means matrix and numeric summary.

- `page = "effects"`: table of effects.

- `page = "interaction"`: interaction contrast tables.

- `page = "nointeraction"`: main-effect contrast tables.

## See also

[`summary1way`](https://stats-uoa.github.io/s20x/reference/summary1way.md),
[`model.tables`](https://rdrr.io/r/stats/model.tables.html),
[`TukeyHSD`](https://rdrr.io/r/stats/TukeyHSD.html)

## Examples

``` r

## Arousal data:
data(arousal.df)
arousal.fit = lm(arousal ~ gender * picture, data = arousal.df)
summary2way(arousal.fit)
#> ANOVA Table:
#>                 Df Sum Squares Mean Square F-statistic    p-value
#> gender           1       172.0      172.02      188.69 1.9823e-28
#> picture          3       197.6       65.87       72.25 4.2616e-29
#> gender:picture   3      5731.3     1910.43     2095.60 0.0000e+00
#> Residuals      152       138.6        0.91                       

## Butterfat data:
data("butterfat.df")
fit = lm(log(Butterfat) ~ Breed + Age, data = butterfat.df)
summary2way(fit, page = "nointeraction", FUN = exp)
#> $Breed
#>                          diff       lwr       upr        p adj
#> canadian-ayrshire   1.0948168 1.0134408 1.1827271 1.306815e-02
#> guernesy-ayrshire   1.2160909 1.1257007 1.3137391 3.507400e-09
#> holst.fres-ayrshire 0.9035802 0.8364185 0.9761348 3.841631e-03
#> jersey-ayrshire     1.2983817 1.2018750 1.4026376 4.836335e-10
#> guernesy-canadian   1.1107711 1.0282092 1.1999624 2.472983e-03
#> holst.fres-canadian 0.8253255 0.7639803 0.8915965 6.092863e-09
#> jersey-canadian     1.1859351 1.0977863 1.2811618 1.936339e-07
#> holst.fres-guernesy 0.7430203 0.6877928 0.8026825 4.835826e-10
#> jersey-guernesy     1.0676683 0.9883102 1.1533986 1.362342e-01
#> jersey-holst.fres   1.4369302 1.3301254 1.5523110 4.835520e-10
#> 
#> $Age
#>                 diff       lwr      upr     p adj
#> mature-2yo 0.9807275 0.9471187 1.015529 0.2706475
#> 
```
