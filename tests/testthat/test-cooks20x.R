test_that("cooks20x accepts partial axis options", {
  data("peru.df", package = "s20x", envir = environment())

  fit = lm(BP ~ age + weight, data = peru.df)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(cooks20x(fit))
  expect_silent(cooks20x(fit, axisOpts = list(xAxis = FALSE)))
  expect_silent(cooks20x(fit, axisOpts = list(yAxisTight = TRUE)))
})
