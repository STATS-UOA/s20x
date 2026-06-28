test_that("pairs20x keeps the base graphics engine as the default", {
  values = data.frame(
    first = c(1, 2, 3, 4, 5),
    second = c(2, 4, 6, 8, 10),
    third = c(5, 4, 3, 2, 1)
  )

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(pairs20x(values))
  expect_silent(pairs20x(values, engine = "base"))
})


test_that("pairs20x validates the plotting engine argument", {
  values = data.frame(
    first = c(1, 2, 3),
    second = c(3, 2, 1)
  )

  expect_error(
    pairs20x(values, engine = "lattice"),
    "'arg' should be one of",
    fixed = TRUE
  )
})


test_that("pairs20x ggplot2 engine returns a GGally plot matrix when available", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("GGally")

  values = data.frame(
    first = c(1, 2, 3, 4, 5),
    second = c(2, 4, 6, 8, 10),
    third = c(5, 4, 3, 2, 1)
  )

  plotObject = pairs20x(values, engine = "ggplot2")

  expect_s3_class(plotObject, "ggmatrix")
})


test_that("pairs20x ggplot2 engine uses base-like matrix styling", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("GGally")

  values = data.frame(
    first = c(1, 2, 3, 4, 5, 6),
    second = c(2, 4, 6, 8, 10, 12),
    third = c(5, 4, 3, 2, 1, 0)
  )

  plotObject = pairs20x(values, engine = "ggplot2")

  expect_s3_class(plotObject, "ggmatrix")
  expect_null(plotObject$columnLabels)
  expect_equal(plotObject$axisLabels, "none")
})


test_that("pairs20x ggplot2 correlation sizing keeps small correlations small", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("GGally")

  correlationPanel = getS20xInternal("pairs20x_ggplot2CorrelationPanel")
  values = data.frame(
    first = c(1, 2, 3, 4, 5, 6),
    second = c(1, 6, 2, 5, 3, 4)
  )
  aesFun = get("aes", envir = asNamespace("ggplot2"), inherits = FALSE)
  mapping = aesFun(x = first, y = second)

  panel = correlationPanel(values, mapping)
  textLayer = panel$layers[[2]]

  expect_s3_class(panel, "ggplot")
  expect_lt(textLayer$data$size, 3)
})
