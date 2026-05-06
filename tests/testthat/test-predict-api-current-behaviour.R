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
