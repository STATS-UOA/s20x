test_that("nzarrivals.df month uses month.abb factor levels", {
  dataEnv = new.env(parent = emptyenv())
  data("nzarrivals.df", package = "s20x", envir = dataEnv)

  nzarrivalsDf = dataEnv$nzarrivals.df

  expect_s3_class(nzarrivalsDf, "data.frame")
  expect_named(nzarrivalsDf, c("year", "month", "arrivals.count"))
  expect_true(is.factor(nzarrivalsDf$month))
  expect_identical(levels(nzarrivalsDf$month), month.abb)
})
