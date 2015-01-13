\name{estimateContrasts}
\alias{estimateContrasts}
\alias{estimateContrasts1}
\alias{estimateContrasts2}
\title{Contrast Estimates}
\usage{
estimateContrasts(contrast.matrix, fit, row = TRUE, alpha = 0.05, L = NULL)
estimateContrasts1 (contrast.matrix, fit, alpha = 0.05, L)
estimateContrasts2 (contrast.matrix, fit, alpha = 0.05, row = TRUE, L)
}
\arguments{
\item{contrast.matrix}{a matrix of contrast coefficients. Separate rows of the matrix contain the contrast coefficients for that particular contrast, and a column for level of the factor.}
\item{fit}{output from the command "lm()".}
\item{row}{if T, and the ANOVA is two-way, then contrasts in the row effects are printed, otherwise contrasts in the column effects are printed. Ignored if the ANOVA is one-way.}
\item{alpha}{the nominal error rate for the multiple confidence intervals.}
\item{L}{number of contrasts. If NULL, L will be set to the number of rows in the contrast matrix, otherwise L will be as specified.}}

\description{Calculates and prints Tukey multiple confidence intervals
  for contrasts in one or two-way ANOVA.}

\value{Returns a matrix whose rows correspond to the different contrasts being estimated and whose columns correspond to the point estimate of the contrast, the Tukey lower and upper limits of the confidence interval, the unadjusted p-value, the Tukey and Bonferroni p-values.}

\seealso{
\code{"summary1way", "summary2way", "multipleComp"}
}

\examples{
## computer data:
data(computer.df)
attach(computer.df)
selfassess <- factor(selfassess)
computer.fit <- lm(score ~ selfassess)
contrast.matrix <- matrix(c(-1/2,-1/2,1),byrow=TRUE,nrow=1,ncol=3)
contrast.matrix
estimateContrasts(contrast.matrix,computer.fit)
detach(computer.df)
}
\keyword{models}

