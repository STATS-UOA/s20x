# Extract a tslm error specification

Extract and validate the supported autoregressive error term from parsed
formula terms.

## Usage

``` r
extractTslmErrorSpec(termsObject)
```

## Arguments

- termsObject:

  a terms object created from a \`tslm()\` formula.

## Value

\`NULL\` for independent errors, or a list describing the AR error
structure.
