test_that("diagnostic plotting helpers keep current argument validation", {
  values = c(1, 2, 3, 4, 5)
  group = factor(c("A", "A", "B", "B", "B"))
  fit = lm(values ~ group)

  expect_error(
    modelcheck(fit, which = 4),
    "which must be in 1:3",
    fixed = TRUE
  )
  expect_warning(
    expect_error(
      modcheck(fit, plotOrder = 5),
      "no applicable method for 'modcheck'",
      fixed = TRUE
    ),
    "modcheck\\(\\) is deprecated"
  )
  expect_error(
    normcheck(fit, whichPlot = 3),
    "whichPlot must be in 1:2",
    fixed = TRUE
  )
  expect_error(
    eovcheck(NULL),
    "no applicable method for 'eovcheck'",
    fixed = TRUE
  )
})


test_that("diagnostic helper exports match compatibility policy", {
  exports = getNamespaceExports("s20x")

  expect_true("modelcheck" %in% exports)
  expect_false("modcheck" %in% exports)
  expect_false("boxqq" %in% exports)
  expect_false("stripqq" %in% exports)
  expect_false("autocor.plot" %in% exports)
  expect_true("autocorPlot" %in% exports)
})


test_that("internal graphics parameter helper restores plotting state", {
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  oldMar = par("mar")
  restoreGraphicsParameters = saveGraphicsParameters(mar = c(1, 1, 1, 1))

  expect_equal(par("mar"), c(1, 1, 1, 1))

  restoreGraphicsParameters()

  expect_equal(par("mar"), oldMar)
})


test_that("internal residual and fitted helper returns aligned diagnostic data", {
  values = c(1, 2, 3, 4, 5)
  group = factor(c("A", "A", "B", "B", "B"))
  fit = lm(values ~ group)

  diagnosticData = getS20xInternal("getModelResidualFittedData")(fit, context = "linear model")

  expect_named(diagnosticData, c("fitted", "residuals"))
  expect_equal(diagnosticData$fitted, fitted(fit))
  expect_equal(diagnosticData$residuals, residuals(fit))
  expect_equal(length(diagnosticData$fitted), length(diagnosticData$residuals))
})
