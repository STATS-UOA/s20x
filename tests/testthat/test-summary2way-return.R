test_that("summary2way invisibly returns the current two-way ANOVA components", {
  rowFactor = factor(rep(c("A", "B"), each = 6))
  colFactor = factor(rep(c("C", "D", "E"), times = 4))
  response = c(4, 5, 6, 7, 8, 9, 6, 7, 8, 9, 10, 11)
  fit = lm(response ~ rowFactor + colFactor)

  printed = capture.output(
    result <- summary2way(fit, page = "table")
  )

  expect_true(length(printed) > 0)
  expect_type(result, "list")
  expect_named(
    result,
    c(
      "Df",
      "Sum of Sq",
      "Mean Sq",
      "F value",
      "Pr(F)",
      "Grand Mean",
      "Row Effects",
      "Col Effects",
      "Interaction Effects",
      "results",
      "results.identity"
    )
  )
  expect_true(is.null(result$`Interaction Effects`))
  expect_s3_class(result$results$table, "anova")
  expect_type(result$results$means, "list")
  expect_type(result$results$effects, "list")
  expect_type(result$results$comparisons, "list")
})

test_that("summary2way can return legacy-format results when new is FALSE", {
  rowFactor = factor(rep(c("A", "B"), each = 6))
  colFactor = factor(rep(c("C", "D", "E"), times = 4))
  response = c(4, 5, 6, 7, 8, 9, 6, 7, 8, 9, 10, 11)
  fit = lm(response ~ rowFactor + colFactor)

  printed = capture.output(
    result <- summary2way(fit, page = "table", new = FALSE)
  )

  expect_true(length(printed) > 0)
  expect_type(result, "list")
  expect_named(
    result,
    c(
      "Df",
      "Sum of Sq",
      "Mean Sq",
      "F value",
      "Pr(F)",
      "Grand Mean",
      "Row Effects",
      "Col Effects",
      "Interaction Effects",
      "Comparisons"
    )
  )
  expect_true(is.null(result$`Interaction Effects`))
  expect_true(is.null(result$Comparisons))
})
