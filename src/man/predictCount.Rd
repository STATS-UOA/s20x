\name{predictCount}
\alias{predictCount}
\title{Predicted Counts for a Generalized Linear Model}
\usage{
predictCount(object, newdata, cilevel = 0.95, digit = 3, print.out = TRUE,
             \dots)
}
\arguments{
  \item{object}{a glm object, i.e. the output from "glm()".}
 \item{newdata}{prediction data frame.}
 \item{cilevel}{confidence level of the interval.}
 \item{digit}{decimal numbers after the point.}
 \item{print.out}{if TRUE, print out the prediction matrix.}
 \item{\dots}{optional arguments that are passed to the generic "predict".}
}
\description{
 Uses the main output and some error messages from R
 function "predict" but gives you more output. (Error messages are not
 reliable when used in Splus.)

Note: The data frame, newdata, must have the same column order and data types (e.g. numeric or factor) as those used in fitting the model.}

\value{
  A data frame with three columns:
  \describe{
    \item{Predicted}{the predicted count.}
    \item{Conf.lower}{the lower bound of the predicted count.}
    \item{Conf.upper}{the upper bound of the predicted count.}
  }
}
\seealso{"predict", "predict.glm", "as.data.frame".}

\keyword{htest}

