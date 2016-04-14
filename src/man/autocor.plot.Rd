\name{autocor.plot}
\alias{autocor.plot}
\title{Autocorrelation Plot}
\usage{autocor.plot(fit)}

\arguments{
\item{fit}{output from the function "lm()".}
}
\description{Plots current vs lagged residuals along with quadrants dividing these residuals about the value zero.}

\value{Plots current vs lagged residuals along with quadrants dividing these residuals about the value zero.}

\examples{
data(airpass.df)
time<-1:144
airpass.fit<-lm(passengers~time, data = airpass.df)
autocor.plot(airpass.fit)
}

\keyword{hplot}

