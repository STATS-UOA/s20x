test_that("crosstabs invisibly returns the current ct.20x object", {
  counts = matrix(c(12, 8, 5, 15), nrow = 2, byrow = TRUE)
  rownames(counts) = c("A", "B")
  colnames(counts) = c("Yes", "No")
  names(dimnames(counts)) = c("group", "response")
  testData = as.data.frame(as.table(counts))
  names(testData) = c("group", "response", "count")
  expandedData = testData[rep(seq_len(nrow(testData)), testData$count), ]

  result = expect_silent(capture.output(
    crosstabs(~ group + response, data = expandedData)
  ))

  result = withVisible(crosstabs(~ group + response, data = expandedData))

  expect_false(result$visible)
  expect_s3_class(result$value, "ct.20x")
  expect_named(
    result$value,
    c("row.props", "col.props", "whole.props", "Totals", "exp", "chi")
  )
  expect_equal(unclass(result$value$Totals[1:2, 1:2]), counts)
  expect_equal(rowSums(result$value$row.props), c(A = 1, B = 1))
  expect_equal(sum(result$value$whole.props), 1)
})

test_that("rowdistr invisibly returns row proportions when text is printed", {
  counts = matrix(c(12, 8, 5, 15), nrow = 2, byrow = TRUE)
  rownames(counts) = c("A", "B")
  colnames(counts) = c("Yes", "No")

  rowResult = NULL
  result = withVisible(capture.output({
    rowResult = rowdistr(counts, plot = FALSE)
  }))

  expect_true(result$visible)
  expect_equal(rowSums(rowResult), c(A = 1, B = 1))
  expect_equal(rowResult, sweep(counts, 1, rowSums(counts), "/"))
})

test_that("rowdistr invisibly returns NULL when text is suppressed", {
  counts = matrix(c(12, 8, 5, 15), nrow = 2, byrow = TRUE)
  rownames(counts) = c("A", "B")
  colnames(counts) = c("Yes", "No")

  result = withVisible(rowdistr(counts, plot = FALSE, suppressText = TRUE))

  expect_false(result$visible)
  expect_null(result$value)
})
