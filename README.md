s20x
====

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

