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

  result = suppressWarnings(predictCount(fit, newdata, print.out = FALSE))
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

  linkResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, type = "link")))
  responseResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, type = "response")))
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

  linkResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, type = "link")))
  expect_message(
    suppressWarnings(predictGLM(fit, newdata, type = "unsupported")),
    "link scale",
    fixed = TRUE
  )
  fallbackResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, type = "unsupported")))

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
  countResult = suppressWarnings(predictCount(countFit, countNewdata, print.out = FALSE))

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

  linkResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, type = "link")))
  responseResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, type = "response")))

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

  normalResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, cilevel = cilevel, quasit = FALSE)))
  quasiResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, cilevel = cilevel, quasit = TRUE)))

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

test_that("predict20x handles transformed terms", {
  data("peru.df", package = "s20x", envir = environment())

  fit = lm(BP ~ log(weight) + age, data = peru.df)
  newdata = data.frame(weight = 70, age = 30)
  result = predict20x(fit, newdata, print.out = FALSE)

  expect_equal(unname(result$fit), unname(predict(fit, newdata)))
})

test_that("predict20x matches named columns in any order", {
  data("peru.df", package = "s20x", envir = environment())

  fit = lm(BP ~ weight + age, data = peru.df)
  reversed = data.frame(age = 30, weight = 70)
  result = predict20x(fit, reversed, print.out = FALSE)

  expect_equal(unname(result$fit), unname(predict(fit, reversed)))
})

test_that("predict20x still takes columns in order and one per term", {
  data("peru.df", package = "s20x", envir = environment())

  fit = lm(BP ~ weight + age, data = peru.df)
  renamed = data.frame(first = 70, second = 30)
  expected = predict(fit, data.frame(weight = 70, age = 30))
  expect_equal(unname(predict20x(fit, renamed, print.out = FALSE)$fit), unname(expected))

  quadraticFit = lm(BP ~ age + years + I(years^2) + weight + height, data = peru.df)
  documented = data.frame(
    age = 21, years = 2, `I(years^2)` = 2, weight = 71, height = 1629
  )
  expect_equal(
    unname(predict20x(quadraticFit, documented, print.out = FALSE)$fit),
    unname(predict(quadraticFit, documented))
  )

  onePerTerm = data.frame(first = 21, second = 2, third = 4, fourth = 71, fifth = 1629)
  expect_equal(
    unname(predict20x(quadraticFit, onePerTerm, print.out = FALSE)$fit),
    unname(predict(quadraticFit, data.frame(age = 21, years = 2, weight = 71, height = 1629)))
  )

  factorTermFit = lm(BP ~ factor(age > 30) + age + I(age^2), data = peru.df)
  factorTermRow = data.frame(first = TRUE, second = 40, third = 1600)
  expect_equal(
    unname(predict20x(factorTermFit, factorTermRow, print.out = FALSE)$fit),
    unname(predict(factorTermFit, data.frame(age = 40)))
  )

  expect_error(
    predict20x(fit, data.frame(first = 70), print.out = FALSE),
    "Incorrectly input the new data!"
  )
})

test_that("predictCount handles transformed terms", {
  data("peru.df", package = "s20x", envir = environment())

  fit = glm(BP ~ log(weight), data = peru.df, family = poisson)
  newdata = data.frame(weight = 70)
  result = suppressWarnings(predictCount(fit, newdata, print.out = FALSE))

  expect_equal(
    result$Predicted,
    round(unname(predict(fit, newdata, type = "response")), 3)
  )
})

test_that("predictGLM accepts the variables behind transformed terms", {
  data("computer.df", package = "s20x", envir = environment())
  data("peru.df", package = "s20x", envir = environment())

  factorFit = glm(score ~ factor(selfassess), data = computer.df, family = poisson)
  factorNewdata = data.frame(selfassess = 2)
  logFit = glm(BP ~ log(weight), data = peru.df, family = poisson)
  logNewdata = data.frame(weight = 70)

  expect_equal(
    suppressMessages(suppressWarnings(predictGLM(factorFit, factorNewdata)))[[1]],
    unname(predict(factorFit, factorNewdata))
  )
  expect_equal(
    suppressMessages(suppressWarnings(predictGLM(logFit, logNewdata)))[[1]],
    unname(predict(logFit, logNewdata))
  )
  expect_error(
    suppressMessages(suppressWarnings(predictGLM(logFit, data.frame(height = 170)))),
    "newdata must be provided"
  )
})

