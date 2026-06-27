test_that("ggplot2 diagnostic engines document the multiple-plot return contract", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  normPlots = normcheck(fit, engine = "ggplot2")
  modelPlots = modelcheck(fit, engine = "ggplot2")

  expect_s3_class(normPlots, "s20xNormcheck_ggplot2")
  expect_named(normPlots, c("qq", "histogram"))
  expect_s3_class(normPlots$qq, "ggplot")
  expect_s3_class(normPlots$histogram, "ggplot")

  expect_s3_class(modelPlots, "s20xModelcheckGgplot2")
  expect_named(modelPlots, c("residuals", "qq", "histogram", "cooks"))
  expect_s3_class(modelPlots$residuals, "ggplot")
  expect_s3_class(modelPlots$qq, "ggplot")
  expect_s3_class(modelPlots$histogram, "ggplot")
  expect_s3_class(modelPlots$cooks, "ggplot")
})


test_that("modelcheck ggplot2 engine returns a single plot for each single diagnostic", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  residualPlot = modelcheck(fit, which = 1, engine = "ggplot2")
  normalityPlots = modelcheck(fit, which = 2, engine = "ggplot2")
  cooksPlot = modelcheck(fit, which = 3, engine = "ggplot2")

  expect_s3_class(residualPlot, "ggplot")
  expect_s3_class(normalityPlots, "s20xModelcheckGgplot2")
  expect_named(normalityPlots, c("qq", "histogram"))
  expect_s3_class(normalityPlots$qq, "ggplot")
  expect_s3_class(normalityPlots$histogram, "ggplot")
  expect_s3_class(cooksPlot, "ggplot")
})
