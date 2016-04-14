\name{stripqq}
\alias{stripqq}
\alias{stripqq.formula}
\title{Strip charts and normal quantile-quantile plots}
\usage{stripqq(formula,\dots)
\method{stripqq}{formula}(formula, data = NULL, \dots)
}

\arguments{
\item{formula}{A
          symbolic specification of the form `x ~ g' can be given,
          indicating the observations in the vector `x' are to be
          grouped according to the levels of the factor `g'. `NA's are
          allowed in the data.}
	\item{data}{An optional data frame in which to evaluate the formula}
	\item{...}{Optional arguments that are passed to the plotting function.}
}
\description{Draws strip charts and normal quantile quantile plots of x for each value of the grouping variable g}

\value{Returns the plot.}

\examples{
## Zoo data
data(zoo.df)
stripqq(attendance~day.type, data = zoo.df)
}

\keyword{hplot}

