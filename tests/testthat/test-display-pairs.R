tukeyContrasts = function(fit, label) {
  tukeyRows = rownames(TukeyHSD(aov(fit))[[label]])
  estimates = TukeyHSD(aov(fit))[[label]][, "diff"]
  data.frame(
    contrast = gsub(":", " ", sub("-", " - ", tukeyRows, fixed = TRUE), fixed = TRUE),
    estimate = unname(estimates)
  )
}

test_that("displayPairs keeps comparisons when factors share a level name", {
  data("arousal.df", package = "s20x", envir = environment())

  relabelled = arousal.df
  levels(relabelled$picture)[levels(relabelled$picture) == "infant"] = "female"
  allPairs = tukeyContrasts(
    lm(arousal ~ gender * picture, data = relabelled),
    "gender:picture"
  )

  capture.output(
    result <- displayPairs(
      allPairs,
      levels1 = c("female", "male"),
      levels2 = c("female", "landscape", "nude.f", "nude.m"),
      asDF = TRUE
    )
  )

  expect_equal(nrow(result), 16)
  expect_equal(sum(result$within == "female"), 7)
})

test_that("displayPairs is unchanged when level names differ", {
  data("arousal.df", package = "s20x", envir = environment())

  allPairs = tukeyContrasts(
    lm(arousal ~ gender * picture, data = arousal.df),
    "gender:picture"
  )

  capture.output(
    result <- displayPairs(
      allPairs,
      levels1 = c("female", "male"),
      levels2 = c("infant", "landscape", "nude.f", "nude.m"),
      asDF = TRUE
    )
  )

  expect_equal(nrow(result), 16)
  expect_equal(sum(result$within == "female"), 6)
  expect_equal(sum(result$within == "infant"), 1)
})
