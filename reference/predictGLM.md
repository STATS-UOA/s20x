# Prediction Intervals for Log-Link and Logit-Link Generalised Linear Models

Teaching helper for predictions from log-link and logit-link generalised
linear models. It wraps
[`predict.glm`](https://rdrr.io/r/stats/predict.glm.html) with standard
errors and returns fitted values with confidence limits on either the
link scale or the response scale.

## Usage

``` r
predictGLM(object, newdata, type = "link", cilevel = 0.95, quasit = FALSE, ...)
```

## Arguments

- object:

  a `glm` object, i.e. the output from
  [`glm`](https://rdrr.io/r/stats/glm.html).

- newdata:

  prediction data frame.

- type:

  `"link"` (default) or `"response"` for estimates and confidence
  intervals on the linear predictor or response scale.

- cilevel:

  confidence level for the intervals.

- quasit:

  if `TRUE`, use a t multiplier rather than a normal multiplier for
  confidence intervals when `object` is a quasi model.

- ...:

  optional arguments that are passed to
  [`predict.glm`](https://rdrr.io/r/stats/predict.glm.html).

## Value

A data frame with columns `fit`, `lwr`, and `upr` containing fitted
values and confidence limits on the requested scale.

## Details

New work should use
[`predict20x`](https://stats-uoa.github.io/s20x/reference/predict20x.md),
which handles `lm` and `glm` fits with one function and gives results on
the response scale by default. `predictGLM()` keeps its own defaults and
column names for existing teaching material.

Note: `newdata` must include all first-order terms used in the fitted
model. This simplified requirement reflects the teaching-wrapper
interface and is not a complete reproduction of
[`predict.glm()`](https://rdrr.io/r/stats/predict.glm.html).

## Note

Deprecated in s20x 3.3.9. Use
[`predict20x`](https://stats-uoa.github.io/s20x/reference/predict20x.md)
instead.

## See also

[`predict`](https://rdrr.io/r/stats/predict.html),
[`predict.glm`](https://rdrr.io/r/stats/predict.glm.html),
[`predictCount`](https://stats-uoa.github.io/s20x/reference/predictCount.md).