test_that("predict20x intervals match predict.lm", {
  data("peru.df", package = "s20x", envir = environment())

  fit = lm(BP ~ weight + age, data = peru.df)
  newdata = data.frame(weight = c(60, 70), age = c(30, 40))
  frame = predict20x(fit, newdata, cilevel = 0.9, digit = 8, print.out = FALSE)$frame

  confidence = predict(fit, newdata, interval = "confidence", level = 0.9)
  prediction = predict(fit, newdata, interval = "prediction", level = 0.9)

  expect_equal(frame$Predicted, unname(confidence[, "fit"]), tolerance = 1e-6)
  expect_equal(frame[[" Conf.lower"]], unname(confidence[, "lwr"]), tolerance = 1e-6)
  expect_equal(frame$Conf.upper, unname(confidence[, "upr"]), tolerance = 1e-6)
  expect_equal(frame[[" Pred.lower"]], unname(prediction[, "lwr"]), tolerance = 1e-6)
  expect_equal(frame[[" Pred.upper"]], unname(prediction[, "upr"]), tolerance = 1e-6)
})

test_that("predictCount intervals are Wald limits on the log scale", {
  data("peru.df", package = "s20x", envir = environment())

  fit = glm(BP ~ weight, data = peru.df, family = poisson)
  newdata = data.frame(weight = c(60, 70))
  frame = suppressWarnings(predictCount(fit, newdata, cilevel = 0.9, digit = 8, print.out = FALSE))

  linkScale = predict(fit, newdata, se.fit = TRUE)
  halfWidth = qnorm(0.95) * linkScale$se.fit

  expect_equal(frame$Predicted, unname(exp(linkScale$fit)), tolerance = 1e-6)
  expect_equal(frame[[" Conf.lower"]], unname(exp(linkScale$fit - halfWidth)), tolerance = 1e-6)
  expect_equal(frame$Conf.upper, unname(exp(linkScale$fit + halfWidth)), tolerance = 1e-6)
})

test_that("predictGLM intervals match Wald limits for log and logit links", {
  data("peru.df", package = "s20x", envir = environment())

  logFit = glm(BP ~ weight, data = peru.df, family = poisson)
  logitFit = glm(I(BP > 125) ~ weight, data = peru.df, family = binomial)
  newdata = data.frame(weight = c(60, 70))

  for (fit in list(logFit, logitFit)) {
    linkScale = predict(fit, newdata, se.fit = TRUE)
    halfWidth = qnorm(0.975) * linkScale$se.fit

    linkResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata)))
    expect_equal(linkResult$fit, unname(linkScale$fit))
    expect_equal(linkResult$lwr, unname(linkScale$fit - halfWidth))
    expect_equal(linkResult$upr, unname(linkScale$fit + halfWidth))

    responseResult = suppressMessages(suppressWarnings(predictGLM(fit, newdata, type = "response")))
    expect_equal(responseResult$upr, unname(fit$family$linkinv(linkScale$fit + halfWidth)))
  }
})

test_that("predictGLM quasit uses the t distribution for quasi families", {
  data("peru.df", package = "s20x", envir = environment())

  fit = glm(BP ~ weight, data = peru.df, family = quasipoisson)
  newdata = data.frame(weight = 70)
  linkScale = predict(fit, newdata, se.fit = TRUE)
  halfWidth = qt(0.975, fit$df.residual) * linkScale$se.fit

  result = suppressMessages(suppressWarnings(predictGLM(fit, newdata, quasit = TRUE)))

  expect_equal(result$upr, unname(linkScale$fit + halfWidth))
})
