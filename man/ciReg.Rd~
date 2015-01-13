\name{ciReg}
\alias{ciReg}
\title{Confidence Intervals for Regression models}
\usage{ciReg(fit, conf.level=0.95, print.out=TRUE)}

\arguments{
\item{fit}{an lm object, i.e. the output from "lm()".}
\item{conf.level}{confidence level of the intervals.}
\item{print.out}{if TRUE, print out the output on the screen.}}

\description{Calculates and prints the confidence intervals for the
  fitted model.}

\seealso{"lm", "summary", "anova".}

\value{The function returns a two-column matrix containing the upper and lower endpoints of the intervals.}

\examples{
##Peruvian Indians data
data(peru.df)
attach(peru.df)
fit<-lm(BP ~ age + years + weight + height)
ciReg(fit)
detach(peru.df)
}

\keyword{htest}

