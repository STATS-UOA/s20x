# Estimate one-factor contrasts

Internal implementation for contrast estimation from one-factor linear
models.

## Usage

``` r
estimateContrasts1(contrast.matrix, fit, alpha = 0.05, L, FUN)
```

## Arguments

- contrast.matrix:

  contrast matrix.

- fit:

  fitted \`lm\` object.

- alpha:

  significance level.

- L:

  optional number of contrasts used for adjustment.

- FUN:

  formatting function applied to interval columns.

## Value

A matrix of contrast estimates and Tukey-adjusted p-values.
