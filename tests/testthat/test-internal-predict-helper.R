test_that("internal prediction helpers preserve base prediction output", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  lmFit = lm(y ~ x, data = data)
  lmNewdata = data.frame(x = 6)

  expect_equal(
    s20x:::predictLmWithSe(lmFit, lmNewdata),
    predict.lm(lmFit, lmNewdata, se.fit = TRUE)
  )

  countData = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  glmFit = glm(y ~ x, data = countData, family = poisson(link = "log"))
  glmNewdata = data.frame(x = 6)

  expect_equal(
    s20x:::predictGlmWithSe(glmFit, glmNewdata),
    predict.glm(glmFit, glmNewdata, se.fit = TRUE)
  )
})

test_that("teaching prediction wrappers use the shared helper path without changing output", {
  data = data.frame(y = c(1, 2, 3, 5, 8), x = c(1, 2, 3, 4, 5))
  lmFit = lm(y ~ x, data = data)
  lmNewdata = data.frame(x = 6)
  lmResult = predict20x(lmFit, lmNewdata, print.out = FALSE)
  lmBase = s20x:::predictLmWithSe(lmFit, lmNewdata)

  expect_equal(lmResult$fit, lmBase$fit)
  expect_equal(lmResult$se.fit, lmBase$se.fit)

  countData = data.frame(y = c(1, 2, 3, 4, 6), x = c(1, 2, 3, 4, 5))
  glmFit = glm(y ~ x, data = countData, family = poisson(link = "log"))
  glmNewdata = data.frame(x = 6)
  countResult = predictCount(glmFit, glmNewdata, print.out = FALSE)
  glmBase = s20x:::predictGlmWithSe(glmFit, glmNewdata)

  expect_equal(countResult$Predicted, unname(round(exp(glmBase$fit), 3)))

  glmResult = suppressMessages(predictGLM(glmFit, glmNewdata, type = "link"))
  expect_equal(glmResult[, "fit"], unname(glmBase$fit))
})
