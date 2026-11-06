makeAirpassGls = function() {
  data("airpass.df", package = "s20x", envir = environment())
  gls(log(passengers) ~ t + month, correlation = corARMA(p = 1, q = 0), data = airpass.df)
}

test_that("normcheck uses normalised residuals for gls fits by default", {
  fit = makeAirpassGls()

  plots = normcheck(fit, engine = "ggplot2")
  raw = normcheck(fit, residualType = "response", engine = "ggplot2")

  expect_s3_class(plots, "s20xNormcheck_ggplot2")
  expect_equal(plots$histogram$data$x, as.numeric(residuals(fit, type = "normalized")))
  expect_equal(raw$histogram$data$x, as.numeric(residuals(fit, type = "response")))
  expect_match(plots$histogram$labels$x, "Residuals from gls(", fixed = TRUE)
})

test_that("eovcheck uses normalised residuals for gls fits by default", {
  fit = makeAirpassGls()

  plot = eovcheck(fit, engine = "ggplot2")

  expect_s3_class(plot, "ggplot")
  expect_equal(plot$data$residuals, as.numeric(residuals(fit, type = "normalized")))
  expect_equal(plot$data$fitted, as.numeric(fitted(fit)))
  expect_identical(plot$labels$y, "Normalised residuals")
})

test_that("eovcheck draws the two sd lines on the scale of the residuals", {
  fit = makeAirpassGls()
  lineValues = function(plot) {
    plot$layers[[length(plot$layers)]]$data$yintercept
  }

  expect_equal(lineValues(eovcheck(fit, twosd = TRUE, engine = "ggplot2")), c(-2, 2))
  expect_equal(
    lineValues(eovcheck(fit, twosd = TRUE, residualType = "response", engine = "ggplot2")),
    c(-2, 2) * fit$sigma
  )
})

test_that("the base engine draws gls diagnostics", {
  fit = makeAirpassGls()
  pdf(NULL)
  on.exit(dev.off())

  expect_silent(normcheck(fit))
  expect_silent(eovcheck(fit, smoother = TRUE, twosd = TRUE))
})
