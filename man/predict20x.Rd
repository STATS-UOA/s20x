\name{predict20x}
\alias{predict20x}
\title{Model Predictions for a Linear Model}
\usage{
predict20x(object, newdata, cilevel = 0.95, digit = 3, print.out = TRUE,
           ...)
}
\arguments{
  \item{object}{an lm object, i.e. the output from "lm()".}
 \item{newdata}{prediction data frame.}
 \item{cilevel}{confidence level of the interval.}
 \item{digit}{decimal numbers after the point.}
 \item{print.out}{if T, print out the prediction matrix.}
 \item{\dots}{optional arguments that are passed to the generic "predict"}
}
\description{
 Uses the main output and some error messages from R
 function "predict" but gives you more output. (Error messages are not
 reliable when used in Splus.)

Note: The data frame, newdata, must have the same column order and data types (e.g. numeric or factor) as those used in fitting the model.}

\value{
  \item{frame}{vector or matrix including predicted values, confidence
    intervals and predicted intervals.}
  \item{fit}{prediction values.}
  \item{se.fit}{standard error of predictions.}
  \item{residual.scale}{residual standard deviations.}
  \item{df}{degrees of freedom for residual.}
  \item{cilevel}{confidence level of the interval.}
}
\seealso{"predict", "predict.lm", "as.data.frame".}

\examples{
# Zoo data
data(zoo.df)
attach(zoo.df)
day.type<-factor(day.type)
fit1<-lm(log(attendance) ~ time + sun.yesterday + nice.day + day.type + tv.ads)
pred.zoo<-data.frame(8,10.8,0,factor(3),1.181)
predict20x(fit1,pred.zoo)
detach(zoo.df)

# Peruvian Indians data
data(peru.df)
attach(peru.df)
fit2<-lm(BP ~ age + years + I(years^2) + weight + height)
pred.peru<-data.frame(21,2,2^2,71,1629)
predict20x(fit2,pred.peru)
detach(peru.df)
}

\keyword{htest}

