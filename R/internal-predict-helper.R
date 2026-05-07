#' Predict from an lm model with standard errors
#'
#' Internal wrapper around the `lm` prediction method used by teaching
#' prediction helpers that need fitted values and their standard errors.
#'
#' @param object An `lm` model object.
#' @param newdata A data frame containing the prediction data.
#' @param ... Additional arguments passed to `predict.lm()`.
#'
#' @return A list in the shape returned by `predict.lm(se.fit = TRUE)`.
#' @importFrom stats predict.lm predict.glm qt qnorm family
#' @keywords internal
#' @noRd
predictLmWithSe = function(object, newdata, ...) {
  predict.lm(object, newdata, se.fit = TRUE, ...)
}

#' Predict from a glm model with standard errors
#'
#' Internal wrapper around the `glm` prediction method used by teaching
#' prediction helpers that need fitted values and their standard errors.
#'
#' @param object A `glm` model object.
#' @param newdata A data frame containing the prediction data.
#' @param ... Additional arguments passed to `predict.glm()`.
#'
#' @return A list in the shape returned by `predict.glm(se.fit = TRUE)`.
#' @keywords internal
#' @noRd
predictGlmWithSe = function(object, newdata, ...) {
  predict.glm(object, newdata, se.fit = TRUE, ...)
}

#' Validate prediction newdata
#'
#' Checks that user-supplied prediction data are a data frame before a teaching
#' prediction wrapper passes them to the model-specific prediction method.
#'
#' @param newdata Candidate prediction data.
#'
#' @return Invisibly returns `newdata` when validation succeeds.
#' @keywords internal
#' @noRd
validatePredictionNewdata = function(newdata) {
  if (!is.data.frame(newdata)) {
    stop("Argument \"newdata\" is not a data frame!")
  }

  invisible(newdata)
}

#' Calculate the central prediction interval probability
#'
#' Converts a two-sided confidence level into the corresponding upper-tail
#' cumulative probability used to find symmetric interval quantiles.
#'
#' @param cilevel Numeric confidence level.
#'
#' @return Numeric cumulative probability for the upper interval endpoint.
#' @keywords internal
#' @noRd
predictionIntervalPercent = function(cilevel) {
  1 - (1 - cilevel) / 2
}

#' Calculate symmetric prediction limits
#'
#' Calculates lower and upper limits around fitted values using supplied
#' standard errors and quantiles.
#'
#' @param fit Numeric vector of fitted values.
#' @param seFit Numeric vector of standard errors.
#' @param quantile Numeric interval quantile.
#'
#' @return A list with `lower` and `upper` numeric vectors.
#' @keywords internal
#' @noRd
predictionConfidenceLimits = function(fit, seFit, quantile) {
  list(
    lower = fit - quantile * seFit,
    upper = fit + quantile * seFit
  )
}

#' Calculate lm teaching prediction intervals
#'
#' Calculates confidence and prediction limits for the teaching-format linear
#' model prediction wrappers.
#'
#' @param fit Numeric vector of fitted values.
#' @param seFit Numeric vector of fitted-value standard errors.
#' @param residualScale Residual standard error for the fitted model.
#' @param df Residual degrees of freedom.
#' @param cilevel Numeric confidence level.
#'
#' @return A list containing confidence and prediction lower and upper limits.
#' @keywords internal
#' @noRd
lmTeachingPredictionIntervals = function(fit, seFit, residualScale, df, cilevel) {
  percent = predictionIntervalPercent(cilevel)
  intervalQuantile = qt(percent, df)
  confidenceLimits = predictionConfidenceLimits(fit, seFit, intervalQuantile)
  predictionSe = sqrt(residualScale^2 + seFit^2)
  predictionLimits = predictionConfidenceLimits(fit, predictionSe, intervalQuantile)

  list(
    confLower = confidenceLimits$lower,
    confUpper = confidenceLimits$upper,
    predLower = predictionLimits$lower,
    predUpper = predictionLimits$upper
  )
}

#' Calculate glm teaching confidence intervals
#'
#' Calculates confidence limits for the teaching-format generalised linear model
#' prediction wrappers.
#'
#' @param fit Numeric vector of fitted values on the prediction scale.
#' @param seFit Numeric vector of fitted-value standard errors.
#' @param cilevel Numeric confidence level.
#' @param quantile Numeric interval quantile.
#'
#' @return A list containing confidence lower and upper limits.
#' @keywords internal
#' @noRd
glmTeachingConfidenceIntervals = function(fit, seFit, cilevel, quantile) {
  confidenceLimits = predictionConfidenceLimits(fit, seFit, quantile)

  list(
    confLower = confidenceLimits$lower,
    confUpper = confidenceLimits$upper
  )
}

#' Format teaching prediction output
#'
#' Rounds prediction values and converts them into the data-frame format used by
#' teaching prediction wrappers.
#'
#' @param values Matrix-like prediction values.
#' @param rowNames Character vector of row names for the output.
#' @param columnNames Character vector of column names for the output.
#' @param digit Number of digits used when rounding prediction values.
#'
#' @return A data frame with the requested row and column names.
#' @keywords internal
#' @noRd
formatTeachingPredictionFrame = function(values, rowNames, columnNames, digit) {
  values = round(values, digit)
  predictionFrame = as.data.frame(values)
  dimnames(predictionFrame) = list(rowNames, columnNames)

  predictionFrame
}

#' Normalise glm prediction type
#'
#' Converts the user-facing GLM prediction type into the internal prediction
#' scale used by the standard-error calculation.
#'
#' @param type Requested prediction type.
#'
#' @return Either `"response"` or `"link"`.
#' @keywords internal
#' @noRd
normaliseGlmPredictionType = function(type) {
  if (identical(type, "response")) {
    return("response")
  }

  "link"
}

#' Format glm prediction output
#'
#' Combines fitted values and confidence limits, optionally transforms them to a
#' user-facing scale, and returns a standard teaching prediction data frame.
#'
#' @param fit Numeric vector of fitted values.
#' @param confLower Numeric vector of lower confidence limits.
#' @param confUpper Numeric vector of upper confidence limits.
#' @param scaleFunction Function used to transform the prediction matrix.
#'
#' @return A data frame with `fit`, `lwr`, and `upr` columns.
#' @keywords internal
#' @noRd
formatGlmPredictionFrame = function(fit, confLower, confUpper, scaleFunction = identity) {
  predictionMatrix = cbind(
    fit = fit,
    lwr = confLower,
    upr = confUpper
  )
  scaledPredictions = scaleFunction(predictionMatrix)
  predictionFrame = as.data.frame(scaledPredictions)
  names(predictionFrame) = c("fit", "lwr", "upr")

  predictionFrame
}

#' Calculate glm teaching interval quantile
#'
#' Selects the interval quantile used by GLM teaching prediction helpers,
#' including a t quantile for quasi-family models when requested.
#'
#' @param cilevel Numeric confidence level.
#' @param object Optional `glm` object used to inspect the fitted family and
#'   residual degrees of freedom.
#' @param quasit Logical; if `TRUE`, quasi-family models use a t quantile.
#'
#' @return Numeric interval quantile.
#' @keywords internal
#' @noRd
glmTeachingIntervalQuantile = function(cilevel, object = NULL, quasit = FALSE) {
  percent = predictionIntervalPercent(cilevel)

  if (quasit && !is.null(object) && substr(family(object)$family, 1, 5) == "quasi") {
    return(qt(percent, object$df.res))
  }

  qnorm(percent)
}
