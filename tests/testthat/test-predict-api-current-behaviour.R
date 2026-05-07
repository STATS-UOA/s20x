test_that("predict20x keeps its current teaching-wrapper return shape", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  fit = lm(y ~ x, data = data)
  newdata = data.frame(x = 6)

  result = predict20x(fit, newdata, print.out = FALSE)
  basePrediction = predict.lm(fit, newdata, se.fit = TRUE)

  expect_type(result, "list")
  expect_named(result, c("frame", "fit", "se.fit", "residual.scale", "df", "cilevel"))
  expect_s3_class(result$frame, "data.frame")
  expect_named(result$frame, c("Predicted", " Conf.lower", "Conf.upper", " Pred.lower", " Pred.upper"))
  expect_equal(result$fit, basePrediction$fit)
  expect_equal(result$cilevel, 0.95)
})

test_that("predictCount keeps its current response-scale count output", {
  data = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  fit = glm(y ~ x, data = data, family = poisson(link = "log"))
  newdata = data.frame(x = 6)

  result = predictCount(fit, newdata, print.out = FALSE)
  linkPrediction = predict.glm(fit, newdata, se.fit = TRUE)
  expectedFit = round(exp(linkPrediction$fit), 3)

  expect_s3_class(result, "data.frame")
  expect_named(result, c("Predicted", " Conf.lower", "Conf.upper"))
  expect_equal(result$Predicted, unname(expectedFit))
})

test_that("predictGLM keeps its link and response scale behaviour with data-frame output", {
  data = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  fit = glm(y ~ x, data = data, family = poisson(link = "log"))
  newdata = data.frame(x = 6)

  linkResult = suppressMessages(predictGLM(fit, newdata, type = "link"))
  responseResult = suppressMessages(predictGLM(fit, newdata, type = "response"))
  baseLink = predict.glm(fit, newdata, se.fit = TRUE)

  expect_s3_class(linkResult, "data.frame")
  expect_s3_class(responseResult, "data.frame")
  expect_named(linkResult, c("fit", "lwr", "upr"))
  expect_named(responseResult, c("fit", "lwr", "upr"))
  expect_false(is.matrix(linkResult))
  expect_false(is.matrix(responseResult))
  expect_equal(linkResult$fit, unname(baseLink$fit))
  expect_equal(responseResult$fit, unname(fit$family$linkinv(baseLink$fit)))
})

test_that("predictGLM keeps legacy fallback to link scale for unsupported type values", {
  data = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  fit = glm(y ~ x, data = data, family = poisson(link = "log"))
  newdata = data.frame(x = 6)

  linkResult = suppressMessages(predictGLM(fit, newdata, type = "link"))
  expect_message(
    predictGLM(fit, newdata, type = "unsupported"),
    "link scale",
    fixed = TRUE
  )
  fallbackResult = suppressMessages(predictGLM(fit, newdata, type = "unsupported"))

  expect_equal(fallbackResult, linkResult)
})

test_that("prediction wrappers preserve multi-row return shapes", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  lmFit = lm(y ~ x, data = data)
  lmNewdata = data.frame(x = c(6, 7))
  lmResult = predict20x(lmFit, lmNewdata, print.out = FALSE)

  expect_s3_class(lmResult$frame, "data.frame")
  expect_named(lmResult$frame, c("Predicted", " Conf.lower", "Conf.upper", " Pred.lower", " Pred.upper"))
  expect_equal(rownames(lmResult$frame), c("1", "2"))
  expect_equal(nrow(lmResult$frame), 2L)

  countData = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  countFit = glm(y ~ x, data = countData, family = poisson(link = "log"))
  countNewdata = data.frame(x = c(6, 7))
  countResult = predictCount(countFit, countNewdata, print.out = FALSE)

  expect_s3_class(countResult, "data.frame")
  expect_named(countResult, c("Predicted", " Conf.lower", "Conf.upper"))
  expect_equal(rownames(countResult), c("1", "2"))
  expect_equal(nrow(countResult), 2L)
})

test_that("predictGLM preserves binomial logit return shape on both scales", {
  data = data.frame(
    success = c(1, 2, 4, 7, 8),
    failure = c(9, 8, 6, 3, 2),
    x = c(1, 2, 3, 4, 5)
  )
  fit = glm(cbind(success, failure) ~ x, data = data, family = binomial(link = "logit"))
  newdata = data.frame(x = c(3, 5))

  linkResult = suppressMessages(predictGLM(fit, newdata, type = "link"))
  responseResult = suppressMessages(predictGLM(fit, newdata, type = "response"))

  expect_s3_class(linkResult, "data.frame")
  expect_s3_class(responseResult, "data.frame")
  expect_named(linkResult, c("fit", "lwr", "upr"))
  expect_named(responseResult, c("fit", "lwr", "upr"))
  expect_equal(rownames(linkResult), c("1", "2"))
  expect_equal(rownames(responseResult), c("1", "2"))
  expect_equal(nrow(linkResult), 2L)
  expect_equal(nrow(responseResult), 2L)
})

test_that("predictGLM quasi interval multiplier behaviour is covered at wrapper level", {
  data = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  fit = glm(y ~ x, data = data, family = quasipoisson(link = "log"))
  newdata = data.frame(x = 6)
  cilevel = 0.90
  percent = 1 - (1 - cilevel) / 2
  basePrediction = predict.glm(fit, newdata, se.fit = TRUE)

  normalResult = suppressMessages(predictGLM(fit, newdata, cilevel = cilevel, quasit = FALSE))
  quasiResult = suppressMessages(predictGLM(fit, newdata, cilevel = cilevel, quasit = TRUE))

  normalExpected = data.frame(
    fit = unname(basePrediction$fit),
    lwr = unname(basePrediction$fit - qnorm(percent) * basePrediction$se.fit),
    upr = unname(basePrediction$fit + qnorm(percent) * basePrediction$se.fit)
  )
  quasiExpected = data.frame(
    fit = unname(basePrediction$fit),
    lwr = unname(basePrediction$fit - qt(percent, fit$df.res) * basePrediction$se.fit),
    upr = unname(basePrediction$fit + qt(percent, fit$df.res) * basePrediction$se.fit)
  )
  expect_equal(names(normalResult), names(normalExpected))
  expect_equal(names(quasiResult), names(quasiExpected))
  expect_equal(as.list(normalResult), as.list(normalExpected))
  expect_equal(as.list(quasiResult), as.list(quasiExpected))
})
