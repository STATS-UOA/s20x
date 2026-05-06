#' Predicted Counts for a Log-Link Generalised Linear Model
#'
#' Teaching helper for count predictions from a log-link generalised linear
#' model. It wraps \code{\link{predict.glm}}, constructs confidence intervals on
#' the link scale, exponentiates the fitted values and limits, rounds the result,
#' and optionally prints the returned table.
#'
#' This is not an S3 \code{predict()} method and is not intended to be a
#' drop-in replacement for base R prediction methods. It is a specialised
#' count-focused teaching wrapper. For a more general log-link or logit-link GLM
#' helper, see \code{\link{predictGLM}}.
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

  rowNames = paste("pred", 1:nrow(newdata), sep = ".")
  rowNames = 1:nrow(newdata)
  termNames = attr(object$terms, "term.labels")
  splitFactorNames = unlist(strsplit(termNames, "factor\\("))
  splitTermNames = unlist(strsplit(splitFactorNames, "\\)"))
  columnNames = splitTermNames

  if (ncol(newdata) != length(columnNames)) {
    stop("Incorrectly input the new data!")
  }

  dimnames(newdata) = list(rowNames, columnNames)
  predictions = predictGlmWithSe(object, newdata, ...)
  intervalQuantile = glmTeachingIntervalQuantile(cilevel)
  intervals = glmTeachingConfidenceIntervals(
    fit = predictions$fit,
    seFit = predictions$se.fit,
    cilevel = cilevel,
    quantile = intervalQuantile
  )
  predicted = predictions$fit
  confLower = intervals$confLower
  confUpper = intervals$confUpper
  predictionMatrix = exp(cbind(predicted, confLower, confUpper))
  predictionMatrix = round(predictionMatrix, digit)
  predictionDf = as.data.frame(predictionMatrix)
  dimnames(predictionDf)[[1]] = dimnames(newdata)[[1]]
  dimnames(predictionDf)[[2]] = c("Predicted", " Conf.lower", "Conf.upper")

  if (print.out) {
    print(predictionDf)
  }

  invisible(predictionDf)
}
