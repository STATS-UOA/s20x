# Plot tslm residuals over time

Draw the residuals-over-time diagnostic panel for \`tslm\` objects.

## Usage

``` r
plotTslmTimeResiduals(diagnosticData, object, residualType = "normalised", ...)
```

## Arguments

- diagnosticData:

  diagnostic data returned by \`getTslmDiagnosticData()\`.

- object:

  a fitted \`tslm\` object.

- residualType:

  residual type label used for plot text.

- ...:

  additional graphical arguments passed to \[graphics::plot()\].

## Value

Called for its plotting side effect.
