test_that("modelcheck keeps the base graphics engine as the default", {
  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(modelcheck(fit))
  expect_silent(modelcheck(fit, engine = "base"))
})


test_that("modelcheck validates the plotting engine argument", {
  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  expect_error(
    modelcheck(fit, engine = "lattice"),
    "'arg' should be one of",
    fixed = TRUE
  )
})


test_that("modelcheck ggplot2 engine returns ggplot objects when available", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7),
    predictor = c(1, 2, 3, 4, 5, 6)
  )
  fit = lm(response ~ predictor, data = sampleData)

  residualPlot = modelcheck(fit, which = 1, engine = "ggplot2")
  allPlots = modelcheck(fit, engine = "ggplot2")

  expect_s3_class(residualPlot, "ggplot")
  expect_s3_class(allPlots, "s20xModelcheck_ggplot2")
  expect_named(allPlots, c("residuals", "qq", "histogram", "cooks"))
  expect_s3_class(allPlots$residuals, "ggplot")
  expect_s3_class(allPlots$qq, "ggplot")
  expect_s3_class(allPlots$histogram, "ggplot")
  expect_s3_class(allPlots$cooks, "ggplot")
})


test_that("modelcheck ggplot2 engine prints without aesthetic mapping warnings", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7, 7.1, 8.2),
    predictor = c(1, 2, 3, 4, 5, 6, 7, 8)
  )
  fit = lm(response ~ predictor, data = sampleData)

  plotObject = modelcheck(fit, engine = "ggplot2")

  expect_s3_class(plotObject, "s20xModelcheck_ggplot2")
  expect_silent(print(plotObject))
})


test_that("modelcheck ggplot2 engine uses base-like theme and Cook vertical lines", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1.1, 1.9, 3.2, 3.8, 5.3, 5.7, 7.1, 8.2),
    predictor = c(1, 2, 3, 4, 5, 6, 7, 8)
  )
  fit = lm(response ~ predictor, data = sampleData)

  allPlots = modelcheck(fit, engine = "ggplot2")
  layerGeoms = vapply(allPlots$cooks$layers, function(layer) {
    class(layer$geom)[1]
  }, character(1))

  expect_true(inherits(allPlots$residuals$theme$panel.grid.major, "element_blank"))
  expect_true(inherits(allPlots$qq$theme$panel.grid.major, "element_blank"))
  expect_true(inherits(allPlots$histogram$theme$panel.grid.major, "element_blank"))
  expect_true(inherits(allPlots$cooks$theme$panel.grid.major, "element_blank"))
  expect_true("GeomSegment" %in% layerGeoms)
  expect_false("GeomLine" %in% layerGeoms)
})
