\name{freq1way}
\alias{freq1way}
\title{Analysis of 1-dimensional frequency tables}
\usage{freq1way(counts, hypothprob, conf.level = 0.95, addCIs = TRUE,
digits = 4,arrowwid = 0.1, estimated = 0)}

\arguments{
\item{counts}{A 1-way frequency table as produced by table()}
\item{hypothprob}{If present, a set of probabilities to test the cell counts against}
\item{conf.level}{confidence level for the confidence interval, expressed as a
decimal.}
\item{addCIs}{If true, adds confidence limits to plot of sample proportions}
\item{digits}{used to control rounding of printout}
\item{arrowwid}{controls width of arrowheads}
\item{estimated}{default is 0. Subtracted from the df for the Chi-square test.}
}

\description{If hypothprob is absent: prints confidence intervals for the true
proportions, a Chi-square test for uniformity, confidence intervals for
differences in proportions (no corrections for multiple comparisons and plots the
proportions.

If hypothprob is present: prints confidence intervals for the true
proportions, a Chi-square test for the hypothesized probabilities, and
plots the sample proportions (with atached confidence limits) alongside the
corresponding hypothesized probabilities. )}

\value{An invisible list containing the following components:
\item{CIs}{a matrix containing the confidence intervals.}
\item{exp}{a vector of the expected counts.}
\item{chi}{a vector of the  components of Chi-square.}
}

\examples{
##Body image data:
data(body.df)
eth.table <- with(body.df, table(ethnicity))
freq1way(eth.table)
freq1way(eth.table,hypothprob=c(0.2,0.4,0.3,0.1))
}

\keyword{htest}

