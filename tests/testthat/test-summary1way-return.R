test_that("summary1way invisibly returns the current one-way ANOVA components", {
  group = factor(rep(c("A", "B", "C"), each = 3))
  response = c(4, 5, 6, 7, 8, 9, 10, 11, 12)
  fit = lm(response ~ group)

  printed = capture.output(
    result <- summary1way(fit, print.out = TRUE, draw.plot = FALSE)
  )

  expect_true(length(printed) > 0)
  expect_type(result, "list")
  expect_named(
    result,
    c("Df", "Sum of Sq", "Mean Sq", "F value", "Pr(F)", "Main Effect", "Group Effects")
  )
  expect_equal(result$Df, c(2, 6, 8))
  expect_equal(result$`Main Effect`, mean(response))
  expect_equal(length(result$`Group Effects`), nlevels(group))
})

test_that("summary1way can suppress printed output and plotting while preserving returns", {
  group = factor(rep(c("A", "B"), each = 4))
  response = c(1, 2, 3, 4, 3, 4, 5, 6)
  fit = lm(response ~ group)

  printed = capture.output(
    result <- summary1way(fit, print.out = FALSE, draw.plot = FALSE)
  )

  expect_equal(printed, character())
  expect_type(result, "list")
  expect_named(
    result,
    c("Df", "Sum of Sq", "Mean Sq", "F value", "Pr(F)", "Main Effect", "Group Effects")
  )
})

test_that("onewayPlot lm method uses the plotting options it is given", {
    data("oysters.df", package = "s20x", envir = environment())
    oysters.df$Site = factor(oysters.df$Site)
    fit = lm(log(Oysters) ~ Site, data = oysters.df)

    pdf(NULL)
    on.exit(dev.off(), add = TRUE)

    lmOutput = capture.output(
        onewayPlot(fit, conf.level = 0.9, interval.type = "lsd", pooled = FALSE, verbose = TRUE)
    )
    formulaOutput = capture.output(
        onewayPlot(
            log(Oysters) ~ Site,
            data = oysters.df,
            conf.level = 0.9,
            interval.type = "lsd",
            pooled = FALSE,
            verbose = TRUE
        )
    )

    expect_true(any(grepl("LSD intervals (90%, unpooled SDs)", lmOutput, fixed = TRUE)))
    expect_equal(lmOutput, formulaOutput)
})

test_that("onewayPlot lm method keeps its default intervals", {
    data("oysters.df", package = "s20x", envir = environment())
    oysters.df$Site = factor(oysters.df$Site)
    fit = lm(log(Oysters) ~ Site, data = oysters.df)

    pdf(NULL)
    on.exit(dev.off(), add = TRUE)

    expect_silent(onewayPlot(fit))
    expect_true(any(grepl(
        "TUKEY intervals (95%, pooled SDs)",
        capture.output(onewayPlot(fit, verbose = TRUE)),
        fixed = TRUE
    )))
})

test_that("summary1way passes its interval options to the plot", {
    data("oysters.df", package = "s20x", envir = environment())
    oysters.df$Site = factor(oysters.df$Site)
    fit = lm(log(Oysters) ~ Site, data = oysters.df)

    plotArguments = NULL
    local_mocked_bindings(onewayPlot = function(x, ...) {
        plotArguments <<- list(...)
        invisible(NULL)
    })

    summary1way(fit, conf.level = 0.9, inttype = "lsd", pooled = FALSE, print.out = FALSE)

    expect_equal(plotArguments$conf.level, 0.9)
    expect_equal(plotArguments$interval.type, "lsd")
    expect_false(plotArguments$pooled)
})

test_that("summary1way handles a transformed factor term", {
    data("computer.df", package = "s20x", envir = environment())

    fit = lm(score ~ factor(selfassess), data = computer.df)

    pdf(NULL)
    on.exit(dev.off(), add = TRUE)

    result = summary1way(fit, print.out = FALSE)
    groupMeans = tapply(computer.df$score, computer.df$selfassess, mean)

    expect_equal(
        unname(result$`Group Effects`),
        as.numeric(groupMeans - mean(computer.df$score))
    )
    expect_named(result$`Group Effects`, as.character(seq_along(groupMeans)))
})

test_that("summary1way group effects are unchanged for a factor variable", {
    data("oysters.df", package = "s20x", envir = environment())

    fit = lm(log(Oysters) ~ Site, data = oysters.df)
    result = summary1way(fit, print.out = FALSE, draw.plot = FALSE)
    siteRows = data.frame(Site = levels(oysters.df$Site))

    expect_equal(
        result$`Group Effects`,
        predict(fit, newdata = siteRows) - mean(log(oysters.df$Oysters))
    )
})

test_that("onewayPlot works on vectors and labels the plot from the call", {
    data("oysters.df", package = "s20x", envir = environment())

    pdf(NULL)
    on.exit(dev.off(), add = TRUE)

    printed = capture.output(onewayPlot(oysters.df$Oysters, oysters.df$Site, verbose = TRUE))

    expect_true(any(grepl("`oysters.df$Oysters'", printed, fixed = TRUE)))
    expect_true(any(grepl("`oysters.df$Site'", printed, fixed = TRUE)))
    expect_true(any(startsWith(printed, "GR: mean = ")))
})

test_that("onewayPlot vector interface accepts a character grouping variable", {
    data("oysters.df", package = "s20x", envir = environment())

    pdf(NULL)
    on.exit(dev.off(), add = TRUE)

    siteLabels = as.character(oysters.df$Site)
    printed = capture.output(onewayPlot(oysters.df$Oysters, siteLabels, verbose = TRUE))

    expect_true(any(startsWith(printed, "PS2: mean = ")))
})

test_that("summary1way results match anova and the group means", {
    data("oysters.df", package = "s20x", envir = environment())

    fit = lm(log(Oysters) ~ Site, data = oysters.df)
    result = summary1way(fit, print.out = FALSE, draw.plot = FALSE)
    anovaTable = anova(fit)
    response = log(oysters.df$Oysters)

    expect_equal(result$Df, c(anovaTable$Df, sum(anovaTable$Df)))
    expect_equal(result$`Sum of Sq`, round(c(anovaTable$`Sum Sq`, sum(anovaTable$`Sum Sq`)), 5))
    expect_equal(result$`Mean Sq`, round(anovaTable$`Mean Sq`, 5))
    expect_equal(result$`F value`, anovaTable$`F value`[1])
    expect_equal(result$`Pr(F)`, anovaTable$`Pr(>F)`[1])
    expect_equal(result$`Main Effect`, mean(response))
    expect_equal(
        unname(result$`Group Effects`),
        as.numeric(tapply(response, oysters.df$Site, mean) - mean(response))
    )
})
