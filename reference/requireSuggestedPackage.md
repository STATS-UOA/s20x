# Require a suggested package

Check that a suggested package is installed before optional
functionality uses it.

## Usage

``` r
requireSuggestedPackage(package)
```

## Arguments

- package:

  package name.

## Value

Invisibly returns \`TRUE\`, or errors if the package is unavailable.
