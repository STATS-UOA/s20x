test_that("tslm falls back to lm when no AR term is supplied", {
  fit = tslm(dist ~ speed, data = cars)

  expect_s3_class(fit, "tslm")
  expect_s3_class(fit$fit, "lm")
  expect_null(fit$errorSpec)
  expect_equal(coef(fit), coef(lm(dist ~ speed, data = cars)))
})

test_that("tslm removes ar terms from the mean formula", {
  parsedFormula = s20x:::parseTslmFormula(dist ~ speed + ar(2))

  expect_equal(parsedFormula$errorSpec$type, "ar")
  expect_equal(parsedFormula$errorSpec$p, 2L)
  expect_equal(deparse(parsedFormula$meanFormula), "dist ~ speed")
})

test_that("tslm rejects unsupported future error structures", {
  expect_error(
    s20x:::parseTslmFormula(dist ~ speed + arma(1, 1)),
    "Only ar\\(p\\) error structures"
  )
})

test_that("tslm fits AR models when nlme is available", {
  skip_if_not_installed("nlme")

  data = data.frame(
    y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3),
    x = seq_len(8),
    t = seq_len(8)
  )

  fit = tslm(y ~ x + ar(1), data = data, time = t)

  expect_s3_class(fit, "tslm")
  expect_s3_class(fit$fit, "gls")
  expect_equal(fit$errorSpec$p, 1L)
  expect_equal(fit$time, "t")
})
