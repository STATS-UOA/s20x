\name{crosstabs}
\alias{crosstabs}
\title{Crosstabulation of two variables}
\usage{crosstabs(formula, data) }

\arguments{
\item{formula}{a symbolic description of the model to be fit: ~ fac1 + fac2; where fac1 and fac2 are vectors to be crosstabulated and treated
internally as factors.}
\item{data}{an optional data frame containing the variables in the model.}
}

\description{Produces a 2-way table of counts and the corresponding
  chi-square test of independence or homogeneity.}

\value{An invisible list containing the following components:
\item{row.props}{a matrix of row proportions, i.e. cell counts divided by row marginals.}
\item{col.props}{a matrix of column proportions, i.e. cell counts divided by column marginals.}
\item{Totals}{a matrix containing the cell counts and the marginal totals.}}

\examples{
##body image data:
data(body.df)
crosstabs(~ ethnicity + married, body.df)
}

\keyword{htest}

