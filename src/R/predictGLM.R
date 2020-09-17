#predictGLM replaces predictCount (only applicable to Poisson models)
#predictGLM handles both Poisson and binomial models.

#Optional arguments
#type = "link" or "response" for CI on linear predictor or response scale.
#quasit = Logical. Whether to use t multiplier for CI rather than normal multiplier in the case of a quasi model.

predictGLM=function (object, newdata, type="link",
                     cilevel = 0.95, quasit=FALSE,...) 
{
  if (!inherits(object, "glm")) 
    stop("First input is not a \"glm\" object")
  if (!is.data.frame(newdata)) 
    stop("Argument \"newdata\" is not a data frame!")
  if(family(object)$link!="log" & family(object)$link!="logit")
    stop("Must be a poisson or binomial model")
  name.row <- paste("pred", 1:nrow(newdata), sep = ".")
  name.row <- 1:nrow(newdata)
  x <- attr(object$terms, "term.labels")
  y <- unlist(strsplit(x, "factor\\("))
  z <- unlist(strsplit(y, "\\)"))
  name.col <- z
  if (ncol(newdata) != length(name.col)) 
    stop("Incorrect input of the new data!")
  dimnames(newdata) <- list(name.row, name.col)
  pred <- predict.glm(object, newdata, se.fit = TRUE, ...)
  Expected <- pred$fit
  percent <- 1 - (1 - cilevel)/2
  CIquantile=qnorm(percent)
  if(quasit&substr(family(object)$family,1,5)=="quasi") CIquantile=qt(percent,object$df.res)
  Conf.lower <- pred$fit - CIquantile * pred$se.fit
  Conf.upper <- pred$fit + CIquantile * pred$se.fit
  wk <- cbind(Expected, Conf.lower, Conf.upper)
  if(type=="response") wk <- family(object)$linkinv(wk)
  wk.df <- as.data.frame(wk)
  dimnames(wk.df)[[1]] <- dimnames(newdata)[[1]]
  dimnames(wk.df)[[2]] <- c("Estimated", "Conf.lower", "Conf.upper")
  type <- ifelse(type=="response","response","link")
  cat("***Estimates and CIs are on the",type,"scale***\n")
  wk.df
  #invisible(list(frame = wk.df, fit = pred$fit, se.fit = pred$se.fit, 
  #    df = pred$df, cilevel = cilevel))
}

