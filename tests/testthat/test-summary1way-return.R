test_that("summary1way invisibly returns the current one-way ANOVA components", {
  group = factor(rep(c("A", "B", "C"), each = 3))
  response = c(4, 5, 6, 7, 8, 9, 10, 11, 12)
  fit = lm(response ~ group)

  printed = capture.output(
    result <- summary1way(fit, print.out = TRUE, draw.plot = FALSE)
  )

  expect_true(length(printed) > 0)
  expect_type(result, "list")
  expect_named(
    result,
    c("Df", "Sum of Sq", "Mean Sq", "F value", "Pr(F)", "Main Effect", "Group Effects")
  )
  expect_equal(result$Df, c(2, 6, 8))
  expect_equal(result$`Main Effect`, mean(response))
  expect_equal(length(result$`Group Effects`), nlevels(group))
})

test_that("summary1way can suppress printed output and plotting while preserving returns", {
  group = factor(rep(c("A", "B"), each = 4))
  response = c(1, 2, 3, 4, 3, 4, 5, 6)
  fit = lm(response ~ group)

  printed = capture.output(
    result <- summary1way(fit, print.out = FALSE, draw.plot = FALSE)
  )

  expect_equal(printed, character())
  expect_type(result, "list")
  expect_named(
    result,
    c("Df", "Sum of Sq", "Mean Sq", "F value", "Pr(F)", "Main Effect", "Group Effects")
  )
})
