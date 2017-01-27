#' Model Predictions for a Linear Model
#' 
#' Uses the main output and some error messages from R function 'predict' but
#' gives you more output. (Error messages are not reliable when used in Splus.)
#' 
#' Note: The data frame, newdata, must have the same column order and data
#' types (e.g. numeric or factor) as those used in fitting the model.
#' 
#' 
#' @param object an \code{lm} object, i.e. the output from \code{lm}.
#' @param newdata prediction data frame.
#' @param cilevel confidence level of the interval.
#' @param digit decimal numbers after the point.
#' @param print.out if T, print out the prediction matrix.
#' @param \dots optional arguments that are passed to the generic 'predict'
#' @return \item{frame}{vector or matrix including predicted values, confidence
#' intervals and predicted intervals.} \item{fit}{prediction values.}
#' \item{se.fit}{standard error of predictions.} \item{residual.scale}{residual
#' standard deviations.} \item{df}{degrees of freedom for residual.}
#' \item{cilevel}{confidence level of the interval.}
#' @seealso \code{\link{predict}}, \code{\link{predict.lm}}, \code{\link{as.data.frame}}.
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
#' @note this function is deprecated as it is never used in class any more. We prefer the standard \code{\link{predict}} method.
predict20x = function(object, newdata, cilevel = 0.95, digit = 3, print.out = TRUE, ...) {
    ## prediction which allows for factors and a data frame with data entered in the same order as the data frame that was used in fitting the above model (note: the variable names do not need to be specified)
    
    if (!inherits(object, "lm")) 
        stop("First input is not an \"lm\" object")
    
    if (!is.data.frame(newdata)) 
        stop("Argument \"newdata\" is not a data frame!")
    
    
    name.row = paste("pred", 1:nrow(newdata), sep = ".")
    name.row = 1:nrow(newdata)
    # name.col = attr(object$terms,'term.labels')
    x = attr(object$terms, "term.labels")
    
    y = unlist(strsplit(x, "factor\\("))
    z = unlist(strsplit(y, "\\)"))
    name.col = z
    # print(name.col)
    
    if (ncol(newdata) != length(name.col)) 
        stop("Incorrectly input the new data!")
    
    
    dimnames(newdata) = list(name.row, name.col)
    
    pred = predict.lm(object, newdata, se.fit = TRUE, ...)
    Predicted = pred$fit
    percent = 1 - (1 - cilevel)/2
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
    
    if (print.out) 
        print(mat.df)
    
    invisible(list(frame = mat.df, fit = pred$fit, se.fit = pred$se.fit, residual.scale = pred$residual.scale, df = pred$df, cilevel = cilevel))
}

