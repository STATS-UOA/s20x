\name{summary2way}
\alias{summary2way}
\title{Two-way Analysis of Variance Summary}
\usage{summary2way(fit, page = "table", digit = 5, conf.level = 0.95, print.out = TRUE, \dots)
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
\item{Df}{degrees of freedom for regression, residual and total.}
\item{Sum of Sq}{sum squares for regression, residual and total.}
\item{Mean Sq}{mean squares for regression and residual.}
\item{F value}{F-statistic value.}
\item{Pr(F)}{}
\item{Main Effect}{}
\item{Group Effects}{}
}

\examples{
##Arousal data:
data(arousal.df)
fit<-lm(arousal~gender+picture+gender*picture,data=arousal.df)
summary2way(fit)
}
\keyword{models}


