# Summary Statistics

Produces a table of summary statistics for the data. If the argument
`group` is missing, calculates a matrix of summary statistics for the
data in `x`. If `group` is present, the elements of `group` are
interpreted as group labels and the summary statistics are displayed for
each group separately.

## Usage

``` r
summaryStats(x, ...)

# Default S3 method
summaryStats(
  x,
  group = rep("Data", length(x)),
  data.order = TRUE,
  digits = 2,
  ...
)

# S3 method for class 'formula'
summaryStats(x, data = NULL, data.order = TRUE, digits = 2, ...)

# S3 method for class 'matrix'
summaryStats(x, data.order = TRUE, digits = 2, ...)
```

## Arguments

- x:

  either a single vector of values, a formula of the form
  `data ~ group`, or a matrix.

- ...:

  Optional arguments that are passed to the summary statistic functions.
  For example `na.rm = TRUE` will help if there are missing values in
  the (response) variable.

- group:

  a vector of group labels.

- data.order:

  if `TRUE`, the group order is the order in which the groups are first
  encountered in `group`. If `FALSE`, the order is alphabetical.

- digits:

  the number of decimal places to display.

- data:

  an optional data frame containing the variables in the model.

## Value

A teaching summary is printed as a side effect. The returned value is
invisible so that classroom use can focus on the printed summary while
programmatic use can still save the result.

If `x` is a single variable and no grouping is supplied, an invisible
list is returned with the following named items:

- min:

  Minimum value.

- max:

  Maximum value.

- mean:

  Mean value.

- var:

  Variance – the average of the squares of the deviations of the data
  values from the sample mean.

- sd:

  Standard deviation – the square root of the variance.

- n:

  Number of data values – size of the dataset.

- nMissing:

  If there are missing values, and `na.rm` has been set to `TRUE`, the
  number of missing values.

- iqr:

  Midspread (IQR) – the range spanned by the central half of the data;
  the interquartile range.

- skewness:

  Skewness statistic – indicates how skewed the data set is. Positive
  values indicate right-skew data. Negative values indicate left-skew
  data.

- lq:

  Lower quartile.

- median:

  Median – the middle value when the batch is ordered.

- uq:

  Upper quartile.

If grouping is provided, either by using the `group` argument, by using
a formula, or by passing a matrix whose columns represent groups, the
function invisibly returns a `data.frame` with one row for each group
and columns containing the summary statistics.

## Methods (by class)

- `summaryStats(default)`: Summary Statistics

- `summaryStats(formula)`: Summary Statistics

- `summaryStats(matrix)`: Summary Statistics

## Examples

``` r

## STATS20x data:
data(course.df)

## Single variable summary
with(course.df, summaryStats(Exam))
#> Minimum value:           11 
#> Maximum value:           93 
#> Mean value:              52.88 
#> Median:                  51.5 
#> Upper quartile:          68.5 
#> Lower quartile:          40 
#> Variance:                348.87 
#> Standard deviation:      18.68 
#> Midspread (IQR):         28.5 
#> Skewness:                0.16 
#> Number of data values:   146 

## Using a formula
summaryStats(Exam ~ Stage1, course.df)
#>   Sample Size     Mean Median  Std Dev Midspread
#> A          49 68.75510     72 15.47381     20.00
#> B          46 51.52174     52 14.75238     19.75
#> C          51 38.84314     41 11.67625     16.50

## Using a matrix
courseMatrix = cbind(course.df$Exam, course.df$Assign, course.df$Test)
summaryStats(courseMatrix)
#>   Sample Size     Mean Median   Std Dev Midspread
#> 1         146 52.87671   51.5 18.677994      28.5
#> 2         146 13.82740   14.8  4.405115       5.5
#> 3         146 11.56712   11.8  3.779292       5.4

## Saving and extracting the information
sumStats = summaryStats(Exam ~ Degree, course.df)
#>       Sample Size     Mean Median  Std Dev Midspread
#> BA             17 52.41176   60.0 24.57402     43.00
#> BCom           49 58.81633   60.0 16.23868     24.00
#> BSc            64 45.82812   42.5 15.80090     17.25
#> Other          16 63.37500   66.0 19.76824     35.75
sumStats
#>       Sample Size     Mean Median  Std Dev Midspread
#> BA             17 52.41176   60.0 24.57402     43.00
#> BCom           49 58.81633   60.0 16.23868     24.00
#> BSc            64 45.82812   42.5 15.80090     17.25
#> Other          16 63.37500   66.0 19.76824     35.75

## Just the BAs
sumStats['BA', ]
#>    Sample Size     Mean Median  Std Dev Midspread
#> BA          17 52.41176     60 24.57402        43

## Just the means
sumStats$mean
#> [1] 52.41176 58.81633 45.82812 63.37500
```
