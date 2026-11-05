# Display within-level pairwise comparisons for saturated two-way ANOVA model.

Displays within-level pairwise comparisons from a two-way ANOVA with
interactions. Note that this is just a display function: it ignores any
cross-level pairs included in `allpairs`, even though these will have
contributed to the computations for the Tukey adjustments. The purpose
is just to organise the output from `emmeans` into a more convenient
format.

## Usage

``` r
displayPairs(allpairs, levels1, levels2, brief = TRUE, asDF = FALSE)
```

## Arguments

- allpairs:

  pairwise output from a command like `pairs`. See details for a longer
  explanation.

- levels1:

  a character string specifying which within-level comparisons from
  `factor1` are wanted, and in which order.

- levels2:

  a character string specifying which within-level comparisons from
  `factor2` are wanted, and in which order.

- brief:

  either `TRUE` or `FALSE`. If `TRUE` then the information displayed
  will be more succinct.

- asDF:

  either `TRUE` or `FALSE` specifying whether to return a `data.frame`
  of results or just to display the output.

## Details

`allpairs` is a pairwise output from a command like
`pairs(emmeans(fit, ~factor1 * factor2))`. If `allpairs` is not already
a `data.frame` it will be converted to a `data.frame` within this
function. It must contain a column called `contrast` with text
descriptions like `'lev1 lev2 - lev3 lev4'` etc. `levels1` and `levels2`
are character strings specifying which within-level comparisons are
wanted, and in which order. They must match the order specified in
`emmeans`, so if using `emmeans(fit, ~factor1 * factor2)` then `levels1`
must belong to `factor1` and `levels2` must belong to `factor2`. All
this function does is to pick out the rows of `allpairs` with the
requested contrasts, so if there are no contrasts of the requested
format (e.g. because `levels1` and `levels2` have been switched) it will
output a blank list. If `brief = TRUE`, columns labelled `df`, `SE`, and
`t.ratio` or `z.ratio` will be removed for a more succinct display. If
`asDF = TRUE`, the output is returned as a data-frame suitable for
further manipulation, whereas if `asDF = FALSE` it is returned as a list
for display only.

## Author

Rachel Fewster

## Examples

``` r
## Fit a two-way ANOVA to the arousal data in arousal.df.
## The factors are gender (female, male) and picture shown to
## subject (infant, landscape, nude.f, nude.m):
data(arousal.df)
arousal.fit = lm(arousal ~ gender *  picture, data = arousal.df)

## Create all pairwise comparisons using emmeans, if available.
if (requireNamespace("emmeans", quietly = TRUE)) {
    emmeansFun = getExportedValue("emmeans", "emmeans")
    arousal.allpairs = pairs(
        emmeansFun(arousal.fit, ~ gender * picture),
        infer = TRUE
    )

    ## Display only the within-level comparisons:
    displayPairs(
        arousal.allpairs,
        levels1 = c("female", "male"),
        levels2 = c("infant", "landscape", "nude.f", "nude.m")
    )
}
#> Note: displayPairs is a s20x function that displays only the within-level
#> comparisons from allpairs. To see all comparisons, inspect the allpairs
#> output directly.
#> 
#> $female
#>                          contrast     est       lwr       upr      pval
#>  female infant - female landscape   7.490   6.56197   8.41803 0.0000000
#>     female infant - female nude.f  13.360  12.43197  14.28803 0.0000000
#>     female infant - female nude.m   0.385  -0.54303   1.31303 0.9066801
#>  female landscape - female nude.f   5.870   4.94197   6.79803 0.0000000
#>  female landscape - female nude.m  -7.105  -8.03303  -6.17697 0.0000000
#>     female nude.f - female nude.m -12.975 -13.90303 -12.04697 0.0000000
#> 
#> $male
#>                      contrast     est       lwr       upr         pval
#>  male infant - male landscape  -4.845  -5.77303  -3.91697 0.000000e+00
#>     male infant - male nude.f -16.870 -17.79803 -15.94197 0.000000e+00
#>     male infant - male nude.m  -1.635  -2.56303  -0.70697 6.430155e-06
#>  male landscape - male nude.f -12.025 -12.95303 -11.09697 0.000000e+00
#>  male landscape - male nude.m   3.210   2.28197   4.13803 2.631229e-14
#>     male nude.f - male nude.m  15.235  14.30697  16.16303 0.000000e+00
#> 
#> $infant
#>                     contrast   est      lwr      upr pval
#>  female infant - male infant 13.22 12.29197 14.14803    0
#> 
#> $landscape
#>                           contrast   est         lwr     upr       pval
#>  female landscape - male landscape 0.885 -0.04302995 1.81303 0.07352598
#> 
#> $nude.f
#>                     contrast    est       lwr       upr pval
#>  female nude.f - male nude.f -17.01 -17.93803 -16.08197    0
#> 
#> $nude.m
#>                     contrast  est      lwr      upr pval
#>  female nude.m - male nude.m 11.2 10.27197 12.12803    0
#> 
```
