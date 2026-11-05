# Get tslm diagnostic data

Collect fitted values, residuals, and time values for \`tslm\`
diagnostic plots.

## Usage

``` r
getTslmDiagnosticData(object, residualType = "normalised")
```

## Arguments

- object:

  a fitted \`tslm\` object.

- residualType:

  residual type requested for diagnostic plots.

## Value

A list with \`fitted\`, \`residuals\`, and \`time\` components, each
sorted into time order so that autocorrelation is read in the correct
sequence.
