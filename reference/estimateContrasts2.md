# Estimate two-factor contrasts

Internal implementation for contrast estimation from balanced two-factor
linear models.

## Usage

``` r
estimateContrasts2(contrast.matrix, fit, alpha = 0.05, row = TRUE, L, FUN)
```

## Arguments

- contrast.matrix:

  contrast matrix.

- fit:

  fitted \`lm\` object.

- alpha:

  significance level.

- row:

  logical; if \`TRUE\`, estimate row contrasts, otherwise column
  contrasts.

- L:

  optional number of contrasts used for adjustment.

- FUN:

  formatting function applied to interval columns.

## Value

A matrix of contrast estimates and Tukey-adjusted p-values.
