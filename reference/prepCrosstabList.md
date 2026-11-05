# Prepare row-distribution table summaries

Converts a two-way count table into the row, column, whole-table, and
total summaries used by \`rowdistr()\`.

## Usage

``` r
prepCrosstabList(crosstablist)
```

## Arguments

- crosstablist:

  matrix containing a two-way table of counts.

## Value

A list containing row proportions, column proportions, whole-table
proportions, and totals.
