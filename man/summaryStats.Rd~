\name{summaryStats}
\alias{summaryStats}
\alias{summaryStats.default}
\alias{summaryStats.formula}

\title{Summary Statistics}
\usage{
summaryStats(x, \dots)
\method{summaryStats}{default} (x, group = rep("Data", length(x)), data.order = TRUE, digits = 2, \dots)
\method{summaryStats}{formula} (x, data, data.order = TRUE, digits = 2, \dots)
}

\arguments{
\item{x}{either a single vector of values, or a formula of the form data~group.}
\item{data}{an optional data frame containing the variables in the model.}
\item{group}{a vector of group labels.}
\item{data.order}{if T, the group order is the order which the groups are first encountered in the vector "group". If F, the order is alphabetical.}
\item{digits}{the number of decimal places to display.}
\item{\dots}{Optional arguments.}
}

\description{Produces a table of summary statistics for the data. If the
  argument "group" is missing, calculates a matrix of summary statistics
  for the data in "data". If "group" is present, the elements of "group"
  are interpreted as group labels and the summary statistics are
  displayed for each group separately.}

\value{Returns a matrix containing the following components:
\item{Minimum value}{}
\item{Maximum value}{}
\item{Mean value}{the average value.}
\item{Median}{the middle value when the batch is ordered.}
\item{Upper quartile}{}
\item{Lower quartile}{}
\item{Variance}{the average of the squares of the deviations of the data values from the sample mean.}
\item{Standard deviation}{the square root of the variance.}
\item{Midspread (IQR)}{the range spanned by central half of data; the
    interquartile range}
\item{Skewness}{indicates how skewed the data set is. Positive values indicate right-skew data.}
\item{Symmetry statistic(alpha=0.05)}{another symmetry measure, values close to 0.5 correspond to reasonably symmetric data.}
\item{Symmetry statistic(alpha=0.10)}{alpha by default.}
\item{Number of data values}{size of the data set.}
}

\examples{
## STATS20x data:
data(course.df)
attach(course.df)
summaryStats(Exam)
detach(course.df)

summaryStats(Exam~Stage1, course.df)

## Note this usage is deprecated.
attach(course.df)
summaryStats(Exam,Stage1)
detach(course.df)
}

\keyword{multivariate}


