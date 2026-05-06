test_that("internal prediction helpers preserve base prediction output", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  lmFit = lm(y ~ x, data = data)
  lmNewdata = data.frame(x = 6)

  expect_equal(
    s20x:::predictLmWithSe(lmFit, lmNewdata),
    predict.lm(lmFit, lmNewdata, se.fit = TRUE)
  )

  countData = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  glmFit = glm(y ~ x, data = countData, family = poisson(link = "log"))
  glmNewdata = data.frame(x = 6)

  expect_equal(
    s20x:::predictGlmWithSe(glmFit, glmNewdata),
    predict.glm(glmFit, glmNewdata, se.fit = TRUE)
  )
})

test_that("teaching prediction wrappers use the shared helper path without changing output", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  lmFit = lm(y ~ x, data = data)
  lmNewdata = data.frame(x = 6)
  lmResult = predict20x(lmFit, lmNewdata, print.out = FALSE)
  lmBase = s20x:::predictLmWithSe(lmFit, lmNewdata)

  expect_equal(lmResult$fit, lmBase$fit)
  expect_equal(lmResult$se.fit, lmBase$se.fit)

  countData = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  glmFit = glm(y ~ x, data = countData, family = poisson(link = "log"))
  glmNewdata = data.frame(x = 6)
  countResult = predictCount(glmFit, glmNewdata, print.out = FALSE)
  glmBase = s20x:::predictGlmWithSe(glmFit, glmNewdata)

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

  result = s20x:::lmTeachingPredictionIntervals(
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

  result = s20x:::glmTeachingConfidenceIntervals(
    fit = fit,
    seFit = seFit,
    cilevel = cilevel,
    quantile = intervalQuantile
  )

  expect_equal(result$confLower, fit - intervalQuantile * seFit)
  expect_equal(result$confUpper, fit + intervalQuantile * seFit)
  expect_equal(s20x:::glmTeachingIntervalQuantile(cilevel), qnorm(percent))

  quasiFit = glm(
    c(1, 2, 3, 4, 6) ~ c(1, 2, 3, 4, 5),
    family = quasipoisson(link = "log")
  )
  expect_equal(
    s20x:::glmTeachingIntervalQuantile(cilevel, quasiFit, quasit = TRUE),
    qt(percent, quasiFit$df.res)
  )
})

test_that("internal prediction newdata validation preserves wrapper error text", {
  expect_error(
    s20x:::validatePredictionNewdata(list(x = 1)),
    "Argument \"newdata\" is not a data frame!",
    fixed = TRUE
  )

  newdata = data.frame(x = 1)
  expect_invisible(s20x:::validatePredictionNewdata(newdata))
})
