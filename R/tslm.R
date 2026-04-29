#' Fit a linear model with optional autoregressive errors
#'
#' `tslm()` is a teaching-friendly wrapper for fitting linear models with
#' optional AR(p) error structures. Students specify the mean model using an
#' ordinary formula and add an `ar(p)` term to request autoregressive errors.
#'
#' When no `ar(p)` term is present, `tslm()` fits an ordinary [stats::lm()]
#' model. When an `ar(p)` term is present, `tslm()` fits a [nlme::gls()] model
#' with an AR(p) correlation structure using [nlme::corARMA()].
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
#' fit = tslm(dist ~ speed, data = cars)
#' coef(fit)
#'
#' fitAr = tslm(dist ~ speed + ar(1), data = cars)
#' summary(fitAr)
#'
#' @export
#' @importFrom stats AIC BIC lm as.formula formula terms coef residuals fitted predict
#' @importFrom stats logLik model.frame nobs vcov
#' @importFrom graphics abline plot
#' @importFrom stats acf printCoefmat qqline qqnorm
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
    fit = stats::lm(parsedFormula$meanFormula, data = data, ...)
    fit$call$formula = parsedFormula$meanFormula
    fit$call$data = dataCall
  } else {
    requireSuggestedPackage("nlme")

    if (is.null(timeName)) {
      warning(
        "No time variable supplied; assuming observations are already in time order.",
        call. = FALSE
      )
      correlationForm = stats::as.formula("~ 1")
    } else {
      if (!timeName %in% names(data)) {
        stop("The time variable '", timeName, "' was not found in 'data'", call. = FALSE)
      }
      correlationForm = stats::as.formula(paste("~", timeName))
    }

    fit = nlme::gls(
      parsedFormula$meanFormula,
      data = data,
      correlation = nlme::corARMA(
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
    n = stats::nobs(object$fit),
    aic = tryCatch(stats::AIC(object$fit), error = function(e) NA_real_),
    bic = tryCatch(stats::BIC(object$fit), error = function(e) NA_real_),
    logLik = tryCatch(stats::logLik(object$fit), error = function(e) NA),
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
  stats::printCoefmat(x$coefficients, digits = digits, signif.stars = FALSE, ...)

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
plot.tslm = function(x, which = c("all", "residuals", "time", "acf", "qq"), ...) {
  which = match.arg(which)

  if (which == "all") {
    oldPar = graphics::par(no.readonly = TRUE)
    on.exit(graphics::par(oldPar), add = TRUE)
    graphics::par(mfrow = c(2, 2))

    plot(x, which = "residuals", ...)
    plot(x, which = "time", ...)
    plot(x, which = "acf", ...)
    plot(x, which = "qq", ...)

    return(invisible(x))
  }

  residualValues = stats::residuals(x)

  if (which == "residuals") {
    graphics::plot(
      stats::fitted(x),
      residualValues,
      xlab = "Fitted values",
      ylab = "Residuals",
      main = "Residuals versus fitted values",
      ...
    )
    graphics::abline(h = 0, lty = 2)
  } else if (which == "time") {
    timeValues = if (!is.null(x$time)) {
      stats::model.frame(x)[[x$time]]
    } else {
      seq_along(residualValues)
    }

    graphics::plot(
      timeValues,
      residualValues,
      type = "b",
      xlab = if (is.null(x$time)) "Observation order" else x$time,
      ylab = "Residuals",
      main = "Residuals over time",
      ...
    )
    graphics::abline(h = 0, lty = 2)
  } else if (which == "acf") {
    stats::acf(residualValues, main = "ACF of residuals", ...)
  } else {
    stats::qqnorm(residualValues, main = "Normal Q-Q plot of residuals", ...)
    stats::qqline(residualValues)
  }

  invisible(x)
}
#' @export
coef.tslm = function(object, ...) {
  stats::coef(object$fit, ...)
}

#' @export
residuals.tslm = function(object, ...) {
  as.numeric(stats::residuals(object$fit, ...))
}

#' @export
fitted.tslm = function(object, ...) {
  stats::fitted(object$fit, ...)
}

#' @export
predict.tslm = function(object, ...) {
  stats::predict(object$fit, ...)
}

#' @export
formula.tslm = function(x, ...) {
  x$formula
}

#' @export
model.frame.tslm = function(formula, ...) {
  stats::model.frame(formula$fit, ...)
}

#' @export
vcov.tslm = function(object, ...) {
  stats::vcov(object$fit, ...)
}

#' @export
nobs.tslm = function(object, ...) {
  stats::nobs(object$fit, ...)
}

#' @export
logLik.tslm = function(object, ...) {
  stats::logLik(object$fit, ...)
}

#' @export
AIC.tslm = function(object, ..., k = 2) {
  stats::AIC(object$fit, ..., k = k)
}

#' @export
BIC.tslm = function(object, ...) {
  stats::BIC(object$fit, ...)
}

parseTslmFormula = function(formula) {
  if (!inherits(formula, "formula")) {
    stop("'formula' must be a formula", call. = FALSE)
  }

  termsObject = stats::terms(
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

  stats::as.formula(paste(responseText, "~", rhsText), env = environment(formula))
}

getTslmErrorTerms = function(termsObject) {
  termLabels = attr(termsObject, "term.labels")
  termLabels[vapply(termLabels, isTslmErrorTerm, logical(1))]
}

isTslmErrorTerm = function(termLabel) {
  specialNames = c("ar", "ma", "arma", "arima", "sarima")
  parsedTerm = try(parse(text = termLabel)[[1]], silent = TRUE)

  if (inherits(parsedTerm, "try-error") || !is.call(parsedTerm)) {
    return(FALSE)
  }

  termName = as.character(parsedTerm[[1]])
  termName %in% specialNames
}

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

getTslmResidualDf = function(fit, fitSummary) {
  if (!is.null(fitSummary$df) && length(fitSummary$df) >= 2) {
    return(unname(fitSummary$df[[2]]))
  }

  if (!is.null(fit$dims$N) && !is.null(fit$dims$p)) {
    return(fit$dims$N - fit$dims$p)
  }

  NA_integer_
}

getTslmArParameters = function(object) {
  if (is.null(object$errorSpec)) {
    return(numeric())
  }

  corStruct = object$fit$modelStruct$corStruct
  if (is.null(corStruct)) {
    return(numeric())
  }

  out = tryCatch(
    stats::coef(corStruct, unconstrained = FALSE),
    error = function(e) numeric()
  )

  if (length(out) > 0 && is.null(names(out))) {
    names(out) = paste0("phi", seq_along(out))
  }

  out
}

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
