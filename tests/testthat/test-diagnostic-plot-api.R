test_that("diagnostic plotting helpers keep current argument validation", {
  values = c(1, 2, 3, 4, 5)
  group = factor(c("A", "A", "B", "B", "B"))
  fit = lm(values ~ group)

  expect_error(
    modelcheck(fit, which = 4),
    "which must be in 1:3",
    fixed = TRUE
  )
  expect_error(
    modcheck(fit, plotOrder = 5),
    "plotOrder must be in 1:4",
    fixed = TRUE
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
