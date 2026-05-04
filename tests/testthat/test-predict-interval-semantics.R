test_that("predict20x interval columns match current t-based teaching arithmetic", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  fit = lm(y ~ x, data = data)
  newdata = data.frame(x = 6)
  cilevel = 0.90
  digit = 4

  result = predict20x(fit, newdata, cilevel = cilevel, digit = digit, print.out = FALSE)
  basePrediction = predict.lm(fit, newdata, se.fit = TRUE)
  percent = 1 - (1 - cilevel) / 2
  intervalQuantile = qt(percent, basePrediction$df)
  predictionSe = sqrt(basePrediction$residual.scale^2 + basePrediction$se.fit^2)

  expected = data.frame(
    Predicted = round(basePrediction$fit, digit),
    ` Conf.lower` = round(basePrediction$fit - intervalQuantile * basePrediction$se.fit, digit),
    Conf.upper = round(basePrediction$fit + intervalQuantile * basePrediction$se.fit, digit),
    ` Pred.lower` = round(basePrediction$fit - intervalQuantile * predictionSe, digit),
    ` Pred.upper` = round(basePrediction$fit + intervalQuantile * predictionSe, digit),
    check.names = FALSE
  )
  rownames(expected) = rownames(result$frame)

  expect_equal(result$frame, expected)
})

test_that("predictCount interval columns remain rounded exponentiated link-scale confidence limits", {
  data = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  fit = glm(y ~ x, data = data, family = poisson(link = "log"))
  newdata = data.frame(x = 6)
  cilevel = 0.90
  digit = 4

  result = predictCount(fit, newdata, cilevel = cilevel, digit = digit, print.out = FALSE)
  basePrediction = predict.glm(fit, newdata, se.fit = TRUE)
  percent = 1 - (1 - cilevel) / 2
  intervalQuantile = qnorm(percent)

  expectedMatrix = exp(cbind(
    predicted = basePrediction$fit,
    confLower = basePrediction$fit - intervalQuantile * basePrediction$se.fit,
    confUpper = basePrediction$fit + intervalQuantile * basePrediction$se.fit
  ))
  expected = as.data.frame(round(expectedMatrix, digit))
  names(expected) = c("Predicted", " Conf.lower", "Conf.upper")
  rownames(expected) = rownames(result)

  expect_equal(result, expected)
})

test_that("predictGLM response scale applies the inverse link to fit and confidence limits", {
  data = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  fit = glm(y ~ x, data = data, family = poisson(link = "log"))
  newdata = data.frame(x = 6)
  cilevel = 0.90

  linkResult = suppressMessages(predictGLM(fit, newdata, type = "link", cilevel = cilevel))
  responseResult = suppressMessages(predictGLM(fit, newdata, type = "response", cilevel = cilevel))
  expectedResponse = fit$family$linkinv(linkResult)

  expect_equal(responseResult, expectedResponse)
})
