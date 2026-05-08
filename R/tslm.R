#' Fit a linear model with optional autoregressive errors
#'
#' `tslm()` is a teaching-friendly wrapper for fitting linear models with
#' optional AR(p) error structures. Students specify the mean model using an
#' ordinary formula and add an `ar(p)` term to request autoregressive errors.
#'
#' When no `ar(p)` term is present, `tslm()` fits an ordinary [stats::lm()]
#' model. When an `ar(p)` term is present, `tslm()` fits a [nlme::gls()] model
#' with an AR(p) correlation structure using [nlme::corARMA()]. The `ar(p)`
#' term changes the error model, not the mean-model terms printed in the
#' formula.
#'
#' @details
#' The formula describes the mean model, just as it does for [stats::lm()]. The
#' special term `ar(p)` is removed from the mean model before fitting and is used
#' only to specify the correlation structure for the errors. For example,
#' `log(passengers) ~ t + month + ar(1)` fits a trend and seasonal mean model
#' with AR(1) errors.
#'
#' For AR-error models, `time` should usually name the variable giving the time
#' order of the observations. If `time` is omitted, `tslm()` fits the model using
#' the row order of `data` and gives a warning so that this assumption is
#' visible.
#'
#' Diagnostic methods for AR-error models use normalised residuals by default,
#' because these residuals account for the fitted correlation structure. Use
#' `residualType = "response"` when the raw response residuals are required.
#' `"normalised"` and `"normalized"` are both accepted for compatibility.
#'
#' @param formula a model formula. Use `ar(p)` in the right hand side to specify
#'   AR(p) errors, for example `y ~ x + ar(1)`.
#' @param data a data frame containing the variables in the model.
#' @param time optional unquoted or quoted name of the time variable in `data`.
#'   If omitted for an AR model, the row order of `data` is used.
#' @param method fitting method passed to [nlme::gls()] for AR models. Defaults
#'   to `"REML"`.
#' @param ... additional arguments passed to [stats::lm()] or [nlme::gls()].
#'
#' @return An object of class `tslm`, containing the original formula, the mean
#'   formula fitted internally, the AR order, the time variable if supplied, and
#'   the underlying fitted model.
#'
#' @examples
#' data(beer.df)
#' fit = tslm(beer ~ t + ar(1), data = beer.df, time = t)
#' coef(fit)
#'
#' data(airpass.df)
#' fitAr = tslm(log(passengers) ~ t + month + ar(1),
#'   data = airpass.df,
#'   time = t
#' )
#' summary(fitAr)
#' anova(fitAr)
#'
#' plot(fitAr)
#' plot(fitAr, residualType = "response")
#'
#' @export
#' @importFrom stats AIC BIC anova lm as.formula formula terms coef residuals fitted predict
#' @importFrom stats logLik model.frame nobs vcov
#' @importFrom graphics abline par plot
#' @importFrom stats acf printCoefmat qqline qqnorm
#' @importFrom nlme corARMA gls
#' @importFrom utils packageVersion
#' @importFrom methods is
#' @seealso [stats::lm()], [nlme::gls()], [nlme::corARMA()]
tslm = function(formula, data, time, method = "REML", ...) {
  if (missing(formula)) {
    stop("'formula' must be supplied", call. = FALSE)
  }

  if (missing(data)) {
    stop("'data' must be supplied", call. = FALSE)
  }

  if (!is.data.frame(data)) {
    stop("'data' must be a data frame", call. = FALSE)
  }

  parsedFormula = parseTslmFormula(formula)
  dataCall = substitute(data)
  timeName = if (missing(time)) {
    NULL
  } else {
    captureOptionalName(substitute(time))
  }

  if (is.null(parsedFormula$errorSpec)) {
    fit = lm(parsedFormula$meanFormula, data = data, ...)
    fit$call$formula = parsedFormula$meanFormula
    fit$call$data = dataCall
  } else {
    requireSuggestedPackage("nlme")

    if (is.null(timeName)) {
      warning(
        "No time variable supplied; assuming observations are already in time order.",
        call. = FALSE
      )
      correlationForm = as.formula("~ 1")
    } else {
      if (!timeName %in% names(data)) {
        stop("The time variable '", timeName, "' was not found in 'data'", call. = FALSE)
      }
      correlationForm = as.formula(paste("~", timeName))
    }

    fit = gls(
      parsedFormula$meanFormula,
      data = data,
      correlation = corARMA(
        p = parsedFormula$errorSpec$p,
        q = 0,
        form = correlationForm
      ),
      method = method,
      ...
    )
    fit$call$model = parsedFormula$meanFormula
    fit$call$data = dataCall
  }

  structure(
    list(
      call = match.call(),
      formula = formula,
      meanFormula = parsedFormula$meanFormula,
      errorSpec = parsedFormula$errorSpec,
      time = timeName,
      modelData = data,
      fit = fit
    ),
    class = "tslm"
  )
}

