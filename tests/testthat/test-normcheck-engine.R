test_that("normcheck keeps the base graphics engine as the default", {
  values = c(-2, -1, 0, 1, 2)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(normcheck(values))
  expect_silent(normcheck(values, engine = "base"))
})


test_that("normcheck validates the plotting engine argument", {
  values = c(-2, -1, 0, 1, 2)

  expect_error(
    normcheck(values, engine = "lattice"),
    "'arg' should be one of",
    fixed = TRUE
  )
})


test_that("normcheck ggplot2 engine returns ggplot objects when available", {
  skip_if_not_installed("ggplot2")

  values = c(-2, -1, 0, 1, 2)

  qqPlot = normcheck(values, engine = "ggplot2", whichPlot = 1)
  bothPlots = normcheck(values, engine = "ggplot2", whichPlot = 1:2)

  expect_s3_class(qqPlot, "ggplot")
  expect_s3_class(bothPlots, "s20xNormcheckGgplot2")
  expect_length(bothPlots, 2)
})


test_that("normcheck lm method passes engine and bootstrap arguments", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1, 2, 3, 4, 5),
    predictor = c(1, 2, 3, 4, 5)
  )
  fit = lm(response ~ predictor, data = sampleData)

  plotObject = normcheck(fit, engine = "ggplot2", whichPlot = 1, bootstrap = TRUE, B = 1)

  expect_s3_class(plotObject, "ggplot")
})
