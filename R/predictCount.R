#' Predicted Counts for a Generalized Linear Model
#'
#' Uses the main output and some error messages from R function 'predict' but
#' gives you more output. (Error messages are not reliable when used in Splus.)
#'
#' Note: The data frame, newdata, must have the same column order and data
#' types (e.g. numeric or factor) as those used in fitting the model.
#'
#'
#' @param object a \code{glm} object, i.e. the output from \code{\link{glm}}.
#' @param newdata prediction data frame.
#' @param cilevel confidence level of the interval.
#' @param digit decimal numbers after the point.
#' @param print.out if \code{TRUE}, print out the prediction matrix.
#' @param \dots optional arguments that are passed to the generic \code{predict}.
#' @return A data frame with three columns: \describe{ \item{Predicted}{the
#' predicted count.} \item{Conf.lower}{the lower bound of the predicted count.}
#' \item{Conf.upper}{the upper bound of the predicted count.} }
#' @seealso \code{\link{predict}}, \code{\link{predict.glm}}, \code{\link{as.data.frame}}.
#' @keywords htest
#' @export predictCount
predictCount = function(object, newdata, cilevel = 0.95, digit = 3, print.out = TRUE, ...) {
  if (!inherits(object, "glm")) {
    stop("First input is not a \"glm\" object")
  }

  if (!is.data.frame(newdata)) {
    stop("Argument \"newdata\" is not a data frame!")
  }

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
  predictions = predict.glm(object, newdata, se.fit = TRUE, ...)
  predicted = predictions$fit
  percent = 1 - (1 - cilevel) / 2
  confLower = predictions$fit - qnorm(percent) * predictions$se.fit
  confUpper = predictions$fit + qnorm(percent) * predictions$se.fit
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
