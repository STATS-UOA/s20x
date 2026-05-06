#' Prediction Intervals for Log-Link and Logit-Link Generalised Linear Models
#'
#' Teaching helper for predictions from log-link and logit-link generalised
#' linear models. It wraps \code{\link{predict.glm}} with standard errors and
#' returns fitted values with confidence limits on either the link scale or the
#' response scale.
#'
#' This is not an S3 \code{predict()} method and is not intended to be a
#' drop-in replacement for base R prediction methods. It is the more general GLM
#' teaching helper in this package; \code{\link{predictCount}} remains a
#' specialised count-focused wrapper with rounded response-scale output.
#'
#' Note: \code{newdata} must include all first-order terms used in the fitted
#' model. This simplified requirement reflects the teaching-wrapper interface
#' and is not a complete reproduction of \code{predict.glm()}.
#'
#' @param object a \code{glm} object, i.e. the output from \code{\link{glm}}.
#' @param newdata prediction data frame.
#' @param type \code{"link"} (default) or \code{"response"} for estimates and
#'   confidence intervals on the linear predictor or response scale.
#' @param cilevel confidence level for the intervals.
#' @param quasit if \code{TRUE}, use a t multiplier rather than a normal
#'   multiplier for confidence intervals when \code{object} is a quasi model.
#' @param \dots optional arguments that are passed to \code{\link{predict.glm}}.
#' @return A matrix with columns \code{fit}, \code{lwr}, and \code{upr} containing
#'   fitted values and confidence limits on the requested scale.
#' @seealso \code{\link{predict}}, \code{\link{predict.glm}}, \code{\link{predictCount}}.
#' @keywords htest
#' @export predictGLM
predictGLM = function(object,
                      newdata,
                      type = "link",
                      cilevel = 0.95,
                      quasit = FALSE,
                      ...) {
  if (!inherits(object, "glm")) {
    stop("First input is not a \"glm\" object")
  }

  if (!is.data.frame(newdata)) {
    stop("Argument \"newdata\" is not a data frame!")
  }

  if (family(object)$link != "log" & family(object)$link != "logit") {
    stop("Must be a poisson or binomial model")
  }

  nameRow = paste("pred", 1:nrow(newdata), sep = ".")
  nameRow = 1:nrow(newdata)

  if (!inherits(object, "glm")) {
    stop("First input is not a \"glm\" object")
  }

  if (!is.data.frame(newdata)) {
    stop("Argument \"newdata\" is not a data frame!")
  }

  if (family(object)$link != "log" & family(object)$link != "logit") {
    stop("Must be a poisson or binomial model")
  }

  modelTerms = terms(object)
  termsNoResponse = delete.response(modelTerms)
  termLabels = attr(termsNoResponse, "term.labels")
  firstOrderTerms = termLabels[attr(termsNoResponse, "order") == 1]

  if (!all(match(firstOrderTerms, colnames(newdata), nomatch = FALSE))) {
    stop("newdata must be provided for all first-order terms")
  }

  pred = predictGlmWithSe(object, newdata, ...)

  expected = pred$fit
  ciQuantile = glmTeachingIntervalQuantile(
    cilevel = cilevel,
    object = object,
    quasit = quasit
  )
  intervals = glmTeachingConfidenceIntervals(
    fit = pred$fit,
    seFit = pred$se.fit,
    cilevel = cilevel,
    quantile = ciQuantile
  )
  predictions = cbind(
    fit = expected,
    lwr = intervals$confLower,
    upr = intervals$confUpper
  )

  if (type == "response") {
    predictions = family(object)$linkinv(predictions)
  }

  rownames = seq_len(nrow(predictions))

  type = if (type == "response") {
    "response"
  } else {
    "link"
  }

  message("***Estimates and CIs are on the ", type, " scale***")

  predictions
}
