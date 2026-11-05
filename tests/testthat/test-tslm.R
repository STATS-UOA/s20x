data(beer.df)

test_that("tslm evaluates formulas in the calling environment when data is omitted", {
  y = beer.df$beer
  x = beer.df$t

  fit = tslm(y ~ x)
  lmFit = lm(y ~ x)

  expect_s3_class(fit, "tslm")
  expect_s3_class(fit$fit, "lm")
  expect_equal(coef(fit), coef(lmFit))
})

test_that("tslm still evaluates formulas with an explicit data frame", {
  fit = tslm(beer ~ t, data = beer.df)
  lmFit = lm(beer ~ t, data = beer.df)

  expect_s3_class(fit, "tslm")
  expect_s3_class(fit$fit, "lm")
  expect_equal(coef(fit), coef(lmFit))
})

test_that("tslm evaluates AR formulas and time variables without explicit data", {
  skip_if_not_installed("nlme")

  y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3)
  x = seq_len(8)
  t = seq_len(8)

  fit = tslm(y ~ x + ar(1), time = t)

  expect_s3_class(fit, "tslm")
  expect_s3_class(fit$fit, "gls")
  expect_equal(fit$errorSpec$p, 1L)
  expect_equal(fit$time, "t")
  expect_equal(fit$modelData$t, t)
})

test_that("tslm calling-environment fits match explicit data frame fits", {
  y = beer.df$beer
  x = beer.df$t

  environmentFit = tslm(y ~ x)
  dataFit = tslm(beer ~ t, data = beer.df)

  expect_s3_class(environmentFit, "tslm")
  expect_s3_class(environmentFit$fit, "lm")
  expect_equal(unname(coef(environmentFit)), unname(coef(dataFit)))
})

test_that("tslm AR calling-environment fits match explicit data frame fits", {
  skip_if_not_installed("nlme")

  data(airpass.df)

  passengers = airpass.df$passengers
  t = airpass.df$t
  month = airpass.df$month

  environmentFit = tslm(log(passengers) ~ t + month + ar(1), time = t)
  dataFit = tslm(log(passengers) ~ t + month + ar(1),
    data = airpass.df,
    time = t
  )

  expect_s3_class(environmentFit, "tslm")
  expect_s3_class(environmentFit$fit, "gls")
  expect_equal(environmentFit$errorSpec$p, 1L)
  expect_equal(environmentFit$time, "t")
  expect_equal(unname(coef(environmentFit)), unname(coef(dataFit)))
})

test_that("tslm falls back to lm when no AR term is supplied", {
  fit = tslm(beer ~ t, data = beer.df)

  expect_s3_class(fit, "tslm")
  expect_s3_class(fit$fit, "lm")
  expect_null(fit$errorSpec)
  expect_equal(coef(fit), coef(lm(beer ~ t, data = beer.df)))
})

test_that("tslm removes ar terms from the mean formula", {
  parsedFormula = getS20xInternal("parseTslmFormula")(beer ~ t + ar(2))

  expect_equal(parsedFormula$errorSpec$type, "ar")
  expect_equal(parsedFormula$errorSpec$p, 2L)
  expect_equal(deparse(parsedFormula$meanFormula), "beer ~ t")
})

test_that("tslm rejects unsupported future error structures", {
  expect_error(
    getS20xInternal("parseTslmFormula")(beer ~ t + arma(1, 1)),
    "Only ar\\(p\\) error structures"
  )
})

test_that("tslm fits AR models when nlme is available", {
  skip_if_not_installed("nlme")

  data = data.frame(
    y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3),
    x = seq_len(8),
    t = seq_len(8)
  )

  fit = tslm(y ~ x + ar(1), data = data, time = t)

  expect_s3_class(fit, "tslm")
  expect_s3_class(fit$fit, "gls")
  expect_equal(fit$errorSpec$p, 1L)
  expect_equal(fit$time, "t")
})

test_that("tslm preserves no-intercept mean formulas", {
  parsedFormula = getS20xInternal("parseTslmFormula")(beer ~ 0 + t + ar(1))

  expect_equal(deparse(parsedFormula$meanFormula), "beer ~ t - 1")
})

test_that("tslm reports missing time variables clearly", {
  skip_if_not_installed("nlme")

  data = data.frame(
    y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3),
    x = seq_len(8),
    t = seq_len(8)
  )

  expect_error(
    tslm(y ~ x + ar(1), data = data, time = missingTime),
    "time variable 'missingTime'"
  )
})

