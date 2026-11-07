# Predicted Counts for a Log-Link Generalised Linear Model

Teaching helper for count predictions from a log-link generalised linear
model. It wraps
[`predict.glm`](https://rdrr.io/r/stats/predict.glm.html), constructs
confidence intervals on the link scale, exponentiates the fitted values
and limits, rounds the result, and optionally prints the returned table.

## Usage

``` r
predictCount(object, newdata, cilevel = 0.95, digit = 3, print.out = TRUE, ...)
```

## Arguments

- object:

  a `glm` object, i.e. the output from
  [`glm`](https://rdrr.io/r/stats/glm.html).

- newdata:

  prediction data frame.

- cilevel:

  confidence level for the intervals.

- digit:

  number of decimal places to print.

- print.out:

  if `TRUE`, print the prediction table.

- ...:

  optional arguments that are passed to
  [`predict.glm`](https://rdrr.io/r/stats/predict.glm.html).

## Value

Invisibly returns a data frame with three columns:

- Predicted:

  the predicted count on the response scale.

- Conf.lower:

  the lower confidence limit on the response scale.

- Conf.upper:

  the upper confidence limit on the response scale.

## Details

New work should use
[`predict20x`](https://stats-uoa.github.io/s20x/reference/predict20x.md),
which handles `lm` and `glm` fits with one function. `predictCount()`
always exponentiates, so for a logit-link model it returns odds, as
`predict20x(type = "odds")` does.

Note: `newdata` must be a data frame with the same column order and data
types as those used in fitting the model. This stricter interface is
kept for compatibility with the original teaching wrapper.

## Note

Deprecated in s20x 3.4.0. Use
[`predict20x`](https://stats-uoa.github.io/s20x/reference/predict20x.md)
instead, with `type = "odds"` to keep this scale for a logit model. It
returns a list, and the table of results is its `frame` component.

## See also

[`predict`](https://rdrr.io/r/stats/predict.html),
[`predict.glm`](https://rdrr.io/r/stats/predict.glm.html),
[`predictGLM`](https://stats-uoa.github.io/s20x/reference/predictGLM.md),
[`as.data.frame`](https://rdrr.io/r/base/as.data.frame.html).