#' @export
print.tslm = function(x, ...) {
  cat("Call:\n")
  print(x$call)
  cat("\nMean formula:\n")
  print(x$meanFormula)

  if (is.null(x$errorSpec)) {
    cat("\nError structure: independent errors\n")
  } else {
    cat("\nError structure: AR(", x$errorSpec$p, ")\n", sep = "")

    if (is.null(x$time)) {
      cat("Time variable: row order\n")
    } else {
      cat("Time variable: ", x$time, "\n", sep = "")
    }
  }

  cat("\nUnderlying fit:\n")
  print(x$fit, ...)
  invisible(x)
}

#' @export
summary.tslm = function(object, verbose = FALSE, ...) {
  if (isTRUE(verbose)) {
    return(summary(object$fit, ...))
  }

  fitSummary = summary(object$fit, ...)

  out = list(
    call = object$call,
    formula = object$formula,
    meanFormula = object$meanFormula,
    errorSpec = object$errorSpec,
    time = object$time,
    coefficients = getTslmCoefficientTable(fitSummary),
    sigma = fitSummary$sigma,
    df = getTslmResidualDf(object$fit, fitSummary),
    n = nobs(object$fit),
    aic = tryCatch(AIC(object$fit), error = function(e) NA_real_),
    bic = tryCatch(BIC(object$fit), error = function(e) NA_real_),
    logLik = tryCatch(logLik(object$fit), error = function(e) NA),
    arParameters = getTslmArParameters(object)
  )

  class(out) = "summary.tslm"
  out
}

#' @export
print.summary.tslm = function(x, digits = max(3L, getOption("digits") - 3L), ...) {
  if (is.null(x$errorSpec)) {
    cat("Time series linear model with independent errors\n\n")
  } else {
    cat("Time series linear model with AR(", x$errorSpec$p, ") errors\n\n", sep = "")
  }

  cat("Mean model:\n  ")
  cat(paste(deparse(x$meanFormula), collapse = " "), "\n\n", sep = "")

  cat("Error model:\n  ")
  if (is.null(x$errorSpec)) {
    cat("Independent errors\n\n")
  } else {
    arText = paste0("AR(", x$errorSpec$p, ")")
    if (length(x$arParameters) > 0) {
      arText = paste0(
        arText,
        ", estimated ",
        paste(
          names(x$arParameters),
          format(signif(x$arParameters, digits = digits)),
          sep = " = ",
          collapse = ", "
        )
      )
    }
    cat(arText, "\n", sep = "")

    if (is.null(x$time)) {
      cat("  Time variable: row order\n\n")
    } else {
      cat("  Time variable: ", x$time, "\n\n", sep = "")
    }
  }

  cat("Coefficients:\n")
  printCoefmat(x$coefficients, digits = digits, signif.stars = FALSE, ...)

  cat("\nResidual standard error:", format(signif(x$sigma, digits = digits)))
  if (!is.na(x$df)) {
    cat(" on ", x$df, " degrees of freedom", sep = "")
  }
  cat("\n")

  if (!is.na(x$aic)) {
    cat("AIC:", format(signif(x$aic, digits = digits)), "\n")
  }

  if (!is.na(x$bic)) {
    cat("BIC:", format(signif(x$bic, digits = digits)), "\n")
  }

  invisible(x)
}

