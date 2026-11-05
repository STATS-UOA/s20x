# Get model residual and fitted-value data

Extract residuals and fitted values from a fitted model and validate
that the two vectors are aligned for diagnostic plotting.

## Usage

``` r
getModelResidualFittedData(object, residualType = NULL, context = "model")
```

## Arguments

- object:

  a fitted model object.

- residualType:

  optional residual type passed to \[stats::residuals()\].

- context:

  character description used in error messages.

## Value

A list with \`fitted\` and \`residuals\` components.
