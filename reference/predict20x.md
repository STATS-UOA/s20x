# Teaching Predictions with Confidence and Prediction Intervals

`predict20x()` gives predictions and intervals for a fitted model. It is
an S3 generic, so the same function works for linear models, generalised
linear models, [`gls`](https://rdrr.io/pkg/nlme/man/gls.html) models and
[`tslm`](https://stats-uoa.github.io/s20x/reference/tslm.md) fits.

## Usage

``` r
predict20x(object, ...)

# Default S3 method
predict20x(object, ...)

# S3 method for class 'lm'
predict20x(
  object,
  newdata,
  conf.level = 0.95,
  digits = 3,
  print.out = TRUE,
  cilevel = conf.level,
  ...
)

# S3 method for class 'glm'
predict20x(
  object,
  newdata,
  conf.level = 0.95,
  digits = 3,
  print.out = TRUE,
  cilevel = conf.level,
  type = c("response", "link", "odds"),
  quasit = FALSE,
  ...
)

# S3 method for class 'gls'
predict20x(
  object,
  newdata,
  conf.level = 0.95,
  digits = 3,
  print.out = TRUE,
  cilevel = conf.level,
  ...
)

# S3 method for class 'tslm'
predict20x(object, newdata, ...)
```

## Arguments

- object:

  a fitted model, such as the output from `lm` or `glm`.

- ...:

  optional arguments that are passed to the model's prediction method,
  or for other methods to `predict20x()`.

- newdata:

  prediction data frame.

- conf.level:

  confidence level for the intervals.

- digits:

  number of decimal places to print.

- print.out:

  if `TRUE`, print the prediction table.

- cilevel:

  the older name for `conf.level`.

- type:

  for a `glm` fit, the scale of the results: `"response"` (the default),
  `"link"`, or `"odds"` for a logit-link model.

- quasit:

  if `TRUE`, use a t multiplier rather than a normal multiplier when
  `object` is a quasi model.

## Value

Invisibly returns an object of class `s20xPrediction`, which prints as
the prediction table. It is a list with components

- frame:

  data frame containing the predictions and intervals.

- fit:

  prediction values, on the link scale for a `glm` fit.

- se.fit:

  standard errors of predictions.

- residual.scale:

  residual standard deviation, for an `lm` or `gls` fit.

- df:

  residual degrees of freedom, for an `lm` or `gls` fit.

- type:

  the scale of the results, for a `glm` fit.

- cilevel:

  confidence level of the interval.

## Details

For an `lm` fit the table holds fitted values, confidence intervals for
the mean response, and prediction intervals for new observations. For a
`glm` fit the intervals are confidence intervals, calculated on the link
scale and then transformed according to `type`.

For a `gls` fit the table has the same columns as for an `lm` fit.
Standard errors come from the estimated covariance matrix of the
coefficients, and the prediction intervals add the residual variance.
They do not use the most recent residuals, so forecasts from a model
with correlated errors follow the fitted mean. A variance model given
through `weights` is ignored, and a warning says so.

The columns of `newdata` are matched to the model variables by name when
every variable is present. Otherwise they are taken in order, either one
column per variable or one column per model term.

This is not a method for
[`predict`](https://rdrr.io/r/stats/predict.html), so it does not change
what [`predict()`](https://rdrr.io/r/stats/predict.html) does for these
models.

## See also

[`predict`](https://rdrr.io/r/stats/predict.html),
[`predict.lm`](https://rdrr.io/r/stats/predict.lm.html),
[`predict.glm`](https://rdrr.io/r/stats/predict.glm.html).

## Examples

``` r

# Zoo data
data(zoo.df)
zoo.df = within(zoo.df, {day.type = factor(day.type)})
zoo.fit = lm(log(attendance) ~ time + sun.yesterday + nice.day + day.type + tv.ads,
             data = zoo.df)
pred.zoo = data.frame(time = 8, sun.yesterday = 10.8, nice.day = 0,
                      day.type = factor(3), tv.ads = 1.181)
predict20x(zoo.fit, pred.zoo)
#>   Predicted  Conf.lower Conf.upper  Pred.lower  Pred.upper
#> 1     6.758       6.567       6.95       5.738       7.778

# Peruvian Indians data
data(peru.df)
peru.fit = lm(BP ~ age + years + I(years^2) + weight + height, data = peru.df)
pred.peru = data.frame(age = 21, years = 2, `I(years^2)` = 2, weight = 71, height = 1629)
predict20x(peru.fit, pred.peru)
#>   Predicted  Conf.lower Conf.upper  Pred.lower  Pred.upper
#> 1   149.437     138.811    160.064     126.924     171.951

# A generalised linear model: predictions on the response scale
peru.glm = glm(BP ~ log(weight), data = peru.df, family = poisson)
predict20x(peru.glm, data.frame(weight = c(60, 70)))
#>   Predicted  Conf.lower Conf.upper
#> 1   124.477     120.711    128.360
#> 2   134.093     129.053    139.331
predict20x(peru.glm, data.frame(weight = c(60, 70)), type = "link")
#>   Predicted  Conf.lower Conf.upper
#> 1     4.824       4.793      4.855
#> 2     4.899       4.860      4.937

# A regression with autocorrelated errors
data(airpass.df)
pass.gls = nlme::gls(log(passengers) ~ t + month + I(t^2),
                     correlation = nlme::corAR1(), data = airpass.df)
predict20x(pass.gls, data.frame(t = 145, month = "Jan"))
#>   Predicted  Conf.lower Conf.upper  Pred.lower  Pred.upper
#> 1      6.11       6.051      6.168       5.995       6.224
```