test_that("tslm rejects multiple error structures", {
  expect_error(
    getS20xInternal("parseTslmFormula")(beer ~ t + ar(1) + ar(2)),
    "Specify only one error structure"
  )
})

test_that("tslm validates AR order", {
  expect_error(
    getS20xInternal("parseTslmFormula")(beer ~ t + ar(0)),
    "positive integer"
  )

  expect_error(
    getS20xInternal("parseTslmFormula")(beer ~ t + ar(1.5)),
    "positive integer"
  )
})

test_that("tslm accepts quoted and unquoted time column names", {
  skip_if_not_installed("nlme")

  data = data.frame(
    y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3),
    x = seq_len(8),
    t = seq_len(8)
  )

  quotedFit = tslm(y ~ x + ar(1), data = data, time = "t")
  unquotedFit = tslm(y ~ x + ar(1), data = data, time = t)

  expect_equal(quotedFit$time, "t")
  expect_equal(unquotedFit$time, "t")
})

test_that("tslm exposes common model generics", {
  fit = tslm(beer ~ t, data = beer.df)
  lmFit = lm(beer ~ t, data = beer.df)

  expect_equal(formula(fit), beer ~ t)
  expect_equal(vcov(fit), vcov(lmFit))
  expect_equal(nobs(fit), nobs(lmFit))
  expect_equal(as.numeric(logLik(fit)), as.numeric(logLik(lmFit)))
  expect_equal(AIC(fit), AIC(lmFit))
  expect_equal(BIC(fit), BIC(lmFit))
})

test_that("summary.tslm prints a compact teaching summary", {
  skip_if_not_installed("nlme")

  data = data.frame(
    y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3),
    x = seq_len(8),
    t = seq_len(8)
  )

  fit = tslm(y ~ x + ar(1), data = data, time = t)
  summaryOutput = capture.output(summary(fit))

  expect_s3_class(summary(fit), "summary.tslm")
  expect_true(any(grepl("Time series linear model with AR\\(1\\) errors", summaryOutput)))
  expect_true(any(grepl("Mean model:", summaryOutput)))
  expect_true(any(grepl("Error model:", summaryOutput)))
  expect_true(any(grepl("Coefficients:", summaryOutput)))
  expect_false(any(grepl("Correlation:", summaryOutput)))
  expect_false(any(grepl("Standardized residuals:", summaryOutput)))
})

test_that("summary.tslm can return the verbose underlying summary", {
  fit = tslm(beer ~ t, data = beer.df)

  expect_s3_class(summary(fit, verbose = TRUE), "summary.lm")
})

test_that("plot.tslm supports the teaching diagnostic plots", {
  fit = tslm(beer ~ t, data = beer.df)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(plot(fit))
  expect_silent(plot(fit, which = "time"))
  expect_silent(plot(fit, which = "acf"))
  expect_silent(plot(fit, which = "qq"))
})

test_that("plot.tslm aligns AR model diagnostics without dropping values", {
  skip_if_not_installed("nlme")

  data = data.frame(
    y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3),
    x = seq_len(8),
    t = seq_len(8)
  )

  fit = tslm(y ~ x + ar(1), data = data, time = t)
  diagnosticData = getS20xInternal("getTslmDiagnosticData")(fit)

  expect_length(diagnosticData$residuals, nrow(data))
  expect_length(diagnosticData$fitted, nrow(data))
  expect_length(diagnosticData$time, nrow(data))

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(plot(fit))
})

test_that("normcheck works with tslm objects", {
  fit = tslm(beer ~ t, data = beer.df)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(normcheck(fit))
})

test_that("tslm residuals support normalised residuals", {
  fit = tslm(beer ~ t, data = beer.df)

  responseResiduals = residuals(fit, type = "response")
  normalizedResiduals = residuals(fit, type = "normalized")
  normalisedResiduals = residuals(fit, type = "normalised")

  expect_type(normalisedResiduals, "double")
  expect_length(normalisedResiduals, length(responseResiduals))
  expect_equal(normalisedResiduals, normalizedResiduals)
  expect_equal(normalisedResiduals, responseResiduals / sigma(fit$fit))
})

test_that("plot.tslm can use response and normalised residuals", {
  fit = tslm(beer ~ t, data = beer.df)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(plot(fit, residualType = "normalised"))
  expect_silent(plot(fit, residualType = "normalized"))
  expect_silent(plot(fit, residualType = "response"))
  expect_error(plot(fit, residualType = "bad"), "should be one of")
})

