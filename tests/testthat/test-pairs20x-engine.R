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
