# Remove tslm error terms

Remove supported error-structure terms from the formula used for the
fitted mean model.

## Usage

``` r
removeTslmErrorTerms(formula, termsObject)
```

## Arguments

- formula:

  a model formula supplied to \[tslm()\].

- termsObject:

  a terms object created from \`formula\`.

## Value

A formula containing only the mean-model terms.
