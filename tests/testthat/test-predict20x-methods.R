test_that("predict20x dispatches on the class of the model", {
  data("peru.df", package = "s20x", envir = environment())

  lmResult = predict20x(lm(BP ~ weight, data = peru.df), data.frame(weight = 70), print.out = FALSE)
  glmResult = predict20x(
    glm(BP ~ weight, data = peru.df, family = poisson),
    data.frame(weight = 70),
    print.out = FALSE
  )

  expect_s3_class(lmResult, "s20xPrediction")
  expect_s3_class(glmResult, "s20xPrediction")
  expect_true(" Pred.lower" %in% names(lmResult$frame))
  expect_false(" Pred.lower" %in% names(glmResult$frame))
  expect_error(predict20x(peru.df, data.frame(weight = 70)), "not an \"lm\" object")
})

test_that("predict20x matches predictCount on the response scale for a log link", {
  data("peru.df", package = "s20x", envir = environment())

  fit = glm(BP ~ weight, data = peru.df, family = poisson)
  newdata = data.frame(weight = c(60, 70))

  expect_equal(
    predict20x(fit, newdata, print.out = FALSE)$frame,
    predictCount(fit, newdata, print.out = FALSE)
  )
})

test_that("predict20x glm scales match Wald limits", {
  data("peru.df", package = "s20x", envir = environment())

  fit = glm(I(BP > 125) ~ weight, data = peru.df, family = binomial)
  newdata = data.frame(weight = c(60, 70))
  linkScale = predict(fit, newdata, se.fit = TRUE)
  upper = linkScale$fit + qnorm(0.975) * linkScale$se.fit

  linkFrame = predict20x(fit, newdata, type = "link", digits = 8, print.out = FALSE)$frame
  responseFrame = predict20x(fit, newdata, digits = 8, print.out = FALSE)$frame
  oddsFrame = predict20x(fit, newdata, type = "odds", digits = 8, print.out = FALSE)$frame

  expect_equal(linkFrame$Conf.upper, unname(upper), tolerance = 1e-6)
  expect_equal(responseFrame$Conf.upper, unname(plogis(upper)), tolerance = 1e-6)
  expect_equal(oddsFrame$Conf.upper, unname(exp(upper)), tolerance = 1e-6)
})

test_that("predict20x only gives odds for a logit link", {
  data("peru.df", package = "s20x", envir = environment())

  fit = glm(BP ~ weight, data = peru.df, family = poisson)

  expect_error(
    predict20x(fit, data.frame(weight = 70), type = "odds", print.out = FALSE),
    "logit-link"
  )
})

test_that("predictCount still exponentiates a logit-link model", {
  data("peru.df", package = "s20x", envir = environment())

  fit = glm(I(BP > 125) ~ weight, data = peru.df, family = binomial)
  newdata = data.frame(weight = 70)

  expect_equal(
    predictCount(fit, newdata, digit = 8, print.out = FALSE)$Predicted,
    unname(exp(predict(fit, newdata))),
    tolerance = 1e-6
  )
})

test_that("predict20x accepts both the old and new argument names", {
  data("peru.df", package = "s20x", envir = environment())

  fit = lm(BP ~ weight, data = peru.df)
  newdata = data.frame(weight = 70)
  expected = predict20x(fit, newdata, conf.level = 0.9, digits = 5, print.out = FALSE)

  expect_equal(predict20x(fit, newdata, cilevel = 0.9, digit = 5, print.out = FALSE), expected)
  expect_equal(predict20x(fit, newdata, 0.9, 5, FALSE), expected)
  expect_equal(expected$cilevel, 0.9)
})

test_that("predict20x handles tslm fits without AR errors", {
  data(airpass.df)

  tslmFit = tslm(log(passengers) ~ t, data = airpass.df)
  lmFit = lm(log(passengers) ~ t, data = airpass.df)
  newdata = data.frame(t = 145)

  expect_equal(
    predict20x(tslmFit, newdata, print.out = FALSE)$frame,
    predict20x(lmFit, newdata, print.out = FALSE)$frame
  )

  arFit = tslm(log(passengers) ~ t + ar(1), data = airpass.df, time = t)
  expect_error(predict20x(arFit, newdata, print.out = FALSE), "ar\\(p\\)")
})

test_that("saved results print what the function printed", {
  data("peru.df", package = "s20x", envir = environment())
  data("oysters.df", package = "s20x", envir = environment())
  data("arousal.df", package = "s20x", envir = environment())

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  predictFit = lm(BP ~ weight, data = peru.df)
  predictOutput = capture.output(saved <- predict20x(predictFit, data.frame(weight = 70)))
  expect_equal(capture.output(print(saved)), predictOutput)

  oneWayFit = lm(log(Oysters) ~ Site, data = oysters.df)
  oneWayOutput = capture.output(saved <- summary1way(oneWayFit, draw.plot = FALSE))
  expect_s3_class(saved, "s20xSummary1way")
  expect_equal(capture.output(print(saved)), oneWayOutput)

  twoWayFit = lm(arousal ~ gender * picture, data = arousal.df)
  twoWayOutput = capture.output(saved <- summary2way(twoWayFit, page = "interaction"))
  expect_s3_class(saved, "s20xSummary2way")
  expect_equal(capture.output(print(saved)), twoWayOutput)

  statsOutput = capture.output(saved <- summaryStats(peru.df$BP))
  expect_s3_class(saved, "s20xSummaryStats")
  expect_equal(capture.output(print(saved)), statsOutput)
})

test_that("summaryStats results can still be used as a data frame", {
  data("oysters.df", package = "s20x", envir = environment())

  capture.output(saved <- summaryStats(Oysters ~ Site, data = oysters.df))

  expect_s3_class(saved, "data.frame")
  expect_length(saved$mean, nlevels(oysters.df$Site))
  expect_no_error(capture.output(print(saved[1, ])))
  expect_no_error(capture.output(print(saved[, c("mean", "sd")])))
})

test_that("the core functions return results invisibly", {
  data("oysters.df", package = "s20x", envir = environment())

  fit = lm(log(Oysters) ~ Site, data = oysters.df)
  newdata = data.frame(Site = "GR")

  expect_invisible(predict20x(fit, newdata, print.out = FALSE))
  expect_invisible(summary1way(fit, print.out = FALSE, draw.plot = FALSE))
  capture.output(expect_invisible(summaryStats(oysters.df$Oysters)))
})

test_that("summary functions accept both digit and digits", {
  data("oysters.df", package = "s20x", envir = environment())

  fit = lm(log(Oysters) ~ Site, data = oysters.df)
  oldName = summary1way(fit, digit = 2, print.out = FALSE, draw.plot = FALSE)
  newName = summary1way(fit, digits = 2, print.out = FALSE, draw.plot = FALSE)

  expect_equal(oldName, newName)
  expect_equal(oldName$`Mean Sq`, round(anova(fit)$`Mean Sq`, 2))
})
