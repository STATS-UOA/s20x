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
    if (!inherits(object, "glm")) 
        stop("First input is not a \"glm\" object")
    
    if (!is.data.frame(newdata)) 
        stop("Argument \"newdata\" is not a data frame!")
    
    name.row = paste("pred", 1:nrow(newdata), sep = ".")
    name.row = 1:nrow(newdata)
    x = attr(object$terms, "term.labels")
    y = unlist(strsplit(x, "factor\\("))
    z = unlist(strsplit(y, "\\)"))
    name.col = z
    
    if (ncol(newdata) != length(name.col)) 
        stop("Incorrectly input the new data!")
    
    dimnames(newdata) = list(name.row, name.col)
    pred = predict.glm(object, newdata, se.fit = TRUE, ...)
    Predicted = pred$fit
    percent = 1 - (1 - cilevel)/2
    Conf.lower = pred$fit - qnorm(percent) * pred$se.fit
    Conf.upper = pred$fit + qnorm(percent) * pred$se.fit
    mat = exp(cbind(Predicted, Conf.lower, Conf.upper))
    mat = round(mat, digit)
    mat.df = as.data.frame(mat)
    dimnames(mat.df)[[1]] = dimnames(newdata)[[1]]
    dimnames(mat.df)[[2]] = c("Predicted", " Conf.lower", "Conf.upper")
    
    if (print.out){
        print(mat.df)
    }
    invisible(mat.df)
    # invisible(list(frame = mat.df, fit = pred$fit, se.fit = pred$se.fit, df = pred$df, cilevel = cilevel))
}

