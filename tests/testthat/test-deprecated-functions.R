test_that("deprecated functions warn when called directly", {
  data("peru.df", package = "s20x", envir = environment())
  data("body.df", package = "s20x", envir = environment())
  data("oysters.df", package = "s20x", envir = environment())

  fit = lm(BP ~ weight, data = peru.df)
  siteFit = lm(log(Oysters) ~ Site, data = oysters.df)
  contrasts = matrix(c(1, -1, 0), nrow = 1)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_warning(ciReg(fit, print.out = FALSE), "deprecated")
  expect_warning(layout20x(1, 1), "deprecated")
  expect_warning(residPlot(fit), "deprecated")
  expect_warning(autocorPlot(fit), "deprecated")
  expect_warning(skewness(peru.df$BP), "deprecated")
  expect_warning(crossFactors(body.df$ethnicity, body.df$married), "deprecated")
  expect_warning(onewayPlot(siteFit), "deprecated")
  expect_warning(twosampPlot(siteFit), "deprecated")
  expect_warning(
    capture.output(levene.test(log(Oysters) ~ Site, data = oysters.df)),
    "deprecated"
  )
  expect_warning(
    capture.output(estimateContrasts(contrasts, siteFit)),
    "deprecated"
  )
  expect_warning(
    expect_warning(
      capture.output(crosstabs(~ ethnicity + married, data = body.df)),
      "Chi-square"
    ),
    "deprecated"
  )
  expect_warning(capture.output(freq1way(c(10, 20, 30))), "deprecated")
  expect_warning(normcheck(fit, shapiro.wilk = TRUE), "deprecated")
  expect_warning(normcheck(peru.df$BP, shapiro.wilk = TRUE), "deprecated")
})

test_that("functions still in use stay silent about deprecated helpers", {
  data("oysters.df", package = "s20x", envir = environment())
  data("butterfat.df", package = "s20x", envir = environment())

  siteFit = lm(log(Oysters) ~ Site, data = oysters.df)
  twoWayFit = lm(Butterfat ~ Breed * Age, data = butterfat.df)
  additiveFit = lm(Butterfat ~ Breed + Age, data = butterfat.df)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_no_warning(capture.output(summaryStats(oysters.df$Oysters)))
  expect_no_warning(capture.output(summary1way(siteFit)))
  expect_no_warning(capture.output(multipleComp(siteFit)))
  expect_no_warning(capture.output(summary2way(twoWayFit, page = "interaction")))
  expect_no_warning(capture.output(summary2way(twoWayFit, new = FALSE, page = "interaction")))
  expect_no_warning(capture.output(summary2way(additiveFit, new = FALSE, page = "nointeraction")))
  expect_no_warning(eovcheck(siteFit))
})

test_that("normcheck does not warn about shapiro.wilk by default", {
  data("peru.df", package = "s20x", envir = environment())

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_no_warning(normcheck(lm(BP ~ weight, data = peru.df)))
})

test_that("rowdistr accepts a two-way table", {
  data("body.df", package = "s20x", envir = environment())

  counts = table(body.df$ethnicity, body.df$married)

  expect_no_error(capture.output(rowdistr(counts, plot = FALSE)))
})
