\name{crossFactors}
\alias{crossFactors}
\alias{crossFactors.default}
\alias{crossFactors.formula}
\title{Crossed Factors}
\usage{
crossFactors(x, fac2 = NULL, \dots)
\method{crossFactors}{default}(x, fac2 = NULL, \dots)
\method{crossFactors}{formula}(formula, fac2 = NULL, data = NULL, \dots)
}

\arguments{
  \item{x}{the name of the first factor or a formula in the form
    ~fac1*fac2}
  \item{fac2}{the name of the second factor - optional if x is a
    formula.}
  \item{formula}{a formula in the form ~fac1*fac2}
  \item{data}{an optional data frame in which to evaluate the formula}
  \item{\dots}{Optional arguments}
}

\description{Computes a factor that has a level for each combination of
  the factors "fac1" and "fac2".}

\value{Returns a vector containing the factor which represents the interaction of the given factors.}

\seealso{"factor".}

\examples{
## arousal data:
data(arousal.df)
gender.picture<-factor(crossFactors(arousal.df$gender,arousal.df$picture))
gender.picture

## arousal data:
data(arousal.df)
gender.picture<-factor(crossFactors(~gender*picture, data = arousal.df))
gender.picture

}

\keyword{models}

