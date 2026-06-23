test_that("internal prediction helpers preserve base prediction output", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  lmFit = lm(y ~ x, data = data)
  lmNewdata = data.frame(x = 6)

  expect_equal(
    getS20xInternal("predictLmWithSe")(lmFit, lmNewdata),
    predict.lm(lmFit, lmNewdata, se.fit = TRUE)
  )

  countData = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  glmFit = glm(y ~ x, data = countData, family = poisson(link = "log"))
  glmNewdata = data.frame(x = 6)

  expect_equal(
    getS20xInternal("predictGlmWithSe")(glmFit, glmNewdata),
    predict.glm(glmFit, glmNewdata, se.fit = TRUE)
  )
})

test_that("teaching prediction wrappers use the shared helper path without changing output", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  lmFit = lm(y ~ x, data = data)
  lmNewdata = data.frame(x = 6)
  lmResult = predict20x(lmFit, lmNewdata, print.out = FALSE)
  lmBase = getS20xInternal("predictLmWithSe")(lmFit, lmNewdata)

  expect_equal(lmResult$fit, lmBase$fit)
  expect_equal(lmResult$se.fit, lmBase$se.fit)

  countData = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  glmFit = glm(y ~ x, data = countData, family = poisson(link = "log"))
  glmNewdata = data.frame(x = 6)
  countResult = predictCount(glmFit, glmNewdata, print.out = FALSE)
  glmBase = getS20xInternal("predictGlmWithSe")(glmFit, glmNewdata)

  expect_equal(countResult$Predicted, unname(round(exp(glmBase$fit), 3)))

  glmResult = suppressMessages(predictGLM(glmFit, glmNewdata, type = "link"))
  expect_equal(glmResult[, "fit"], unname(glmBase$fit))
})

test_that("internal prediction interval helpers preserve existing linear-model arithmetic", {
  fit = c(10, 12)
  seFit = c(0.5, 0.75)
  residualScale = 1.25
  df = 8
  cilevel = 0.95
  percent = 1 - (1 - cilevel) / 2
  intervalQuantile = qt(percent, df)
  predictionSe = sqrt(residualScale^2 + seFit^2)

  result = getS20xInternal("lmTeachingPredictionIntervals")(
    fit = fit,
    seFit = seFit,
    residualScale = residualScale,
    df = df,
    cilevel = cilevel
  )

  expect_equal(result$confLower, fit - intervalQuantile * seFit)
  expect_equal(result$confUpper, fit + intervalQuantile * seFit)
  expect_equal(result$predLower, fit - intervalQuantile * predictionSe)
  expect_equal(result$predUpper, fit + intervalQuantile * predictionSe)
})

test_that("internal GLM interval helpers preserve existing normal and quasi arithmetic", {
  fit = c(1, 2)
  seFit = c(0.2, 0.3)
  cilevel = 0.95
  percent = 1 - (1 - cilevel) / 2
  intervalQuantile = qnorm(percent)

  result = getS20xInternal("glmTeachingConfidenceIntervals")(
    fit = fit,
    seFit = seFit,
    cilevel = cilevel,
    quantile = intervalQuantile
  )

  expect_equal(result$confLower, fit - intervalQuantile * seFit)
  expect_equal(result$confUpper, fit + intervalQuantile * seFit)
  expect_equal(getS20xInternal("glmTeachingIntervalQuantile")(cilevel), qnorm(percent))

  quasiFit = glm(
    c(1, 2, 3, 4, 6) ~ c(1, 2, 3, 4, 5),
    family = quasipoisson(link = "log")
  )
  expect_equal(
    getS20xInternal("glmTeachingIntervalQuantile")(cilevel, quasiFit, quasit = TRUE),
    qt(percent, quasiFit$df.res)
  )
})

test_that("internal prediction newdata validation preserves wrapper error text", {
  expect_error(
    getS20xInternal("validatePredictionNewdata")(list(x = 1)),
    'Argument \"newdata\" is not a data frame!',
    fixed = TRUE
  )

  newdata = data.frame(x = 1)
  expect_invisible(getS20xInternal("validatePredictionNewdata")(newdata))
})

test_that("internal prediction output format helpers preserve legacy shape", {
  values = cbind(
    fit = c(1.2345, 2.3456),
    lwr = c(0.1234, 1.2345),
    upr = c(2.3456, 3.4567)
  )

  result = getS20xInternal("formatTeachingPredictionFrame")(
    values = values,
    rowNames = c("1", "2"),
    columnNames = c("Predicted", " Conf.lower", "Conf.upper"),
    digit = 2
  )

  expected = data.frame(
    Predicted = c(1.23, 2.35),
    ` Conf.lower` = c(0.12, 1.23),
    Conf.upper = c(2.35, 3.46),
    check.names = FALSE
  )
  rownames(expected) = c("1", "2")

  expect_s3_class(result, "data.frame")
  expect_equal(result, expected)
})

test_that("internal GLM output format helper returns a stable data-frame shape", {
  fit = c(1, 2)
  confLower = c(0.8, 1.7)
  confUpper = c(1.2, 2.3)

  linkResult = getS20xInternal("formatGlmPredictionFrame")(
    fit = fit,
    confLower = confLower,
    confUpper = confUpper
  )
  responseResult = getS20xInternal("formatGlmPredictionFrame")(
    fit = fit,
    confLower = confLower,
    confUpper = confUpper,
    scaleFunction = exp
  )

  expect_s3_class(linkResult, "data.frame")
  expect_named(linkResult, c("fit", "lwr", "upr"))
  expect_equal(linkResult$fit, fit)
  expect_equal(responseResult, as.data.frame(exp(as.matrix(linkResult))))
})

test_that("internal GLM type normalisation preserves legacy fallback", {
  expect_equal(getS20xInternal("normaliseGlmPredictionType")("response"), "response")
  expect_equal(getS20xInternal("normaliseGlmPredictionType")("link"), "link")
  expect_equal(getS20xInternal("normaliseGlmPredictionType")("bad-type"), "link")
  expect_equal(getS20xInternal("normaliseGlmPredictionType")(NULL), "link")
})
