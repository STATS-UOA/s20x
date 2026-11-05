# Deprecated strip charts and normal quantile-quantile plots

\`stripqq()\` is deprecated and is no longer exported. It draws strip
charts and normal quantile-quantile plots of \`x\` for each level of the
grouping variable \`g\`.

## Usage

``` r
stripqq(formula, ...)
```

## Arguments

- formula:

  A symbolic specification of the form `x ~ g` can be given, indicating
  the observations in the vector `x` are grouped according to the levels
  of the factor `g`. `NA`s are allowed in the data.

- ...:

  Optional arguments that are passed to the `stripchart` function.

## Note

This is a legacy teaching helper retained for compatibility with older
course material. New teaching material should prefer current diagnostic
plotting workflows.
