# Deprecated box plots and normal quantile-quantile plots

\`boxqq()\` is deprecated and is no longer exported. It draws boxplots
and normal quantile-quantile plots of \`x\` for each level of the
grouping variable \`g\`.

## Usage

``` r
boxqq(formula, ...)
```

## Arguments

- formula:

  A symbolic specification of the form `x ~ g` can be given, indicating
  the observations in the vector `x` are to be grouped according to the
  levels of the factor `g`. `NA`'s are allowed in the data.

- ...:

  Arguments to be passed to methods, such as graphical parameters (see
  [`par`](https://rdrr.io/r/graphics/par.html)).

## Value

Returns the plot.

## Note

This is a legacy teaching helper retained for compatibility with older
course material. New teaching material should prefer current diagnostic
plotting workflows.
