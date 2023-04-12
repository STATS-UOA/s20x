#' Predictions for Generalized Linear Models
#'
#' An alternative to \code{\link{predictCount}} to handle Binomial as well as
#' Poisson models
#'
#' Note: The data frame, newdata, must have the same column order and data
#' types (e.g. numeric or factor) as those used in fitting the model.
#'
#'
#' @param object a \code{glm} object, i.e. the output from \code{\link{glm}}.
#' @param newdata prediction data frame.
#' @param cilevel confidence level of the interval.
#' @param type \code{"link"} (default) or \code{"response"} for CI on linear predictor or response scale.
#' @param quasit if \code{TRUE}, t multiplier for CI rather than normal multiplier in the case of a quasi model.
#' @param \dots optional arguments that are passed to the generic \code{predict}.
#' @return A data frame with three columns: \describe{ \item{Predicted}{the
#' predicted count.} \item{Conf.lower}{the lower bound of the predicted count.}
#' \item{Conf.upper}{the upper bound of the predicted count.} }
#' @seealso \code{\link{predict}}, \code{\link{predict.glm}}, \code{\link{as.data.frame}}.
#' @keywords htest
#' @export predictGLM

predictGLM = function(object,
                      newdata,
                      type = "link",
                      cilevel = 0.95,
                      quasit = FALSE,
                      ...) {
  if (!inherits(object, "glm"))
    stop("First input is not a \"glm\" object")
  
  if (!is.data.frame(newdata))
    stop("Argument \"newdata\" is not a data frame!")
  
  if (family(object)$link != "log" & family(object)$link != "logit")
    stop("Must be a poisson or binomial model")
  
  name.row = paste("pred", 1:nrow(newdata), sep = ".")
  name.row = 1:nrow(newdata)
  
  if (!inherits(object, "glm"))
    stop("First input is not a \"glm\" object")
  
  if (!is.data.frame(newdata))
    stop("Argument \"newdata\" is not a data frame!")
  
  if (family(object)$link != "log" & family(object)$link != "logit")
    stop("Must be a poisson or binomial model")
  
  tt <- terms(object)
  Terms <- delete.response(tt)
  if (!all(match(attr(Terms, "term.labels")[attr(Terms, "order") == 1],
                 colnames(newdata), nomatch = FALSE)))
    stop("newdata must be provided for all first-order terms")
  
  pred = predict.glm(object, newdata, se.fit = TRUE, ...)
  
  Expected = pred$fit
  percent = 1 - (1 - cilevel) / 2
  CIquantile = qnorm(percent)
  
  if (quasit & substr(family(object)$family, 1, 5) == "quasi")
    CIquantile = qt(percent, object$df.res)
  
  Conf.lower = pred$fit - CIquantile * pred$se.fit
  Conf.upper = pred$fit + CIquantile * pred$se.fit
  predictions = cbind(fit = Expected, lwr = Conf.lower, upr = Conf.upper)
  
  if (type == "response")
    predictions = family(object)$linkinv(predictions)
  
  rownames <- seq_len(nrow(predictions))
  
  type = if(type == "response"){
    "response"}
  else{
    "link"
  }
  
  message("***Estimates and CIs are on the ", type, " scale***")
  
  predictions
}