test_that("anova works with tslm objects", {
  fit = tslm(beer ~ t, data = beer.df)

  out = anova(fit)
  expect_true(is.data.frame(out) || is.matrix(out) || inherits(out, "anova"))
})

test_that("anova compares compatible tslm models", {
  fitSmall = tslm(beer ~ 1, data = beer.df)
  fitLarge = tslm(beer ~ t, data = beer.df)

  out = anova(fitSmall, fitLarge)
  expect_true(is.data.frame(out) || is.matrix(out) || inherits(out, "anova"))
})

test_that("normcheck.tslm can use normalised residuals", {
  fit = tslm(beer ~ t, data = beer.df)

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(normcheck(fit, residualType = "normalised"))
  expect_silent(normcheck(fit, residualType = "normalized"))
  expect_silent(normcheck(fit, residualType = "response"))
})

test_that("anova.tslm prints a compact teaching table for AR fits", {
  skip_if_not_installed("nlme")

  data = data.frame(
    y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3),
    x = seq_len(8),
    z = rep(c("a", "b"), 4),
    t = seq_len(8)
  )

  fit = tslm(y ~ x + z + ar(1), data = data, time = t)
  out = anova(fit)
  printed = capture.output(print(out))

  expect_s3_class(out, "anova.tslm")
  expect_true("Df" %in% names(out))
  expect_true("F value" %in% names(out))
  expect_true("Pr(>F)" %in% names(out))
  expect_false("(Intercept)" %in% rownames(out))
  expect_true(any(grepl("Analysis of Variance Table", printed)))
  expect_true(any(grepl("Response:", printed)))
  expect_true(any(grepl("Tests of model terms allowing for AR errors", printed)))
  expect_true(is.character(out[["Pr(>F)"]]))
  expect_false(any(grepl("e-", out[["Pr(>F)"]]))) 
})

test_that("anova.tslm can return verbose underlying anova output", {
  skip_if_not_installed("nlme")

  data = data.frame(
    y = c(1.0, 1.5, 2.1, 2.7, 3.0, 3.4, 4.0, 4.3),
    x = seq_len(8),
    t = seq_len(8)
  )

  fit = tslm(y ~ x + ar(1), data = data, time = t)
  out = anova(fit, verbose = TRUE)

  expect_false(inherits(out, "anova.tslm"))
  expect_true("numDF" %in% names(as.data.frame(out)))
})


test_that("documented airpass.df teaching workflow is stable", {
  skip_if_not_installed("nlme")

  data(airpass.df)

  fit = tslm(log(passengers) ~ t + month + ar(1),
    data = airpass.df,
    time = t
  )

  expect_s3_class(fit, "tslm")
  expect_s3_class(fit$fit, "gls")
  expect_equal(fit$errorSpec$p, 1L)
  expect_equal(fit$time, "t")
  expect_equal(levels(airpass.df$month), month.abb)

  summaryOutput = capture.output(summary(fit))
  anovaOutput = capture.output(anova(fit))

  expect_true(any(grepl("Time series linear model with AR\\(1\\) errors", summaryOutput)))
  expect_true(any(grepl("Analysis of Variance Table", anovaOutput)))
  expect_true(any(grepl("Response: log\\(passengers\\)", anovaOutput)))
  expect_true(any(grepl("Tests of model terms allowing for AR errors", anovaOutput)))
  expect_true(any(grepl("<0.001", anovaOutput))) 
})

test_that("documented tslm diagnostic residual choices run", {
  skip_if_not_installed("nlme")

  data(airpass.df)

  fit = tslm(log(passengers) ~ t + month + ar(1),
    data = airpass.df,
    time = t
  )

  pdf(NULL)
  on.exit(dev.off(), add = TRUE)

  expect_silent(plot(fit))
  expect_silent(plot(fit, residualType = "response"))
  expect_silent(normcheck(fit))
})

shuffleTimeOrder = function(data) {
  data[order((data$t * 61) %% 145), ]
}

