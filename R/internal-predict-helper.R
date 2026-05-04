predictLmWithSe = function(object, newdata, ...) {
  predict.lm(object, newdata, se.fit = TRUE, ...)
}

predictGlmWithSe = function(object, newdata, ...) {
  predict.glm(object, newdata, se.fit = TRUE, ...)
}

predictionIntervalPercent = function(cilevel) {
  1 - (1 - cilevel) / 2
}

predictionConfidenceLimits = function(fit, seFit, quantile) {
  list(
    lower = fit - quantile * seFit,
    upper = fit + quantile * seFit
  )
}

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

glmTeachingConfidenceIntervals = function(fit, seFit, cilevel, quantile) {
  confidenceLimits = predictionConfidenceLimits(fit, seFit, quantile)

  list(
    confLower = confidenceLimits$lower,
    confUpper = confidenceLimits$upper
  )
}

glmTeachingIntervalQuantile = function(cilevel, object = NULL, quasit = FALSE) {
  percent = predictionIntervalPercent(cilevel)

  if (quasit && !is.null(object) && substr(family(object)$family, 1, 5) == "quasi") {
    return(qt(percent, object$df.res))
  }

  qnorm(percent)
}
