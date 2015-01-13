\name{boxqq}
\alias{boxqq}
\alias{boxqq.formula}
\title{Box plots and normal quantile-quantile plots}
\usage{boxqq(formula, \dots)
\method{boxqq}{formula}(formula, data = NULL, \dots)
}

\arguments{
\item{formula}{A
          symbolic specification of the form `x ~ g' can be given,
          indicating the observations in the vector `x' are to be
          grouped according to the levels of the factor `g'. `NA's are
          allowed in the data.}
\item{data}{An optional data frame in which to evaluate the formula.}
\item{...}{Arguments to be passed to methods, such as graphical
    parameters (see \code{\link{par}}).}
}
\description{Draws boxplots and normal quantile quantile plots of x for each value of the grouping variable g}

\value{Returns the plot.}

\examples{
## Zoo data
data(zoo.df)
boxqq(attendance~day.type, data = zoo.df)
}

\keyword{hplot}

