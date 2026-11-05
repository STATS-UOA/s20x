test_that("summary2way invisibly returns the current two-way ANOVA components", {
  rowFactor = factor(rep(c("A", "B"), each = 6))
  colFactor = factor(rep(c("C", "D", "E"), times = 4))
  response = c(4, 5, 6, 7, 8, 9, 6, 7, 8, 9, 10, 11)
  fit = lm(response ~ rowFactor + colFactor)

  printed = capture.output(
    result <- summary2way(fit, page = "table")
  )

  expect_true(length(printed) > 0)
  expect_type(result, "list")
  expect_named(
    result,
    c(
      "Df",
      "Sum of Sq",
      "Mean Sq",
      "F value",
      "Pr(F)",
      "Grand Mean",
      "Row Effects",
      "Col Effects",
      "Interaction Effects",
      "results",
      "results.identity"
    )
  )
  expect_true(is.null(result$`Interaction Effects`))
  expect_s3_class(result$results$table, "anova")
  expect_type(result$results$means, "list")
  expect_type(result$results$effects, "list")
  expect_type(result$results$comparisons, "list")
})

test_that("summary2way can return legacy-format results when new is FALSE", {
  rowFactor = factor(rep(c("A", "B"), each = 6))
  colFactor = factor(rep(c("C", "D", "E"), times = 4))
  response = c(4, 5, 6, 7, 8, 9, 6, 7, 8, 9, 10, 11)
  fit = lm(response ~ rowFactor + colFactor)

  printed = capture.output(
    result <- summary2way(fit, page = "table", new = FALSE)
  )

  expect_true(length(printed) > 0)
  expect_type(result, "list")
  expect_named(
    result,
    c(
      "Df",
      "Sum of Sq",
      "Mean Sq",
      "F value",
      "Pr(F)",
      "Grand Mean",
      "Row Effects",
      "Col Effects",
      "Interaction Effects",
      "Comparisons"
    )
  )
  expect_true(is.null(result$`Interaction Effects`))
  expect_true(is.null(result$Comparisons))
})

test_that("summary2way back-transforms nointeraction comparisons exactly once", {
  data("butterfat.df", package = "s20x", envir = environment())
  fit = lm(log(Butterfat) ~ Breed + Age, data = butterfat.df)
  tukey = TukeyHSD(aov(fit))$Breed
  rowName = rownames(tukey)[1]

  printed = capture.output(summary2way(fit, page = "nointeraction", FUN = exp))
  rowLine = printed[startsWith(trimws(printed), rowName)][1]
  values = as.numeric(strsplit(trimws(sub(rowName, "", rowLine, fixed = TRUE)), " +")[[1]])

  expect_equal(values[1:3], unname(exp(tukey[1, 1:3])), tolerance = 1e-4)
})

test_that("summary2way nointeraction comparisons are unchanged without FUN", {
  data("butterfat.df", package = "s20x", envir = environment())
  fit = lm(log(Butterfat) ~ Breed + Age, data = butterfat.df)
  tukey = TukeyHSD(aov(fit))$Breed
  rowName = rownames(tukey)[1]

  printed = capture.output(summary2way(fit, page = "nointeraction"))
  rowLine = printed[startsWith(trimws(printed), rowName)][1]
  values = as.numeric(strsplit(trimws(sub(rowName, "", rowLine, fixed = TRUE)), " +")[[1]])

  expect_equal(values[1:3], unname(tukey[1, 1:3]), tolerance = 1e-4)
})

test_that("summary2way interaction page names the first factor in its headings", {
  data("arousal.df", package = "s20x", envir = environment())

  fit = lm(arousal ~ gender * picture, data = arousal.df)
  printed = capture.output(summary2way(fit, page = "interaction"))

  expect_true(any(grepl("Comparisons within gender", printed, fixed = TRUE)))
  expect_true(any(grepl("Comparisons between gender", printed, fixed = TRUE)))
  expect_false(any(grepl("c(", printed, fixed = TRUE)))
})

test_that("summary2way interaction page handles hyphens in factor levels", {
  data("arousal.df", package = "s20x", envir = environment())

  relabelled = arousal.df
  levels(relabelled$gender)[levels(relabelled$gender) == "male"] = "m-le"

  original = capture.output(
    summary2way(lm(arousal ~ gender * picture, data = arousal.df), page = "interaction")
  )
  hyphenated = capture.output(
    summary2way(lm(arousal ~ gender * picture, data = relabelled), page = "interaction")
  )

  expect_equal(gsub("m-le", "male", hyphenated, fixed = TRUE), original)
})

test_that("summary2way interaction page handles reversed factor order", {
  data("arousal.df", package = "s20x", envir = environment())

  fit = lm(arousal ~ picture * gender, data = arousal.df)
  printed = capture.output(summary2way(fit, page = "interaction"))

  expect_true(any(grepl("Comparisons within picture", printed, fixed = TRUE)))
})
