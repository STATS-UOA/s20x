# Plot tslm residuals against fitted values

Draw the residuals-versus-fitted diagnostic panel for \`tslm\` objects.

## Usage

``` r
plotTslmResiduals(diagnosticData, residualType = "normalised", ...)
```

## Arguments

- diagnosticData:

  diagnostic data returned by \`getTslmDiagnosticData()\`.

- residualType:

  residual type label used for plot text.

- ...:

  additional graphical arguments passed to \[graphics::plot()\].

## Value

Called for its plotting side effect.
