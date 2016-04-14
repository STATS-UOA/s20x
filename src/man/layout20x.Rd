\name{layout20x}
\alias{layout20x}
\title{Layout}
\usage{layout20x(numRows, numCols)}

\arguments{
\item{numRows}{number of rows in plot array}
\item{numCols}{number of columns in plot array}
}

\description{Allows an \code{numRows} by \code{numCols} matrix of plots to be displayed in a single plot. If the function is called with no arguments, then the plotting device layout will be reset to a single plot.}

\value{Function returns no value}

\examples{
data(course.df)
layout20x(1,2)
stripchart(course.df$Exam)
boxplot(course.df$Exam)
}

\keyword{device}

