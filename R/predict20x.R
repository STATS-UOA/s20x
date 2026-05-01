#' Deprecated Teaching Predictions for a Linear Model
#'
#' Teaching helper for linear-model predictions. It wraps
#' \code{\link{predict.lm}} and prints a compact table containing fitted values,
#' confidence intervals, and prediction intervals for new observations.
#'
#' This is not an S3 \code{predict()} method and is not intended to be a
#' drop-in replacement for base R prediction methods. The function is retained
#' for compatibility with older teaching material, but the standard
#' \code{\link{predict}} interface is preferred for new work.
#'
#' Note: \code{newdata} must be a data frame with the same column order and
#' data types as those used in fitting the model.
#'
#' @param object an \code{lm} object, i.e. the output from \code{lm}.
#' @param newdata prediction data frame.
#' @param cilevel confidence level of the interval.
#' @param digit decimal numbers after the point.
#' @param print.out if \code{TRUE}, print out the prediction matrix.
#' @param \dots optional arguments that are passed to \code{\link{predict.lm}}.
#' @return Invisibly returns a list with components \describe{
#'   \item{frame}{printed data frame containing predictions, confidence intervals,
#'   and prediction intervals.}
#'   \item{fit}{prediction values.}
#'   \item{se.fit}{standard errors of predictions.}
#'   \item{residual.scale}{residual standard deviation.}
#'   \item{df}{residual degrees of freedom.}
#'   \item{cilevel}{confidence level of the interval.}
#' }
#' @seealso \code{\link{predict}}, \code{\link{predict.lm}}, \code{\link{as.data.frame}}.
#' @note This function is deprecated as it is no longer used in class. Prefer
#'   the standard \code{\link{predict}} method for new work.
#' @keywords htest
#' @examples
#'
#' # Zoo data
#' data(zoo.df)
#' zoo.df = within(zoo.df, {day.type = factor(day.type)})
#' zoo.fit = lm(log(attendance) ~ time + sun.yesterday + nice.day + day.type + tv.ads,
#'              data = zoo.df)
#' pred.zoo = data.frame(time = 8, sun.yesterday = 10.8, nice.day = 0,
#'                       day.type = factor(3), tv.ads = 1.181)
#' predict20x(zoo.fit, pred.zoo)
#'
#' # Peruvian Indians data
#' data(peru.df)
#' peru.fit = lm(BP ~ age + years + I(years^2) + weight + height, data = peru.df)
#' pred.peru = data.frame(age = 21, years = 2, `I(years^2)` = 2, weight = 71, height = 1629)
#' predict20x(peru.fit, pred.peru)
#'
#' @export predict20x
predict20x = function(object, newdata, cilevel = 0.95, digit = 3, print.out = TRUE, ...) {
  if (!inherits(object, "lm")) {
    stop("First input is not an \"lm\" object")
  }

  if (!is.data.frame(newdata)) {
    stop("Argument \"newdata\" is not a data frame!")
  }

  name.row = paste("pred", 1:nrow(newdata), sep = ".")
  name.row = 1:nrow(newdata)
  x = attr(object$terms, "term.labels")

  y = unlist(strsplit(x, "factor\\("))
  z = unlist(strsplit(y, "\\)"))
  name.col = z

  if (ncol(newdata) != length(name.col)) {
    stop("Incorrectly input the new data!")
  }

  dimnames(newdata) = list(name.row, name.col)

  pred = predictLmWithSe(object, newdata, ...)
  Predicted = pred$fit
  percent = 1 - (1 - cilevel) / 2
  Conf.lower = pred$fit - qt(percent, pred$df) * pred$se.fit
  Conf.upper = pred$fit + qt(percent, pred$df) * pred$se.fit
  pred.se = sqrt(pred$residual.scale^2 + pred$se.fit^2)
  Pred.lower = pred$fit - qt(percent, pred$df) * pred.se
  Pred.upper = pred$fit + qt(percent, pred$df) * pred.se
  mat = cbind(Predicted, Conf.lower, Conf.upper, Pred.lower, Pred.upper)
  mat = round(mat, digit)
  mat.df = as.data.frame(mat)
  dimnames(mat.df)[[1]] = dimnames(newdata)[[1]]
  dimnames(mat.df)[[2]] = c("Predicted", " Conf.lower", "Conf.upper", " Pred.lower", " Pred.upper")

  if (print.out) {
    print(mat.df)
  }

  invisible(list(
    frame = mat.df,
    fit = pred$fit,
    se.fit = pred$se.fit,
    residual.scale = pred$residual.scale,
    df = pred$df,
    cilevel = cilevel
  ))
}
