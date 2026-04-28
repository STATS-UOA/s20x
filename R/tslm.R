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
  timeName = if (missing(time)) {
    NULL
  } else {
    captureOptionalName(substitute(time))
  }

  if (is.null(parsedFormula$errorSpec)) {
    fit = stats::lm(parsedFormula$meanFormula, data = data, ...)
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
summary.tslm = function(object, ...) {
  summary(object$fit, ...)
}

#' @export
coef.tslm = function(object, ...) {
  stats::coef(object$fit, ...)
}

#' @export
residuals.tslm = function(object, ...) {
  stats::residuals(object$fit, ...)
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
