test_that("eovcheck keeps the base graphics engine as the default", {
  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(eovcheck(fit))
  expect_silent(eovcheck(fit, engine = "base"))
})


test_that("eovcheck validates the plotting engine argument", {
  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  expect_error(
    eovcheck(fit, engine = "lattice"),
    "'arg' should be one of",
    fixed = TRUE
  )
})


test_that("eovcheck ggplot2 engine returns a ggplot object when available", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  plotObject = eovcheck(fit, engine = "ggplot2", smoother = TRUE, twosd = TRUE)

  expect_s3_class(plotObject, "ggplot")
})


test_that("eovcheck formula method passes engine and Levene arguments", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1, 2, 2, 3, 4, 4, 5, 6),
    group = factor(rep(c("a", "b"), each = 4))
  )

  plotObject = eovcheck(response ~ group, data = sampleData, engine = "ggplot2", levene = TRUE)

  expect_s3_class(plotObject, "ggplot")
})
