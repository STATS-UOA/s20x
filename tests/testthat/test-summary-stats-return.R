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

test_that("summaryStats accepts na.action for grouped data", {
  data("butterfat.df", package = "s20x", envir = environment())

  withMissing = butterfat.df
  withMissing$Butterfat[1] = NA
  printed = capture.output(
    result <- summaryStats(Butterfat ~ Breed, data = withMissing, na.action = na.omit)
  )

  firstBreed = as.character(butterfat.df$Breed[1])
  remaining = withMissing$Butterfat[withMissing$Breed == firstBreed]

  expect_equal(result[firstBreed, "mean"], mean(remaining, na.rm = TRUE))
  expect_equal(result[firstBreed, "n"], sum(!is.na(remaining)))
})

test_that("summaryStats still passes na.rm to the summaries for grouped data", {
  data("butterfat.df", package = "s20x", envir = environment())

  withMissing = butterfat.df
  withMissing$Butterfat[1] = NA
  printed = capture.output(
    result <- summaryStats(Butterfat ~ Breed, data = withMissing, na.rm = TRUE)
  )

  firstBreed = as.character(butterfat.df$Breed[1])
  remaining = withMissing$Butterfat[withMissing$Breed == firstBreed]

  expect_equal(result[firstBreed, "mean"], mean(remaining, na.rm = TRUE))
  expect_equal(result[firstBreed, "nMissing"], 1)
})

test_that("summaryStats accepts na.action for a single group", {
  data("peru.df", package = "s20x", envir = environment())

  printed = capture.output(result <- summaryStats(peru.df$BP, na.action = na.omit))

  expect_equal(result$mean, mean(peru.df$BP))
})
