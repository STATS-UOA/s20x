test_that("summaryStats invisibly returns the single-variable summary list", {
  values = c(1, 2, 3, 4)

  printed = capture.output(result <- summaryStats(values))

  expect_true(length(printed) > 0)
  expect_type(result, "list")
  expect_named(
    result,
    c("min", "max", "mean", "var", "sd", "n", "iqr", "skewness", "lq", "median", "uq")
  )
  expect_equal(result$mean, mean(values))
  expect_equal(result$n, length(values))
})

test_that("summaryStats invisibly returns a grouped summary data frame", {
  values = c(1, 2, 10, 20)
  group = c("A", "A", "B", "B")

  printed = capture.output(result <- summaryStats(values, group = group))

  expect_true(length(printed) > 0)
  expect_s3_class(result, "data.frame")
  expect_equal(rownames(result), c("A", "B"))
  expect_named(
    result,
    c("min", "max", "mean", "var", "sd", "n", "iqr", "skewness", "lq", "median", "uq")
  )
  expect_equal(result$mean, c(A = 1.5, B = 15), ignore_attr = TRUE)
})
