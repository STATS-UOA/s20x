#' Teaching Predictions with Confidence and Prediction Intervals
#'
#' \code{predict20x()} gives predictions and intervals for a fitted model. It is
#' an S3 generic, so the same function works for linear models, generalised
#' linear models, \code{\link[nlme]{gls}} models and \code{\link{tslm}} fits.
#'
#' For an \code{lm} fit the table holds fitted values, confidence intervals for
#' the mean response, and prediction intervals for new observations. For a
#' \code{glm} fit the intervals are confidence intervals, calculated on the link
#' scale and then transformed according to \code{type}.
#'
#' For a \code{gls} fit the table has the same columns as for an \code{lm} fit.
#' Standard errors come from the estimated covariance matrix of the coefficients,
#' and the prediction intervals add the residual variance. They do not use the
#' most recent residuals, so forecasts from a model with correlated errors follow
#' the fitted mean. A variance model given through \code{weights} is ignored, and
#' a warning says so.
#'
#' The columns of \code{newdata} are matched to the model variables by name when
#' every variable is present. Otherwise they are taken in order, either one
#' column per variable or one column per model term.
#'
#' This is not a method for \code{\link{predict}}, so it does not change what
#' \code{predict()} does for these models.
#'
#' @param object a fitted model, such as the output from \code{lm} or \code{glm}.
#' @param newdata prediction data frame.
#' @param conf.level confidence level for the intervals.
#' @param digits number of decimal places to print.
#' @param print.out if \code{TRUE}, print the prediction table.
#' @param cilevel the older name for \code{conf.level}.
#' @param type for a \code{glm} fit, the scale of the results: \code{"response"}
#'   (the default), \code{"link"}, or \code{"odds"} for a logit-link model.
#' @param quasit if \code{TRUE}, use a t multiplier rather than a normal
#'   multiplier when \code{object} is a quasi model.
#' @param \dots optional arguments that are passed to the model's prediction
#'   method, or for other methods to \code{predict20x()}.
#' @return Invisibly returns an object of class \code{s20xPrediction}, which
#'   prints as the prediction table. It is a list with components \describe{
#'   \item{frame}{data frame containing the predictions and intervals.}
#'   \item{fit}{prediction values, on the link scale for a \code{glm} fit.}
#'   \item{se.fit}{standard errors of predictions.}
#'   \item{residual.scale}{residual standard deviation, for an \code{lm} or
#'     \code{gls} fit.}
#'   \item{df}{residual degrees of freedom, for an \code{lm} or \code{gls} fit.}
#'   \item{type}{the scale of the results, for a \code{glm} fit.}
#'   \item{cilevel}{confidence level of the interval.}
#' }
#' @seealso \code{\link{predict}}, \code{\link{predict.lm}}, \code{\link{predict.glm}}.
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
#' # A generalised linear model: predictions on the response scale
#' peru.glm = glm(BP ~ log(weight), data = peru.df, family = poisson)
#' predict20x(peru.glm, data.frame(weight = c(60, 70)))
#' predict20x(peru.glm, data.frame(weight = c(60, 70)), type = "link")
#'
#' # A regression with autocorrelated errors
#' data(airpass.df)
#' pass.gls = nlme::gls(log(passengers) ~ t + month + I(t^2),
#'                      correlation = nlme::corAR1(), data = airpass.df)
#' predict20x(pass.gls, data.frame(t = 145, month = "Jan"))
#'
#' @export predict20x
predict20x = function(object, ...) {
  UseMethod("predict20x")
}

#' @rdname predict20x
#' @export
predict20x.default = function(object, ...) {
  stop("First input is not an \"lm\" object")
}

#' @rdname predict20x
#' @export
predict20x.lm = function(object, newdata, conf.level = 0.95, digits = 3, print.out = TRUE,
                         cilevel = conf.level, ...) {
  validatePredictionNewdata(newdata)

  newdata = alignPredictionNewdata(object, newdata)

  pred = predictLmWithSe(object, newdata, ...)
  intervals = lmTeachingPredictionIntervals(
    fit = pred$fit,
    seFit = pred$se.fit,
    residualScale = pred$residual.scale,
    df = pred$df,
    cilevel = cilevel
  )
  predictionValues = cbind(
    Predicted = pred$fit,
    Conf.lower = intervals$confLower,
    Conf.upper = intervals$confUpper,
    Pred.lower = intervals$predLower,
    Pred.upper = intervals$predUpper
  )
  predictionFrame = formatTeachingPredictionFrame(
    values = predictionValues,
    rowNames = rownames(newdata),
    columnNames = c("Predicted", " Conf.lower", "Conf.upper", " Pred.lower", " Pred.upper"),
    digit = digits
  )

  result = structure(
    list(
      frame = predictionFrame,
      fit = pred$fit,
      se.fit = pred$se.fit,
      residual.scale = pred$residual.scale,
      df = pred$df,
      cilevel = cilevel
    ),
    class = "s20xPrediction"
  )

  if (print.out) {
    print(result)
  }

  invisible(result)
}

