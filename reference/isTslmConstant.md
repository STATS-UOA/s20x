# Check whether a formula name is a constant

Check whether a formula name is a constant

## Usage

``` r
isTslmConstant(name, data, envir)
```

## Arguments

- name:

  variable name.

- data:

  data frame or environment used to evaluate the model formula.

- envir:

  environment of the model formula.

## Value

\`TRUE\` when \`name\` is a single value that is not a column of
\`data\`.
