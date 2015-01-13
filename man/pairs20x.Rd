\name{pairs20x}
\alias{pairs20x}
\title{Pairwise Scatter Plots with Histograms and Correlations}
\usage{
pairs20x(x, ...)
}

\arguments{
  \item{x}{a data frame.}
  \item{\dots}{optional argumments which are passed to the generic pairs
  function.}
}
\description{Plots pairwise scatter plots with histograms and correlations for the data frame.}

\value{Returns the plots.}

\seealso{
\code{"pairs", "panel.smooth", "panel.cor", "panel.hist"}
}

\examples{
##peruvian indians
data(peru.df)
pairs20x(peru.df)
}

\keyword{hplot}

