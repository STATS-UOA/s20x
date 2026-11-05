#' Predicted Counts for a Log-Link Generalised Linear Model
#'
#' Teaching helper for count predictions from a log-link generalised linear
#' model. It wraps \code{\link{predict.glm}}, constructs confidence intervals on
#' the link scale, exponentiates the fitted values and limits, rounds the result,
#' and optionally prints the returned table.
#'
#' New work should use \code{\link{predict20x}}, which handles \code{lm} and
#' \code{glm} fits with one function. \code{predictCount()} always exponentiates,
#' so for a logit-link model it returns odds, as
#' \code{predict20x(type = "odds")} does.
#'
#' Note: \code{newdata} must be a data frame with the same column order and
#' data types as those used in fitting the model. This stricter interface is kept
#' for compatibility with the original teaching wrapper.
#'
#' @param object a \code{glm} object, i.e. the output from \code{\link{glm}}.
#' @param newdata prediction data frame.
#' @param cilevel confidence level for the intervals.
#' @param digit number of decimal places to print.
#' @param print.out if \code{TRUE}, print the prediction table.
#' @param \dots optional arguments that are passed to \code{\link{predict.glm}}.
#' @return Invisibly returns a data frame with three columns: \describe{
#'   \item{Predicted}{the predicted count on the response scale.}
#'   \item{Conf.lower}{the lower confidence limit on the response scale.}
#'   \item{Conf.upper}{the upper confidence limit on the response scale.}
#' }
#' @seealso \code{\link{predict}}, \code{\link{predict.glm}}, \code{\link{predictGLM}}, \code{\link{as.data.frame}}.
#' @keywords htest
#' @export predictCount
predictCount = function(object, newdata, cilevel = 0.95, digit = 3, print.out = TRUE, ...) {
  if (!inherits(object, "glm")) {
    stop("First input is not a \"glm\" object")
  }

  validatePredictionNewdata(newdata)

  newdata = alignPredictionNewdata(object, newdata)
  predictions = glmTeachingPrediction(object, newdata, cilevel)
  predictionValues = exp(cbind(
    predicted = predictions$fit,
    confLower = predictions$confLower,
    confUpper = predictions$confUpper
  ))
  predictionFrame = formatTeachingPredictionFrame(
    values = predictionValues,
    rowNames = dimnames(newdata)[[1]],
    columnNames = c("Predicted", " Conf.lower", "Conf.upper"),
    digit = digit
  )

  if (print.out) {
    print(predictionFrame)
  }

  invisible(predictionFrame)
}