#' @export
plot.tslm = function(x, which = c("all", "residuals", "time", "acf", "qq"),
                      residualType = "normalised", ...) {
  which = match.arg(which)
  residualType = matchTslmResidualType(residualType)
  diagnosticData = getTslmDiagnosticData(x, residualType = residualType)

  if (which == "all") {
    restoreGraphicsParameters = saveGraphicsParameters(noReadonly = TRUE)
    on.exit(restoreGraphicsParameters(), add = TRUE)
    par(mfrow = c(2, 2))

    plotTslmResiduals(diagnosticData, residualType = residualType, ...)
    plotTslmTimeResiduals(diagnosticData, x, residualType = residualType, ...)
    acf(diagnosticData$residuals, main = paste("ACF of", residualType, "residuals"), ...)
    qqnorm(diagnosticData$residuals, main = paste("Normal Q-Q plot of", residualType, "residuals"), ...)
    qqline(diagnosticData$residuals)
  } else if (which == "residuals") {
    plotTslmResiduals(diagnosticData, residualType = residualType, ...)
  } else if (which == "time") {
    plotTslmTimeResiduals(diagnosticData, x, residualType = residualType, ...)
  } else if (which == "acf") {
    acf(diagnosticData$residuals, main = paste("ACF of", residualType, "residuals"), ...)
  } else {
    qqnorm(diagnosticData$residuals, main = paste("Normal Q-Q plot of", residualType, "residuals"), ...)
    qqline(diagnosticData$residuals)
  }

  invisible(x)
}
#' @export
coef.tslm = function(object, ...) {
  coef(object$fit, ...)
}

#' @export
residuals.tslm = function(object, type = c("response", "pearson", "normalised", "normalized"), ...) {
  type = matchTslmResidualType(type)

  if (identical(type, "normalized") && is.null(object$errorSpec)) {
    responseResiduals = as.numeric(residuals(object$fit, ...))
    return(responseResiduals / sigma(object$fit))
  }

  if (is.null(object$errorSpec)) {
    return(as.numeric(residuals(object$fit, type = type, ...)))
  }

  as.numeric(residuals(object$fit, type = type, ...))
}

#' ANOVA tables for time series linear models
#'
#' Produces analysis-of-variance-style tables for `tslm` objects.
#'
#' @param object a fitted `tslm` object.
#' @param ... optional additional fitted model objects for model comparisons.
#' @param verbose logical. For AR-error models, use `TRUE` to return the raw
#'   underlying [nlme::anova.gls()] output.
#'
#' @details
#' For ordinary `tslm()` fits without autoregressive error terms, `anova()`
#' returns the usual analysis of variance table from [stats::anova.lm()].
#'
#' For AR-error models fitted through [nlme::gls()], the reported tests are
#' Wald-style tests of model terms. These test whether each term contributes to
#' the fitted mean model after allowing for the estimated autocorrelation
#' structure. Because these models do not use the ordinary independent-error
#' sum-of-squares decomposition, the compact table reports `Df`, `F value`, and
#' `Pr(>F)`, but does not report `Sum Sq` or `Mean Sq`. Compare nested AR-error
#' models with care: `verbose = TRUE` exposes the underlying `nlme` comparison
#' output rather than recreating an ordinary `lm` ANOVA table.
#'
#' Use `verbose = TRUE` to see the underlying [nlme::anova.gls()] output.
#'
#' @return An analysis-of-variance-style table.
#'
#' @examples
#' data(beer.df)
#' fit = tslm(beer ~ t + ar(1), data = beer.df, time = t)
#' anova(fit)
#'
#' @method anova tslm
#' @export
anova.tslm = function(object, ..., verbose = FALSE) {
  modelList = list(object, ...)

  if (length(modelList) > 1 || isTRUE(verbose)) {
    fitList = lapply(modelList, extractTslmFit)
    return(do.call(anova, fitList))
  }

  if (is.null(object$errorSpec)) {
    return(anova(object$fit))
  }

  rawTable = anova(object$fit)
  out = formatTslmAnovaTable(rawTable)

  structure(
    out,
    heading = c(
      "Analysis of Variance Table",
      paste("Response:", deparse(object$meanFormula[[2]])),
      "Tests of model terms allowing for AR errors"
    ),
    class = c("anova.tslm", "data.frame")
  )
}

