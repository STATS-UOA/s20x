test_that("diagnostic plotting helpers keep current argument validation", {
  values = c(1, 2, 3, 4, 5)
  group = factor(c("A", "A", "B", "B", "B"))
  fit = lm(values ~ group)

  expect_warning(
    expect_error(
      modelcheck(fit, which = 4),
      "which must be in 1:3",
      fixed = TRUE
    ),
    "modelcheck\\(\\) is deprecated"
  )
  expect_warning(
    expect_error(
      modcheck(fit, plotOrder = 5),
      "plotOrder must be in 1:4",
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


test_that("deprecated diagnostic helpers are not exported", {
  exports = getNamespaceExports("s20x")

  expect_false("modelcheck" %in% exports)
  expect_false("modcheck" %in% exports)
  expect_false("boxqq" %in% exports)
  expect_false("stripqq" %in% exports)
  expect_false("autocor.plot" %in% exports)
  expect_true("autocorPlot" %in% exports)
})
