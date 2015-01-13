\name{layout20x}
\alias{layout20x}
\title{Layout}
\usage{layout20x(x,y)}

\arguments{
\item{x}{number of rows in plot array.}
\item{y}{number of columns in plot array.}
}

\description{Specifies an m*n array of plots in the graphics window.}

\value{Function returns no value.}

\examples{
data(course.df)
layout20x(1,2)
stripchart(course.df$Exam)
boxplot(course.df$Exam)
}

\keyword{device}

