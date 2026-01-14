s20x
====

## 3.2.2
A small number of the datasets have been slightly altered, and their associated documentation accordingly. The changes 
consist of adding some useful extra variables to the three time series data sets `airpass.df`, `beer.df` and `larain.df`.
These variables are `t` which is just a time index to save the user creating it if they want to fit a lag response model,
and either `month` and `year` or both. These are factor variables giving the year the observation recorded, and if relevant
the month. These extra variables can be used for time series analysis or plots. 

In addition we have made an attempt to use SI units rather than imperial units where sensible. Some examples of where 
it is sensible: converting inches to millimetres, pounds to kilograms, and acre-feet/gallons to litres (or megalitres).
Some examples of where it is not sensible are carats (industry standard) and converting blood pressue to kiloPascals 
instead of millimetres of mecury (mm Hg), which again is the health profession standard. If these conversions have been made,
then they have been done as extra variables added to the data set, rather than replacing the original measurements. The
logic for this is to preseve the data sets as is to avoid lecture notes mismatches - at least for the time being.

A repository for the University of Auckland s20x R library. This library is used in our large undergrad classes STATS 201, STATS 208 and BIOSCI 209


# Build Notes

We will attempt to add information about the changes in each new release (whether it makes it to CRAN or not) here, from version 3.1-21 onwards

## 3.1-21

Ben Stevenson added some code to summary2way so the attribute information from `TukeyHSD` is preserved. That is so you see this

```
> summary2way(fit, page = "interaction")
  Tukey multiple comparisons of means
    95% family-wise confidence level

Fit: aov(formula = fit)

$`store:crust`
```

instead of this

```
> summary2way(fit, page = "interaction")
$`store:crust`
```

## 3.1-24

A new function called `modcheck` has been added. This allows the plotting of all four standard 20x model checking plots: a pred-res or equality of variance plot, a normal Q-Q plot, a histogram of the residuals, and a Cook's distance plot, to be drawn on the same plot at once. This function needed a much more flexible version of `normcheck`, and needed modifications to `eovcheck` and `cooks20x`. I have not put it on CRAN yet because of the chance that it will fail for our current students. We *really* need some unit testing in this package so that this process can be sped up.