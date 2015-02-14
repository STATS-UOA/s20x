\name{trendscatter}
\alias{trendscatter}
\alias{trendscatter.default}
\alias{trendscatter.formula}
\title{Trend and scatter plot}
\usage{
trendscatter(x, \dots)
\method{trendscatter}{default} (x, y = NULL, f = 0.5, xlab = NULL, ylab = NULL, main = NULL, \dots)
\method{trendscatter}{formula} (x, f = 0.5, data, xlab = NULL, ylab = NULL, main = NULL, \dots)
}
\arguments{
  \item{x}{the coordinates of the points in the scatter
    plot. Alternatively, a function.}

 \item{y}{the y coordinates of the points in the plot, ignored if
    'x' is a function.}
 \item{f}{the smoother span. This gives the proportion of points in the
          plot which influence the smooth at each value. Larger values
          give more smoothness.}
 \item{data}{an optional data frame containing the variables in the model.}
 \item{xlab}{a title for the x axis: see \code{\link{title}}.}
 \item{ylab}{a title for the y axis: see
	  \code{\link{title}}.}
  \item{main}{a title for the plot: see
    \code{\link{title}}.}
 \item{\dots}{Optional arguments}
}
\description{
Plots a scatter plot for the variables x, y along with a lowess smooth for the underlying trend. One standard deviation
error bounds for the scatter about this trend are also plotted.
}
\value{Returns the plot.}
\seealso{"residPlot"}

\examples{
# A simple polynomial
x<-rnorm(100)
e<-rnorm(100)
y<-2+3*x-2*x^2+4*x^3+e
trendscatter(y~x)

# An exponential growth curve
e<-rnorm(100,0,0.1)
y<-exp(5+3*x+e)
trendscatter(log(y)~x)

# Peruvian Indians data
data(peru.df)
trendscatter(BP~weight, data=peru.df)

# Note: this usage is deprecated
with(peru.df,trendscatter(weight,BP))
}

\keyword{hplot}
