\name{rowdistr}
\alias{rowdistr}
\title{Row distributions from a cross-tabulation of two variables}
\usage{rowdistr(crosstablist, comp = c("basic", "within", "between"), conf.level = 0.95, 
                plot = TRUE, suppressText = FALSE)}
\arguments{
\item{crosstablist}{a list produced by "crosstabs" or a matrix containing a 2-way table of counts (without marginal totals).}
\item{comp}{three options: "basic" (default), "within", and "between".}
\item{conf.level}{confidence level of the intervals.}
\item{plot}{if FALSE then the row distribution plots are not displayed}
\item{suppressText}{if TRUE then text results are not displayed}
}
\description{Produces summaries and plots from a cross-tabulation.  The output produced depends on the parameter "comp". Columns relate to response categories and rows to different populations.
}

\value{A matrix of row proportions, i.e cell counts divided by row marginals.}

\details{The "basic" option (default) produces the response distribution for each row population together with comparative bar charts.

If comp = "between" the resulting output displays how the probability of falling into a response class (column) differs between populations.  Confidence intervals for differences in proportions are produced together with a set of barcharts with LSD intervals.

If comp = "within" the resulting output shows the extent to which the component probabilities of the same row distribution differ. Separate Chi-square tests for uniformity are produced for each row distribution as are confidence intervals for differences in proportions within the same distribution.

Arguments \code{plot} and \code{suppressText} are really only used when producing knitr or Sweave documents so that just the plot or just the text can be displayed in the document.
}

\seealso{"crosstabs"}

\examples{
data(body.df)
z <- crosstabs(~ ethnicity + married, data = body.df)
rowdistr(z)
rowdistr(z, comp="between")
rowdistr(z, comp="within")


##from matrix of counts
z <- matrix(c(4,3,2,6,47,20,40,62,11,8,7,22,3,0,1,10), 4, 4)
rowdistr(z)}

\keyword{htest}

