# ANOVA tables for time series linear models

Produces analysis-of-variance-style tables for \`tslm\` objects.

## Usage

``` r
# S3 method for class 'tslm'
anova(object, ..., verbose = FALSE)
```

## Arguments

- object:

  a fitted \`tslm\` object.

- ...:

  optional additional fitted model objects for model comparisons.

- verbose:

  logical. For AR-error models, use \`TRUE\` to return the raw
  underlying \[nlme::anova.gls()\] output.

## Value

An analysis-of-variance-style table.

## Details

For ordinary \`tslm()\` fits without autoregressive error terms,
\`anova()\` returns the usual analysis of variance table from
\[stats::anova.lm()\].

For AR-error models fitted through \[nlme::gls()\], the reported tests
are Wald-style tests of model terms. These test whether each term
contributes to the fitted mean model after allowing for the estimated
autocorrelation structure. Because these models do not use the ordinary
independent-error sum-of-squares decomposition, the compact table
reports \`Df\`, \`F value\`, and \`Pr(\>F)\`, but does not report \`Sum
Sq\` or \`Mean Sq\`. Compare nested AR-error models with care: \`verbose
= TRUE\` exposes the underlying \`nlme\` comparison output rather than
recreating an ordinary \`lm\` ANOVA table.

Use \`verbose = TRUE\` to see the underlying \[nlme::anova.gls()\]
output.

## Examples

``` r
data(beer.df)
fit = tslm(beer ~ t + ar(1), data = beer.df, time = t)
anova(fit)
#> Analysis of Variance Table
#> Response: beer
#> Tests of model terms allowing for AR errors
#> 
#>   Df F value Pr(>F)
#> t  1    5.84 0.0176
```
