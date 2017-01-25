pkgname <- "s20x"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "s20x-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('s20x')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("autocor.plot")
### * autocor.plot

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: autocor.plot
### Title: Autocorrelation Plot
### Aliases: autocor.plot
### Keywords: hplot

### ** Examples

data(airpass.df)
time<-1:144
airpass.fit<-lm(passengers~time, data = airpass.df)
autocor.plot(airpass.fit)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("autocor.plot", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("boxqq")
### * boxqq

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: boxqq
### Title: Box plots and normal quantile-quantile plots
### Aliases: boxqq boxqq.formula
### Keywords: hplot

### ** Examples

## Zoo data
data(zoo.df)
boxqq(attendance~day.type, data = zoo.df)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("boxqq", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("ciReg")
### * ciReg

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: ciReg
### Title: Confidence Intervals for Regression models
### Aliases: ciReg
### Keywords: htest

### ** Examples

##Peruvian Indians data
data(peru.df)
fit<-lm(BP ~ age + years + weight + height, data = peru.df)
ciReg(fit)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("ciReg", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("cooks20x")
### * cooks20x

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: cooks20x
### Title: Cook's distance plot
### Aliases: cooks20x
### Keywords: hplot

### ** Examples

# Peruvian Indians data
data(peru.df)
fit1<-lm(BP~age+years+I(years^2)+weight+height, data = peru.df)
cooks20x(fit1)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("cooks20x", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("crossFactors")
### * crossFactors

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: crossFactors
### Title: Crossed Factors
### Aliases: crossFactors crossFactors.default crossFactors.formula
### Keywords: models

### ** Examples

## arousal data:
data(arousal.df)
gender.picture<-factor(crossFactors(arousal.df$gender,arousal.df$picture))
gender.picture

## arousal data:
data(arousal.df)
gender.picture<-factor(crossFactors(~gender*picture, data = arousal.df))
gender.picture




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("crossFactors", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("crosstabs")
### * crosstabs

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: crosstabs
### Title: Crosstabulation of two variables
### Aliases: crosstabs
### Keywords: htest

### ** Examples

##body image data:
data(body.df)
crosstabs(~ ethnicity + married, body.df)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("crosstabs", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("eovcheck")
### * eovcheck

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: eovcheck
### Title: Testing for equality of variance plot
### Aliases: eovcheck eovcheck.formula eovcheck.lm
### Keywords: hplot

### ** Examples

# one way ANOVA - oysters
data(oysters.df)
oyster.fit = lm(Oysters~Site, data = oysters.df)
eovcheck(oyster.fit)

# Same model as the previous example, but using eovcheck.formula
data(oysters.df)
eovcheck(Oysters~Site, data = oysters.df)


# A two-way model without interaction
data(soyabean.df)
soya.fit<-lm(yield~planttime+cultivar, data = soyabean.df)
eovcheck(soya.fit)

# A two-way model with interaction
data(arousal.df)
arousal.fit<-lm(arousal~gender*picture, data = arousal.df)
eovcheck(arousal.fit)

# A regression model
data(peru.df)
peru.fit<-lm(BP~height+weight+age+years, data = peru.df)
eovcheck(peru.fit)


# A time series model
data(airpass.df)
t<-1:144
month<-factor(rep(1:12,12))
airpass.df<-data.frame(passengers = airpass.df$passengers, t = t, month = month)
airpass.fit<-lm(log(passengers)[-1]~t[-1]+month[-1]+log(passengers)[-144], data  = airpass.df)
eovcheck(airpass.fit)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("eovcheck", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("estimateContrasts")
### * estimateContrasts

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: estimateContrasts
### Title: Contrast Estimates
### Aliases: estimateContrasts estimateContrasts1 estimateContrasts2
### Keywords: models

### ** Examples

## computer data:
data(computer.df)
computer.df <- within(computer.df, {selfassess <- factor(selfassess)})
computer.fit <- lm(score ~ selfassess, data = computer.df)
contrast.matrix <- matrix(c(-1/2,-1/2,1),byrow=TRUE,nrow=1,ncol=3)
contrast.matrix
estimateContrasts(contrast.matrix,computer.fit)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("estimateContrasts", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("freq1way")
### * freq1way

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: freq1way
### Title: Analysis of 1-dimensional frequency tables
### Aliases: freq1way
### Keywords: htest

### ** Examples

##Body image data:
data(body.df)
eth.table <- with(body.df, table(ethnicity))
freq1way(eth.table)
freq1way(eth.table,hypothprob=c(0.2,0.4,0.3,0.1))



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("freq1way", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("getVersion")
### * getVersion

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: getVersion
### Title: s20x pacakge version number
### Aliases: getVersion
### Keywords: debugging

### ** Examples

getVersion()



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("getVersion", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("interactionPlots")
### * interactionPlots

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: interactionPlots
### Title: Interactions Plot for Two-way Analysis of Variance
### Aliases: interactionPlots interactionPlots.default
###   interactionPlots.formula
### Keywords: hplot

### ** Examples

data(mtcars)
interactionPlots(wt~vs+gear, mtcars)

## note this usage is deprecated
data(mtcars)
with(mtcars, interactionPlots(wt,vs,gear))



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("interactionPlots", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("layout20x")
### * layout20x

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: layout20x
### Title: Layout
### Aliases: layout20x
### Keywords: device

### ** Examples

data(course.df)
layout20x(1,2)
stripchart(course.df$Exam)
boxplot(course.df$Exam)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("layout20x", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("levene.test")
### * levene.test

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: levene.test
### Title: Levene test for the ANOVA Assumption
### Aliases: levene.test
### Keywords: htest

### ** Examples

##
data(computer.df)
levene.test(score ~ factor(selfassess), computer.df)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("levene.test", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("multipleComp")
### * multipleComp

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: multipleComp
### Title: Multiple Comparisons
### Aliases: multipleComp
### Keywords: htest

### ** Examples

## computer data
data(computer.df)
fit <- lm(score ~ factor(selfassess), data = computer.df)
multipleComp(fit)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("multipleComp", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("normcheck")
### * normcheck

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: normcheck
### Title: Testing for normality plot
### Aliases: normcheck normcheck.default normcheck.lm
### Keywords: hplot

### ** Examples

# An exponential growth curve
e<-rnorm(100,0,0.1)
x<-rnorm(100)
y<-exp(5+3*x+e)
fit<-lm(y~x)
normcheck(fit)

# An exponential growth curve with the correct transformation
fit<-lm(log(y)~x)
normcheck(fit)

# Same example as above except we use normcheck.default
normcheck(residuals(fit))

# Peruvian Indians data
data(peru.df)
normcheck(lm(BP~weight, data=peru.df))



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("normcheck", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("onewayPlot")
### * onewayPlot

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: onewayPlot
### Title: One-way Analysis of Variance Plot
### Aliases: twosampPlot onewayPlot onewayPlot.default onewayPlot.formula
###   onewayPlot.lm
### Keywords: hplot

### ** Examples

##see example in "summary1way"

##computer data:
data(computer.df)
onewayPlot(score~selfassess, data = computer.df)


##apple data:
data(apples.df)
twosampPlot(Weight~Propagated, data = apples.df)

##oyster data:
data(oysters.df)
onewayPlot(log(Oysters)~Site, data = oysters.df)

##oyster data:
data(oysters.df)
oyster.fit = lm(log(Oysters)~Site, data = oysters.df)
onewayPlot(oyster.fit)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("onewayPlot", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("pairs20x")
### * pairs20x

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: pairs20x
### Title: Pairwise Scatter Plots with Histograms and Correlations
### Aliases: pairs20x
### Keywords: hplot

### ** Examples

##peruvian indians
data(peru.df)
pairs20x(peru.df)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("pairs20x", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("predict20x")
### * predict20x

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: predict20x
### Title: Model Predictions for a Linear Model
### Aliases: predict20x
### Keywords: htest

### ** Examples

# Zoo data
data(zoo.df)
zoo.df = within(zoo.df, {day.type = factor(day.type)})
zoo.fit = lm(log(attendance) ~ time + sun.yesterday + nice.day + day.type + tv.ads,
             data = zoo.df)
pred.zoo = data.frame(time = 8, sun.yesterday = 10.8, nice.day = 0,
                      day.type = factor(3), tv.ads = 1.181)
predict20x(zoo.fit, pred.zoo)

# Peruvian Indians data
data(peru.df)
peru.fit = lm(BP ~ age + years + I(years^2) + weight + height, data = peru.df)
pred.peru = data.frame(age = 21, years = 2, `I(years^2)` = 2, weight = 71, height = 1629)
predict20x(peru.fit, pred.peru)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("predict20x", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("residPlot")
### * residPlot

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: residPlot
### Title: Fitted values versus residuals plot
### Aliases: residPlot
### Keywords: hplot

### ** Examples

# Peruvian Indians data
data(peru.df)
fit<-lm(BP~age+years+weight+height, data = peru.df)
residPlot(fit)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("residPlot", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("rowdistr")
### * rowdistr

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: rowdistr
### Title: Row distributions from a cross-tabulation of two variables
### Aliases: rowdistr
### Keywords: htest

### ** Examples

data(body.df)
z <- crosstabs(~ ethnicity + married, data = body.df)
rowdistr(z)
rowdistr(z, comp="between")
rowdistr(z, comp="within")


##from matrix of counts
z <- matrix(c(4,3,2,6,47,20,40,62,11,8,7,22,3,0,1,10), 4, 4)
rowdistr(z)


base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("rowdistr", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("skewness")
### * skewness

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: skewness
### Title: Skewness Statistic
### Aliases: skewness
### Keywords: univar

### ** Examples

##Merger data:
data(mergers.df)
skewness(mergers.df$mergerdays)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("skewness", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("stripqq")
### * stripqq

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: stripqq
### Title: Strip charts and normal quantile-quantile plots
### Aliases: stripqq stripqq.formula
### Keywords: hplot

### ** Examples

## Zoo data
data(zoo.df)
stripqq(attendance~day.type, data = zoo.df)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("stripqq", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("summary1way")
### * summary1way

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: summary1way
### Title: One-way Analysis of Variance Summary
### Aliases: summary1way
### Keywords: models

### ** Examples

attitudes <- c(5.2,5.2,6.1,6,5.75,5.6,6.25,6.8,6.87,7.1,
               6.3,6.35,5.5,5.75,4.6,5.36,5.85,5.9)
l <- rep(c("Gp1","Gp2","Gp3"),rep(6,3))
l <- factor(l)
f <-lm(attitudes ~ l)
result <- summary1way(f)
result



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("summary1way", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("summary2way")
### * summary2way

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: summary2way
### Title: Two-way Analysis of Variance Summary
### Aliases: summary2way
### Keywords: models

### ** Examples

##Arousal data:
data(arousal.df)
arousal.fit = lm(arousal ~ gender * picture, data = arousal.df)
summary2way(arousal.fit)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("summary2way", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("summaryStats")
### * summaryStats

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: summaryStats
### Title: Summary Statistics
### Aliases: summaryStats summaryStats.default summaryStats.formula
###   summaryStats.matrix
### Keywords: multivariate

### ** Examples

## STATS20x data:
data(course.df)

## Single variable summary
with(course.df, summaryStats(Exam))

## Using a formula
summaryStats(Exam~Stage1, course.df)

## Using a matrix
X = cbind(rnorm(50), rnorm(50))
summaryStats(X)

## Saving and extracting the information
sumStats = summaryStats(Exam~Degree, course.df)
sumStats

## Just the BAs
sumStats["BA", ]

## Just the means
sumStats$mean



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("summaryStats", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("trendscatter")
### * trendscatter

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: trendscatter
### Title: Trend and scatter plot
### Aliases: trendscatter trendscatter.default trendscatter.formula
### Keywords: hplot

### ** Examples

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



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("trendscatter", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
