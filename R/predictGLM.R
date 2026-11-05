#' Prediction Intervals for Log-Link and Logit-Link Generalised Linear Models
#'
#' Teaching helper for predictions from log-link and logit-link generalised
#' linear models. It wraps \code{\link{predict.glm}} with standard errors and
#' returns fitted values with confidence limits on either the link scale or the
#' response scale.
#'
#' New work should use \code{\link{predict20x}}, which handles \code{lm} and
#' \code{glm} fits with one function and gives results on the response scale by
#' default. \code{predictGLM()} keeps its own defaults and column names for
#' existing teaching material.
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
#' @return A data frame with columns \code{fit}, \code{lwr}, and \code{upr} containing
#'   fitted values and confidence limits on the requested scale.
#' @seealso \code{\link{predict}}, \code{\link{predict.glm}}, \code{\link{predictCount}}.
#' @note Deprecated in s20x 3.4.0. Use \code{\link{predict20x}} instead.
#' @keywords htest
#' @export predictGLM
predictGLM = function(object,
                      newdata,
                      type = "link",
                      cilevel = 0.95,
                      quasit = FALSE,
                      ...) {
  .Deprecated(msg = "predictGLM() is deprecated; use predict20x() instead.")

  if (!inherits(object, "glm")) {
    stop("First input is not a \"glm\" object")
  }

  validatePredictionNewdata(newdata)

  if (family(object)$link != "log" & family(object)$link != "logit") {
    stop("Must be a poisson or binomial model")
  }

  nameRow = paste("pred", 1:nrow(newdata), sep = ".")
  nameRow = 1:nrow(newdata)

  modelTerms = terms(object)
  termsNoResponse = delete.response(modelTerms)

  if (!all(all.vars(termsNoResponse) %in% colnames(newdata))) {
    stop("newdata must be provided for all first-order terms")
  }

  type = normaliseGlmPredictionType(type)
  prediction = glmTeachingPrediction(object, newdata, cilevel, quasit, ...)
  scaleFunction = if (type == "response") {
    family(object)$linkinv
  } else {
    identity
  }
  predictions = formatGlmPredictionFrame(
    fit = prediction$fit,
    confLower = prediction$confLower,
    confUpper = prediction$confUpper,
    scaleFunction = scaleFunction
  )

  rownames(predictions) = seq_len(nrow(predictions))

  message("***Estimates and CIs are on the ", type, " scale***")

  predictions
}