test_that("tslm diagnostics follow time order when rows are shuffled", {
  data(airpass.df)
  shuffledData = shuffleTimeOrder(airpass.df)
  expect_false(identical(shuffledData$t, airpass.df$t))

  getData = getS20xInternal("getTslmDiagnosticData")
  sortedDiagnostics = getData(
    tslm(log(passengers) ~ t, data = airpass.df, time = t),
    residualType = "response"
  )
  shuffledDiagnostics = getData(
    tslm(log(passengers) ~ t, data = shuffledData, time = t),
    residualType = "response"
  )

  expect_equal(shuffledDiagnostics$time, airpass.df$t)
  expect_equal(unname(shuffledDiagnostics$residuals), unname(sortedDiagnostics$residuals))
  expect_equal(unname(shuffledDiagnostics$fitted), unname(sortedDiagnostics$fitted))
})

test_that("tslm AR diagnostics follow time order when rows are shuffled", {
  skip_if_not_installed("nlme")
  data(airpass.df)

  getData = getS20xInternal("getTslmDiagnosticData")
  sortedDiagnostics = getData(tslm(log(passengers) ~ t + ar(1), data = airpass.df, time = t))
  shuffledDiagnostics = getData(
    tslm(log(passengers) ~ t + ar(1), data = shuffleTimeOrder(airpass.df), time = t)
  )

  expect_equal(shuffledDiagnostics$time, airpass.df$t)
  expect_equal(
    as.numeric(shuffledDiagnostics$residuals),
    as.numeric(sortedDiagnostics$residuals),
    tolerance = 1e-3
  )
})

test_that("tslm AR coefficients do not depend on row order", {
  skip_if_not_installed("nlme")
  data(airpass.df)

  sortedFit = tslm(log(passengers) ~ t + ar(1), data = airpass.df, time = t)
  shuffledFit = tslm(log(passengers) ~ t + ar(1), data = shuffleTimeOrder(airpass.df), time = t)

  expect_equal(coef(shuffledFit), coef(sortedFit), tolerance = 1e-4)
})

test_that("tslm diagnostics keep row order when no time variable is supplied", {
  data(airpass.df)
  fit = tslm(log(passengers) ~ t, data = airpass.df)
  diagnosticData = getS20xInternal("getTslmDiagnosticData")(fit, residualType = "response")

  expect_equal(diagnosticData$time, seq_len(nrow(airpass.df)))
  expect_equal(
    unname(diagnosticData$residuals),
    unname(residuals(lm(log(passengers) ~ t, data = airpass.df)))
  )
})

test_that("tslm keeps offset terms in the mean model", {
  data(airpass.df)

  fit = tslm(log(passengers) ~ t + offset(log(t)), data = airpass.df)
  expect_equal(coef(fit), coef(lm(log(passengers) ~ t + offset(log(t)), data = airpass.df)))
  expect_true("offset(log(t))" %in% rownames(attr(terms(fit$meanFormula), "factors")))

  noInterceptFit = tslm(log(passengers) ~ t + offset(log(t)) - 1, data = airpass.df)
  expect_equal(
    coef(noInterceptFit),
    coef(lm(log(passengers) ~ t + offset(log(t)) - 1, data = airpass.df))
  )

  offsetOnlyFit = tslm(log(passengers) ~ offset(log(t)), data = airpass.df)
  expect_equal(coef(offsetOnlyFit), coef(lm(log(passengers) ~ offset(log(t)), data = airpass.df)))
})

test_that("tslm stops rather than dropping an offset from an AR model", {
  skip_if_not_installed("nlme")
  data(airpass.df)

  expect_error(
    tslm(log(passengers) ~ t + offset(log(t)) + ar(1), data = airpass.df, time = t),
    "offset"
  )
})

test_that("tslm finds variables local to a calling function alongside data", {
  data(airpass.df)

  fitInsideFunction = function(data) {
    localTrend = sqrt(data$t)
    tslm(log(passengers) ~ t + localTrend, data = data)
  }
  localTrend = sqrt(airpass.df$t)

  expect_equal(
    coef(fitInsideFunction(airpass.df)),
    coef(lm(log(passengers) ~ t + localTrend, data = airpass.df))
  )
})

test_that("tslm finds a local time variable alongside data", {
  skip_if_not_installed("nlme")
  data(airpass.df)

  fitInsideFunction = function(data) {
    timeIndex = data$t
    tslm(log(passengers) ~ t + ar(1), data = data, time = timeIndex)
  }

  fit = fitInsideFunction(airpass.df)

  expect_equal(
    coef(fit),
    coef(tslm(log(passengers) ~ t + ar(1), data = airpass.df, time = t))
  )
})
