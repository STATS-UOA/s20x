# Contrast Estimates

Calculates and prints Tukey multiple confidence intervals for contrasts
in one or two-way ANOVA.

## Usage

``` r
estimateContrasts(
  contrast.matrix,
  fit,
  row = TRUE,
  alpha = 0.05,
  L = NULL,
  FUN = identity
)
```

## Arguments

- contrast.matrix:

  A matrix of contrast coefficients. Separate rows of the matrix contain
  the contrast coefficients for that particular contrast, and a column
  for each level of the factor.

- fit:

  Output from the \[lm()\] function.

- row:

  If \`TRUE\`, and the ANOVA is two-way, then contrasts in the row
  effects are printed, otherwise contrasts in the column effects are
  printed. Ignored if the ANOVA is one-way.

- alpha:

  The nominal error rate for the multiple confidence intervals.

- L:

  Number of contrasts. If \`NULL\`, \`L\` will be set to the number of
  rows in the contrast matrix, otherwise \`L\` will be as specified.

- FUN:

  Optional function to be applied to estimates and confidence intervals.
  Typically used for back-transformation operations.

## Value

Returns a matrix whose rows correspond to the different contrasts being
estimated and whose columns correspond to the point estimate of the
contrast, the Tukey lower and upper limits of the confidence interval,
the unadjusted p-value, and the Tukey and Bonferroni p-values.

## Note

Deprecated in s20x 3.4.0. Use the emmeans package instead.

## See also

\[summary1way()\], \[summary2way()\], \[multipleComp()\]

## Examples

``` r
## computer data:
data(computer.df)
computer.df = within(computer.df, {selfassess = factor(selfassess)})
computer.fit = lm(score ~ selfassess, data = computer.df)
contrast.matrix = matrix(c(-1 / 2, -1 / 2, 1), byrow = TRUE, nrow = 1, ncol = 3)
contrast.matrix
#>      [,1] [,2] [,3]
#> [1,] -0.5 -0.5    1
estimateContrasts(contrast.matrix, computer.fit)
#> Warning: estimateContrasts() is deprecated; use the emmeans package instead.
#>            Estimate Tukey.L Tukey.U Tukey.p
#> Contrast 1 39.07143 18.5861 59.5568   4e-04
```
