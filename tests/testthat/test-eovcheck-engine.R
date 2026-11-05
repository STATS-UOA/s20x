test_that("eovcheck keeps the base graphics engine as the default", {
  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(eovcheck(fit))
  expect_silent(eovcheck(fit, engine = "base"))
})


test_that("eovcheck validates the plotting engine argument", {
  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  expect_error(
    eovcheck(fit, engine = "lattice"),
    "'arg' should be one of",
    fixed = TRUE
  )
})


test_that("eovcheck ggplot2 engine returns a ggplot object when available", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  plotObject = eovcheck(fit, engine = "ggplot2", smoother = TRUE, twosd = TRUE)

  expect_s3_class(plotObject, "ggplot")
})


test_that("eovcheck formula method passes engine and Levene arguments", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1, 2, 2, 3, 4, 4, 5, 6),
    group = factor(rep(c("a", "b"), each = 4))
  )

  plotObject = eovcheck(response ~ group, data = sampleData, engine = "ggplot2", levene = TRUE)

  expect_s3_class(plotObject, "ggplot")
})


test_that("eovcheck ggplot2 engine prints without aesthetic mapping warnings", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7, 7.1, 8.2),
    predictor = c(1, 2, 3, 4, 5, 6, 7, 8)
  )
  fit = lm(response ~ predictor, data = sampleData)

  plotObject = eovcheck(fit, engine = "ggplot2")

  expect_s3_class(plotObject, "ggplot")
  expect_silent(print(plotObject))
})


test_that("eovcheck ggplot2 engine uses base-like theme and thin two sd lines", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7, 7.1, 8.2),
    predictor = c(1, 2, 3, 4, 5, 6, 7, 8)
  )
  fit = lm(response ~ predictor, data = sampleData)

  plotObject = eovcheck(fit, engine = "ggplot2", twosd = TRUE)
  hlineLayers = plotObject$layers[vapply(plotObject$layers, function(layer) {
    inherits(layer$geom, "GeomHline")
  }, logical(1))]
  lineWidths = vapply(hlineLayers, function(layer) {
    layer$aes_params$linewidth
  }, numeric(1))

  expect_true(inherits(plotObject$theme$panel.grid.major, "element_blank"))
  expect_true(inherits(plotObject$theme$panel.background, "element_rect"))
  expect_true(any(lineWidths <= 0.5))
})


test_that("eovcheck lm method respects subset in the fitted model", {
  data("peru.df", package = "s20x", envir = environment())
  skip_if_not_installed("ggplot2")

  fit = lm(BP ~ weight, data = peru.df, subset = age > 25)
  plotObject = eovcheck(fit, engine = "ggplot2")

  expect_lt(nobs(fit), nrow(peru.df))
  expect_equal(nrow(plotObject$data), nobs(fit))
  expect_equal(sort(plotObject$data[[2]]), sort(unname(residuals(fit))))
})

test_that("eovcheck lm method works without a data argument", {
  data("peru.df", package = "s20x", envir = environment())
  x = peru.df$weight
  y = peru.df$BP
  fit = lm(y ~ x)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(eovcheck(fit))
})

test_that("eovcheck lm method works with a stored formula", {
  data("peru.df", package = "s20x", envir = environment())
  storedFormula = BP ~ weight
  fit = lm(storedFormula, data = peru.df)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(eovcheck(fit))
})

test_that("eovcheck lm and formula methods agree on Levene's test", {
  data("butterfat.df", package = "s20x", envir = environment())
  skip_if_not_installed("ggplot2")

  fit = lm(Butterfat ~ Breed, data = butterfat.df)
  lmPlot = eovcheck(fit, levene = TRUE, engine = "ggplot2")
  formulaPlot = eovcheck(Butterfat ~ Breed, data = butterfat.df, levene = TRUE, engine = "ggplot2")

  expect_equal(lmPlot$data, formulaPlot$data)
  expect_equal(
    length(lmPlot$layers),
    length(formulaPlot$layers)
  )
})

test_that("eovcheck does not treat lm weights as a covariate for Levene's test", {
  data("butterfat.df", package = "s20x", envir = environment())
  skip_if_not_installed("ggplot2")

  unweightedFit = lm(Butterfat ~ Breed, data = butterfat.df)
  weightedFit = lm(Butterfat ~ Breed, data = butterfat.df, weights = Butterfat)

  expect_equal(
    length(eovcheck(weightedFit, levene = TRUE, engine = "ggplot2")$layers),
    length(eovcheck(unweightedFit, levene = TRUE, engine = "ggplot2")$layers)
  )
})

test_that("eovcheck still checks glm fits with least squares residuals", {
  data("peru.df", package = "s20x", envir = environment())
  skip_if_not_installed("ggplot2")

  glmFit = glm(BP ~ weight, data = peru.df, family = gaussian(link = "log"))
  lmFit = lm(BP ~ weight, data = peru.df)
  plotObject = eovcheck(glmFit, engine = "ggplot2")

  expect_equal(unname(plotObject$data[[2]]), unname(residuals(lmFit)))
})

test_that("eovcheck draws two sd lines for aov fits", {
  skip_if_not_installed("ggplot2")
  data("butterfat.df", package = "s20x", envir = environment())

  aovFit = aov(Butterfat ~ Breed, data = butterfat.df)
  lmFit = lm(Butterfat ~ Breed, data = butterfat.df)

  expect_equal(sigma(aovFit), summary(lmFit)$sigma)
  expect_equal(
    length(eovcheck(aovFit, twosd = TRUE, engine = "ggplot2")$layers),
    length(eovcheck(lmFit, twosd = TRUE, engine = "ggplot2")$layers)
  )

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(eovcheck(aovFit, twosd = TRUE))
})

test_that("eovcheck Levene option does not change the plotted residuals", {
  skip_if_not_installed("ggplot2")
  data("soyabean.df", package = "s20x", envir = environment())

  fit = lm(yield ~ planttime + cultivar, data = soyabean.df)
  plain = eovcheck(yield ~ planttime + cultivar, data = soyabean.df, engine = "ggplot2")
  withLevene = eovcheck(
    yield ~ planttime + cultivar,
    data = soyabean.df,
    levene = TRUE,
    engine = "ggplot2"
  )

  expect_equal(withLevene$data, plain$data)
  expect_equal(unname(withLevene$data[[2]]), unname(residuals(fit)))
  expect_gt(length(withLevene$layers), length(plain$layers))
  expect_equal(eovcheck(fit, levene = TRUE, engine = "ggplot2")$data, plain$data)
})