#' @rdname predict20x
#' @export
predict20x.glm = function(object, newdata, conf.level = 0.95, digits = 3, print.out = TRUE,
                          cilevel = conf.level, type = c("response", "link", "odds"),
                          quasit = FALSE, ...) {
  type = match.arg(type)
  validatePredictionNewdata(newdata)

  if (type == "odds" && family(object)$link != "logit") {
    stop("Odds are only available for a logit-link model")
  }

  newdata = alignPredictionNewdata(object, newdata)
  prediction = glmTeachingPrediction(object, newdata, cilevel, quasit, ...)

  scaleFunction = switch(
    type,
    response = family(object)$linkinv,
    link = identity,
    odds = exp
  )
  predictionFrame = formatTeachingPredictionFrame(
    values = scaleFunction(cbind(
      Predicted = prediction$fit,
      Conf.lower = prediction$confLower,
      Conf.upper = prediction$confUpper
    )),
    rowNames = rownames(newdata),
    columnNames = c("Predicted", " Conf.lower", "Conf.upper"),
    digit = digits
  )

  result = structure(
    list(
      frame = predictionFrame,
      fit = prediction$fit,
      se.fit = prediction$seFit,
      type = type,
      cilevel = cilevel
    ),
    class = "s20xPrediction"
  )

  if (print.out) {
    print(result)
  }

  invisible(result)
}

#' @rdname predict20x
#' @export
predict20x.gls = function(object, newdata, conf.level = 0.95, digits = 3, print.out = TRUE,
                          cilevel = conf.level, ...) {
  validatePredictionNewdata(newdata)

  if (!is.null(object$modelStruct$varStruct)) {
    warning(
      "predict20x() ignores the variance model in this gls fit, so the prediction intervals assume constant variance",
      call. = FALSE
    )
  }

  newdata = alignPredictionNewdata(object, newdata)
  pred = glsTeachingPrediction(object, newdata)
  residualDf = object$dims$N - object$dims$p
  intervals = lmTeachingPredictionIntervals(
    fit = pred$fit,
    seFit = pred$seFit,
    residualScale = object$sigma,
    df = residualDf,
    cilevel = cilevel
  )
  predictionValues = cbind(
    Predicted = pred$fit,
    Conf.lower = intervals$confLower,
    Conf.upper = intervals$confUpper,
    Pred.lower = intervals$predLower,
    Pred.upper = intervals$predUpper
  )
  predictionFrame = formatTeachingPredictionFrame(
    values = predictionValues,
    rowNames = rownames(newdata),
    columnNames = c("Predicted", " Conf.lower", "Conf.upper", " Pred.lower", " Pred.upper"),
    digit = digits
  )

  result = structure(
    list(
      frame = predictionFrame,
      fit = pred$fit,
      se.fit = pred$seFit,
      residual.scale = object$sigma,
      df = residualDf,
      cilevel = cilevel
    ),
    class = "s20xPrediction"
  )

  if (print.out) {
    print(result)
  }

  invisible(result)
}

#' @rdname predict20x
#' @export
predict20x.tslm = function(object, newdata, ...) {
  if (!is.null(object$errorSpec)) {
    stop("predict20x() does not yet support tslm models with ar(p) errors", call. = FALSE)
  }

  predict20x(object$fit, newdata, ...)
}

#' @export
print.s20xPrediction = function(x, ...) {
  print(x$frame, ...)
  invisible(x)
}

#' @export
as.data.frame.s20xPrediction = function(x, row.names = NULL, optional = FALSE, ...) {
  frame = x$frame

  if (!is.null(row.names)) {
    rownames(frame) = row.names
  }

  frame
}
