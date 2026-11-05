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

test_that("summary2way print.out = FALSE prints nothing but still returns", {
  data("arousal.df", package = "s20x", envir = environment())

  fit = lm(arousal ~ gender * picture, data = arousal.df)

  for (page in c("table", "means", "effects", "interaction", "nointeraction")) {
    printed = capture.output(result <- summary2way(fit, page = page, print.out = FALSE))
    expect_length(printed, 0)
    expect_equal(result$Df, anova(fit)$Df)
  }
})

test_that("summary2way still stops for a missing interaction when not printing", {
  data("butterfat.df", package = "s20x", envir = environment())

  fit = lm(Butterfat ~ Breed + Age, data = butterfat.df)

  expect_error(
    summary2way(fit, page = "interaction", print.out = FALSE),
    "No interaction term in model"
  )
})

test_that("summary2way results match anova and the cell means", {
  data("arousal.df", package = "s20x", envir = environment())

  fit = lm(arousal ~ gender * picture, data = arousal.df)
  capture.output(result <- summary2way(fit, page = "table"))
  anovaTable = anova(fit)

  expect_equal(result$Df, anovaTable$Df)
  expect_equal(result$`Sum of Sq`, anovaTable$`Sum Sq`)
  expect_equal(result$`Mean Sq`, anovaTable$`Mean Sq`)
  expect_equal(result$`F value`, anovaTable$`F value`)
  expect_equal(result$`Pr(F)`, anovaTable$`Pr(>F)`)

  grandMean = mean(arousal.df$arousal)
  genderMeans = tapply(arousal.df$arousal, arousal.df$gender, mean)
  pictureMeans = tapply(arousal.df$arousal, arousal.df$picture, mean)
  cellMeans = tapply(
    arousal.df$arousal,
    list(arousal.df$gender, arousal.df$picture),
    mean
  )

  expect_equal(as.numeric(result$`Grand Mean`), grandMean)
  expect_equal(as.numeric(result$`Row Effects`), as.numeric(genderMeans - grandMean))
  expect_equal(as.numeric(result$`Col Effects`), as.numeric(pictureMeans - grandMean))
  expect_equal(
    as.numeric(result$`Interaction Effects`),
    as.numeric(sweep(sweep(cellMeans, 1, genderMeans), 2, pictureMeans) + grandMean)
  )
})
