\name{cooks20x}
\alias{cooks20x}
\title{Cook's distance  plot}
\usage{cooks20x(lmfit)}

\arguments{
\item{lmfit}{output from the function "lm()".}
}
\description{Draws a Cook's distance plot.}

\value{Returns the plot and identifies the three highest Cook's values}

\examples{
# Peruvian Indians data
data(peru.df)
attach(peru.df)
fit1<-lm(BP~age+years+I(years^2)+weight+height)
cooks20x(fit1)
detach(peru.df)
}

\keyword{hplot}

