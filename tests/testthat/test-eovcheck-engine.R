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
  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  plotObject = eovcheck(fit, engine = "ggplot2", smoother = TRUE, twosd = TRUE)

  expect_s3_class(plotObject, "ggplot")
})


test_that("eovcheck formula method passes the engine argument", {
  sampleData = data.frame(
    response = c(1, 2, 2, 3, 4, 4, 5, 6),
    group = factor(rep(c("a", "b"), each = 4))
  )

  plotObject = eovcheck(response ~ group, data = sampleData, engine = "ggplot2")

  expect_s3_class(plotObject, "ggplot")
})


test_that("eovcheck ggplot2 engine prints without aesthetic mapping warnings", {
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

test_that("eovcheck lm and formula methods draw the same data", {
  data("butterfat.df", package = "s20x", envir = environment())

  fit = lm(Butterfat ~ Breed, data = butterfat.df)

  expect_equal(
    eovcheck(fit, engine = "ggplot2")$data,
    eovcheck(Butterfat ~ Breed, data = butterfat.df, engine = "ggplot2")$data
  )
})

test_that("eovcheck plots the residuals of a weighted fit", {
  data("butterfat.df", package = "s20x", envir = environment())

  fit = lm(Butterfat ~ Breed, data = butterfat.df, weights = Butterfat)
  plotObject = eovcheck(fit, engine = "ggplot2")

  expect_equal(unname(plotObject$data[[2]]), unname(residuals(fit)))
})

test_that("eovcheck still checks glm fits with least squares residuals", {
  data("peru.df", package = "s20x", envir = environment())
  glmFit = glm(BP ~ weight, data = peru.df, family = gaussian(link = "log"))
  lmFit = lm(BP ~ weight, data = peru.df)
  plotObject = eovcheck(glmFit, engine = "ggplot2")

  expect_equal(unname(plotObject$data[[2]]), unname(residuals(lmFit)))
})

test_that("eovcheck ggplot2 engine puts two sd lines at two residual standard errors", {
  data("butterfat.df", package = "s20x", envir = environment())

  lmFit = lm(Butterfat ~ Breed, data = butterfat.df)
  aovFit = aov(Butterfat ~ Breed, data = butterfat.df)
  expected = sort(c(0, -2, 2) * summary(lmFit)$sigma)

  linePositions = function(plotObject) {
    hlineLayers = plotObject$layers[vapply(plotObject$layers, function(layer) {
      inherits(layer$geom, "GeomHline")
    }, logical(1))]
    sort(unlist(lapply(hlineLayers, function(layer) {
      layer$data$yintercept
    }), use.names = FALSE))
  }

  expect_equal(linePositions(eovcheck(lmFit, twosd = TRUE, engine = "ggplot2")), expected)
  expect_equal(linePositions(eovcheck(aovFit, twosd = TRUE, engine = "ggplot2")), expected)
})

test_that("eovcheck base engine puts two sd lines at two residual standard errors", {
  data("butterfat.df", package = "s20x", envir = environment())

  lmFit = lm(Butterfat ~ Breed, data = butterfat.df)
  aovFit = aov(Butterfat ~ Breed, data = butterfat.df)
  expected = c(-2, 2) * summary(lmFit)$sigma

  linePositions = list()
  local_mocked_bindings(abline = function(h = NULL, ...) {
    linePositions[[length(linePositions) + 1]] <<- h
    invisible(NULL)
  })

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  eovcheck(lmFit, twosd = TRUE)
  eovcheck(aovFit, twosd = TRUE)

  expect_equal(linePositions[[2]], expected)
  expect_equal(linePositions[[4]], expected)
})

test_that("eovcheck ignores the removed levene argument with a clear warning", {
  data("soyabean.df", package = "s20x", envir = environment())

  fit = lm(yield ~ planttime + cultivar, data = soyabean.df)
  plain = eovcheck(fit, engine = "ggplot2")

  expect_warning(
    withLevene <- eovcheck(fit, levene = TRUE, engine = "ggplot2"),
    "has been removed"
  )
  expect_warning(
    eovcheck(yield ~ planttime + cultivar, data = soyabean.df, levene = TRUE, engine = "ggplot2"),
    "has been removed"
  )

  expect_equal(withLevene$data, plain$data)
  expect_length(withLevene$layers, length(plain$layers))

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_warning(eovcheck(fit, levene = TRUE), "has been removed")
})

test_that("eovcheck needs an explanatory variable", {
  data("peru.df", package = "s20x", envir = environment())

  expect_error(eovcheck(lm(BP ~ 1, data = peru.df)), "at least two variables")
  expect_error(eovcheck(BP ~ 1, data = peru.df), "at least two variables")
})

test_that("eovcheck base engine uses col for the smoother", {
  data("peru.df", package = "s20x", envir = environment())

  smootherColours = character()
  local_mocked_bindings(lines = function(x, ..., col) {
    smootherColours <<- c(smootherColours, col)
    invisible(NULL)
  })

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  fit = lm(BP ~ weight, data = peru.df)
  eovcheck(fit, smoother = TRUE, col = "red")
  eovcheck(fit, smoother = TRUE)

  expect_equal(smootherColours, c("red", "lightblue"))
})

test_that("eovcheck uses the base engine unless asked otherwise", {
  data("peru.df", package = "s20x", envir = environment())

  local_mocked_bindings(eovcheck_ggplot2 = function(...) {
    stop("the ggplot2 engine should not be used by default")
  })

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_null(eovcheck(lm(BP ~ weight, data = peru.df)))
  expect_null(eovcheck(BP ~ weight, data = peru.df))
})
