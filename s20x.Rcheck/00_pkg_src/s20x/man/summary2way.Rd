\name{summary2way}
\alias{summary2way}
\title{Two-way Analysis of Variance Summary}
\usage{summary2way(fit, page = c("table", "means", "effects", "interaction", "nointeraction"), 
                   digit = 5, conf.level = 0.95, print.out = TRUE, \dots)
}
\arguments{
\item{fit}{an lm object, i.e. the output from "lm()".}
\item{page}{options for output:  "table", "means", "effects", "interaction", "nointeraction"}
\item{digit}{the number of decimal places in the display.}
\item{conf.level}{confidence level of the intervals.}
\item{print.out}{if TRUE, print out the output on the screen.}
\item{\dots}{other arguments like inttype, pooled etc.}}

\description{Displays summary information for a two-way anova
     analysis. The lm object must come from a numerical
     response variable and factors. The output depends on the value of page:

     page = "table"         anova table
     page = "means"         cell means matrix, numeric summary
     page = "effects"       table of effects
     page = "interaction"   tables of contrasts
     page = "nointeraction" tables of contrasts
}

\seealso{
\code{"summary1way"}
}

\value{
A list with the following components:
\item{Df}{degrees of freedom for regression, residual and total.}
\item{Sum of Sq}{sum squares for regression, residual and total.}
\item{Mean Sq}{mean squares for regression and residual.}
\item{F value}{F-statistic value.}
\item{Pr(F)}{The P-value assoicated with each F-test.}
\item{Grand Mean}{The overall mean of the response variable.}
\item{Row Effects}{The main effects for the first (row) factor.}
\item{Col Effects}{The main effects for the second (column) factor.}
\item{Interaction Effects}{The interaction effects if an interaction model has been fitted, otherwise \code{NULL}.}
\item{Comparisons}{This item will be \code{NULL} for any choice of \code{page} other than \code{"interaction"} or \code{"nointeraction"}. If an interaction model has been fitted, and \code{page = "interaction"} then this will be a list with two components named \code{within} and \code{between}. If an additive model has been fitted, and \code{page = "nointeraction"} then this will be a list with two components with the same names as the first (row) factor and the second (column) factor. Each component is a matrix with four columns: the estimate, the Tukey HSD lower and upper bounds on the estimate and the P-value for the hypothesis test that the difference in the means is 0.}
}

\examples{
##Arousal data:
data(arousal.df)
arousal.fit = lm(arousal ~ gender * picture, data = arousal.df)
summary2way(arousal.fit)
}
\keyword{models}