#' @export
print.anova.tslm = function(x, digits = max(3L, getOption("digits") - 3L), ...) {
  heading = attr(x, "heading")
  if (!is.null(heading)) {
    cat(paste(heading, collapse = "
"), "

", sep = "")
  }

  print.data.frame(x, digits = digits, ...)
  invisible(x)
}

#' @export
fitted.tslm = function(object, ...) {
  as.numeric(fitted(object$fit, ...))
}

#' @export
predict.tslm = function(object, ...) {
  predict(object$fit, ...)
}

#' @export
formula.tslm = function(x, ...) {
  x$formula
}

#' @export
model.frame.tslm = function(formula, ...) {
  model.frame(formula$fit, ...)
}

#' @export
vcov.tslm = function(object, ...) {
  vcov(object$fit, ...)
}

#' @export
nobs.tslm = function(object, ...) {
  nobs(object$fit, ...)
}

#' @export
logLik.tslm = function(object, ...) {
  logLik(object$fit, ...)
}

#' @export
AIC.tslm = function(object, ..., k = 2) {
  AIC(object$fit, ..., k = k)
}

#' @export
BIC.tslm = function(object, ...) {
  BIC(object$fit, ...)
}

#' Parse a tslm formula
#'
#' Separate the mean-model formula from a supported `tslm()` error structure.
#'
#' @param formula a model formula supplied to [tslm()].
#' @return A list containing `meanFormula` and `errorSpec`.
#' @keywords internal
parseTslmFormula = function(formula) {
  if (!inherits(formula, "formula")) {
    stop("'formula' must be a formula", call. = FALSE)
  }

  termsObject = terms(
    formula,
    specials = c("ar", "ma", "arma", "arima", "sarima"),
    keep.order = TRUE
  )

  errorSpec = extractTslmErrorSpec(termsObject)
  meanFormula = removeTslmErrorTerms(formula, termsObject)

  list(
    meanFormula = meanFormula,
    errorSpec = errorSpec
  )
}

#' Extract a tslm error specification
#'
#' Extract and validate the supported autoregressive error term from parsed formula terms.
#'
#' @param termsObject a terms object created from a `tslm()` formula.
#' @return `NULL` for independent errors, or a list describing the AR error structure.
#' @keywords internal
extractTslmErrorSpec = function(termsObject) {
  errorTerms = getTslmErrorTerms(termsObject)

  if (length(errorTerms) == 0) {
    return(NULL)
  }

  if (length(errorTerms) > 1) {
    stop("Specify only one error structure in a tslm() formula", call. = FALSE)
  }

  specialCall = parse(text = errorTerms)[[1]]
  specialName = as.character(specialCall[[1]])

  if (!identical(specialName, "ar")) {
    stop(
      "Only ar(p) error structures are currently supported by tslm().",
      call. = FALSE
    )
  }

  if (length(specialCall) != 2) {
    stop("Use ar(p) with exactly one positive integer order", call. = FALSE)
  }

  p = eval(specialCall[[2]], envir = baseenv())

  if (!is.numeric(p) || length(p) != 1 || is.na(p) || p < 1 || p != as.integer(p)) {
    stop("Use ar(p) with p as a positive integer", call. = FALSE)
  }

  list(
    type = "ar",
    p = as.integer(p),
    d = 0L,
    q = 0L,
    seasonal = NULL
  )
}

#' Remove tslm error terms
#'
#' Remove supported error-structure terms from the formula used for the fitted mean model.
#'
#' @param formula a model formula supplied to [tslm()].
#' @param termsObject a terms object created from `formula`.
#' @return A formula containing only the mean-model terms.
#' @keywords internal
removeTslmErrorTerms = function(formula, termsObject) {
  termLabels = attr(termsObject, "term.labels")
  errorTerms = getTslmErrorTerms(termsObject)

  if (length(errorTerms) > 0) {
    termLabels = setdiff(termLabels, errorTerms)
  }

  responseText = paste(deparse(formula[[2]]), collapse = "")
  intercept = attr(termsObject, "intercept")

  if (length(termLabels) == 0) {
    rhsText = if (identical(intercept, 0L)) {
      "0"
    } else {
      "1"
    }
  } else {
    rhsText = paste(termLabels, collapse = " + ")

    if (identical(intercept, 0L)) {
      rhsText = paste(rhsText, "- 1")
    }
  }

  as.formula(paste(responseText, "~", rhsText), env = environment(formula))
}

#' Get tslm error terms
#'
#' Identify formula term labels that use a supported `tslm()` error-structure form.
#'
#' @param termsObject a terms object created from a `tslm()` formula.
#' @return A character vector of error-structure term labels.
#' @keywords internal
getTslmErrorTerms = function(termsObject) {
  termLabels = attr(termsObject, "term.labels")
  termLabels[vapply(termLabels, isTslmErrorTerm, logical(1))]
}

#' Check a tslm error term
#'
#' Check whether a formula term label is a supported `tslm()` error-structure term.
#'
#' @param termLabel a formula term label.
#' @return `TRUE` when the term label is an error-structure term; otherwise `FALSE`.
#' @keywords internal
isTslmErrorTerm = function(termLabel) {
  specialNames = c("ar", "ma", "arma", "arima", "sarima")
  parsedTerm = try(parse(text = termLabel)[[1]], silent = TRUE)

  if (inherits(parsedTerm, "try-error") || !is.call(parsedTerm)) {
    return(FALSE)
  }

  termName = as.character(parsedTerm[[1]])
  termName %in% specialNames
}

#' Capture an optional column name
#'
#' Convert a supplied symbol or character value into a column name for `tslm()` internals.
#'
#' @param argumentExpression the unevaluated argument expression.
#' @return A character name or `NULL` when no name was supplied.
#' @keywords internal
captureOptionalName = function(argumentExpression) {
  if (identical(argumentExpression, quote(expr = ))) {
    return(NULL)
  }

  if (is.symbol(argumentExpression)) {
    return(as.character(argumentExpression))
  }

  if (is.character(argumentExpression) && length(argumentExpression) == 1 && nzchar(argumentExpression)) {
    return(argumentExpression)
  }

  stop("'time' must be supplied as a column name", call. = FALSE)
}

#' Get a tslm coefficient table
#'
#' Extract a coefficient table from either an `lm` or `gls` summary object.
#'
#' @param fitSummary summary output from the underlying fitted model.
#' @return A coefficient matrix.
#' @keywords internal
getTslmCoefficientTable = function(fitSummary) {
  if (!is.null(fitSummary$tTable)) {
    out = fitSummary$tTable
    colnames(out) = c("Estimate", "Std. Error", "t value", "Pr(>|t|)")
    return(out)
  }

  if (!is.null(fitSummary$coefficients) && is.matrix(fitSummary$coefficients)) {
    return(fitSummary$coefficients)
  }

  if (!is.null(fitSummary$coefficients) && is.data.frame(fitSummary$coefficients)) {
    return(as.matrix(fitSummary$coefficients))
  }

  stop("Could not extract coefficient table from the fitted model", call. = FALSE)
}

#' Get tslm residual degrees of freedom
#'
#' Extract residual degrees of freedom from a fitted model and its summary.
#'
#' @param fit the underlying fitted model.
#' @param fitSummary summary output from the fitted model.
#' @return The residual degrees of freedom, or `NA_integer_` if unavailable.
#' @keywords internal
getTslmResidualDf = function(fit, fitSummary) {
  if (!is.null(fitSummary$df) && length(fitSummary$df) >= 2) {
    return(unname(fitSummary$df[[2]]))
  }

  if (!is.null(fit$dims$N) && !is.null(fit$dims$p)) {
    return(fit$dims$N - fit$dims$p)
  }

  NA_integer_
}

#' Get tslm autoregressive parameters
#'
#' Extract fitted autoregressive parameters from a `tslm` object when present.
#'
#' @param object a fitted `tslm` object.
#' @return A named numeric vector of AR parameters.
#' @keywords internal
getTslmArParameters = function(object) {
  if (is.null(object$errorSpec)) {
    return(numeric())
  }

  corStruct = object$fit$modelStruct$corStruct
  if (is.null(corStruct)) {
    return(numeric())
  }

  out = tryCatch(
    coef(corStruct, unconstrained = FALSE),
    error = function(e) numeric()
  )

  if (length(out) > 0 && is.null(names(out))) {
    names(out) = paste0("phi", seq_along(out))
  }

  out
}

#' Extract the underlying tslm fit
#'
#' Return the underlying fitted model from a `tslm` object, or the input model unchanged.
#'
#' @param model a model object.
#' @return A fitted model object.
#' @keywords internal
extractTslmFit = function(model) {
  if (is(model, "tslm")) {
    return(model$fit)
  }

  model
}

#' Format a tslm ANOVA table
#'
#' Convert the raw AR-error ANOVA table into the compact teaching table.
#'
#' @param rawTable the ANOVA table returned by the underlying fitted model.
#' @return A data frame with compact ANOVA columns.
#' @keywords internal
formatTslmAnovaTable = function(rawTable) {
  out = as.data.frame(rawTable)

  if ("numDF" %in% names(out)) {
    names(out)[names(out) == "numDF"] = "Df"
  }

  if ("F-value" %in% names(out)) {
    names(out)[names(out) == "F-value"] = "F value"
  }

  if ("p-value" %in% names(out)) {
    names(out)[names(out) == "p-value"] = "Pr(>F)"
  }

  if ("(Intercept)" %in% rownames(out)) {
    out = out[rownames(out) != "(Intercept)", , drop = FALSE]
  }

  wantedColumns = intersect(c("Df", "F value", "Pr(>F)"), names(out))
  out = out[, wantedColumns, drop = FALSE]

  if ("Df" %in% names(out)) {
    out$Df = as.integer(out$Df)
  }

  if ("Pr(>F)" %in% names(out)) {
    out[["Pr(>F)"]] = format.pval(out[["Pr(>F)"]], digits = 3, eps = 0.001)
  }

  out
}

#' Get tslm diagnostic data
#'
#' Collect fitted values, residuals, and time values for `tslm` diagnostic plots.
#'
#' @param object a fitted `tslm` object.
#' @param residualType residual type requested for diagnostic plots.
#' @return A list with `fitted`, `residuals`, and `time` components.
#' @keywords internal
getTslmDiagnosticData = function(object, residualType = "normalised") {
  residualType = matchTslmResidualType(residualType)
  diagnosticData = getModelResidualFittedData(
    object,
    residualType = residualType,
    context = "tslm object"
  )

  timeValues = getTslmTimeValues(object, length(diagnosticData$residuals))

  if (length(timeValues) != length(diagnosticData$residuals)) {
    stop(
      "Could not align the time variable with the model residuals. ",
      "Check that the time variable was supplied from the same data frame used to fit the model.",
      call. = FALSE
    )
  }

  list(
    fitted = diagnosticData$fitted,
    residuals = diagnosticData$residuals,
    time = timeValues
  )
}

#' Get tslm time values
#'
#' Extract or reconstruct the time values used by `tslm` diagnostic plots.
#'
#' @param object a fitted `tslm` object.
#' @param nResiduals expected number of residuals.
#' @return A vector of time or observation-order values.
#' @keywords internal
getTslmTimeValues = function(object, nResiduals) {
  if (is.null(object$time)) {
    return(seq_len(nResiduals))
  }

  if (!is.null(object$modelData) && object$time %in% names(object$modelData)) {
    return(object$modelData[[object$time]])
  }

  modelFrame = tryCatch(
    model.frame(object$fit),
    error = function(e) NULL
  )

  if (!is.null(modelFrame) && object$time %in% names(modelFrame)) {
    return(modelFrame[[object$time]])
  }

  stop(
    "Could not find the time variable stored with this tslm object.",
    call. = FALSE
  )
}

#' Plot tslm residuals against fitted values
#'
#' Draw the residuals-versus-fitted diagnostic panel for `tslm` objects.
#'
#' @param diagnosticData diagnostic data returned by `getTslmDiagnosticData()`.
#' @param residualType residual type label used for plot text.
#' @param ... additional graphical arguments passed to [graphics::plot()].
#' @return Called for its plotting side effect.
#' @keywords internal
plotTslmResiduals = function(diagnosticData, residualType = "normalised", ...) {
  plot(
    diagnosticData$fitted,
    diagnosticData$residuals,
    xlab = "Fitted values",
    ylab = paste0(formatTslmResidualTypeLabel(residualType), " residuals"),
    main = paste0(formatTslmResidualTypeLabel(residualType), " residuals versus fitted values"),
    ...
  )
  abline(h = 0, lty = 2)
}

#' Plot tslm residuals over time
#'
#' Draw the residuals-over-time diagnostic panel for `tslm` objects.
#'
#' @param diagnosticData diagnostic data returned by `getTslmDiagnosticData()`.
#' @param object a fitted `tslm` object.
#' @param residualType residual type label used for plot text.
#' @param ... additional graphical arguments passed to [graphics::plot()].
#' @return Called for its plotting side effect.
#' @keywords internal
plotTslmTimeResiduals = function(diagnosticData, object, residualType = "normalised", ...) {
  plot(
    diagnosticData$time,
    diagnosticData$residuals,
    type = "b",
    xlab = if (is.null(object$time)) "Observation order" else object$time,
    ylab = paste0(formatTslmResidualTypeLabel(residualType), " residuals"),
    main = paste0(formatTslmResidualTypeLabel(residualType), " residuals over time"),
    ...
  )
  abline(h = 0, lty = 2)
}


#' Match a tslm residual type
#'
#' Match and normalise residual type aliases used by `tslm` diagnostics.
#'
#' @param type requested residual type.
#' @return The matched residual type used internally.
#' @keywords internal
matchTslmResidualType = function(type) {
  type = match.arg(type, c("response", "pearson", "normalised", "normalized"))

  if (identical(type, "normalised")) {
    return("normalized")
  }

  type
}

#' Format a tslm residual type label
#'
#' Convert an internal residual type into plot-label text.
#'
#' @param type internal residual type.
#' @return A sentence-case residual type label.
#' @keywords internal
formatTslmResidualTypeLabel = function(type) {
  if (identical(type, "normalized")) {
    type = "normalised"
  }

  sentenceCase(type)
}

#' Convert text to sentence case
#'
#' Capitalise the first character of a string used in diagnostic labels.
#'
#' @param x a character vector.
#' @return `x` with the first character capitalised.
#' @keywords internal
sentenceCase = function(x) {
  paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
}

#' Require a suggested package
#'
#' Check that a suggested package is installed before optional functionality uses it.
#'
#' @param package package name.
#' @return Invisibly returns `TRUE`, or errors if the package is unavailable.
#' @keywords internal
requireSuggestedPackage = function(package) {
  if (!requireNamespace(package, quietly = TRUE)) {
    stop(
      "Package '", package, "' is required for AR error models. ",
      "Please install it or fit a model without ar(p).",
      call. = FALSE
    )
  }

  invisible(TRUE)
}
