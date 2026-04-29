test_that("nzalc.df has teaching-friendly factor ordering", {
  data("nzalc.df", package = "s20x")

  expect_s3_class(nzalc.df, "data.frame")
  expect_true(is.factor(nzalc.df$month))
  expect_equal(levels(nzalc.df$month), c("Mar", "Jun", "Sep", "Dec"))
  expect_true(is.factor(nzalc.df$category))
  expect_equal(
    levels(nzalc.df$category),
    c("Total beer", "Total wine", "Total spirits")
  )
})
