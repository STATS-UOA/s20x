test_that("normcheck keeps the base graphics engine as the default", {
  values = c(-2, -1, 0, 1, 2)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(normcheck(values))
  expect_silent(normcheck(values, engine = "base"))
})


test_that("normcheck validates the plotting engine argument", {
  values = c(-2, -1, 0, 1, 2)

  expect_error(
    normcheck(values, engine = "lattice"),
    "'arg' should be one of",
    fixed = TRUE
  )
})


test_that("normcheck ggplot2 engine returns ggplot objects when available", {
  skip_if_not_installed("ggplot2")

  values = c(-2, -1, 0, 1, 2)

  qqPlot = normcheck(values, engine = "ggplot2", whichPlot = 1)
  bothPlots = normcheck(values, engine = "ggplot2", whichPlot = 1:2)

  expect_s3_class(qqPlot, "ggplot")
  expect_s3_class(bothPlots, "s20xNormcheck_ggplot2")
  expect_length(bothPlots, 2)
})


test_that("normcheck lm method passes engine and bootstrap arguments", {
  skip_if_not_installed("ggplot2")

  sampleData = data.frame(
    response = c(1, 2, 3, 4, 5),
    predictor = c(1, 2, 3, 4, 5)
  )
  fit = lm(response ~ predictor, data = sampleData)

  plotObject = normcheck(fit, engine = "ggplot2", whichPlot = 1, bootstrap = TRUE, B = 1)

  expect_s3_class(plotObject, "ggplot")
})


test_that("normcheck ggplot2 engine uses a base-like theme", {
  skip_if_not_installed("ggplot2")

  values = c(-2, -1, 0, 1, 2)

  bothPlots = normcheck(values, engine = "ggplot2", whichPlot = 1:2)

  expect_true(inherits(bothPlots$qq$theme$panel.grid.major, "element_blank"))
  expect_true(inherits(bothPlots$histogram$theme$panel.grid.major, "element_blank"))
})


test_that("normcheck labels a vector histogram from the call", {
  data("peru.df", package = "s20x", envir = environment())

  plotLabels = NULL
  local_mocked_bindings(normcheckBase = function(x, xlab, ...) {
    plotLabels <<- xlab
    invisible(NULL)
  })

  normcheck(peru.df$BP)

  expect_equal(plotLabels[2], "peru.df$BP")
})

test_that("normcheck accepts any colour R can draw with", {
  data("peru.df", package = "s20x", envir = environment())

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(normcheck(peru.df$BP, col = "#336699"))
  expect_silent(normcheck(peru.df$BP, col = 2))
  expect_silent(normcheck(peru.df$BP, bootstrap = TRUE, bcol = "#336699"))
  expect_silent(normcheck(peru.df$BP, col = "light blue"))
  expect_silent(normcheck(peru.df$BP, col = "lightgreen"))
  expect_error(normcheck(peru.df$BP, col = "notAColour"), "not a valid colour")
})

test_that("normcheck ggplot2 engine accepts hex and palette colours", {
  skip_if_not_installed("ggplot2")
  data("peru.df", package = "s20x", envir = environment())

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_no_error(print(normcheck(peru.df$BP, col = "#336699", engine = "ggplot2")))
  expect_no_error(print(normcheck(peru.df$BP, col = 2, engine = "ggplot2")))
})

test_that("normcheck uses the base engine unless asked otherwise", {
  data("peru.df", package = "s20x", envir = environment())

  local_mocked_bindings(normcheck_ggplot2 = function(...) {
    stop("the ggplot2 engine should not be used by default")
  })

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_no_error(normcheck(peru.df$BP))
  expect_no_error(normcheck(lm(BP ~ weight, data = peru.df)))
})
