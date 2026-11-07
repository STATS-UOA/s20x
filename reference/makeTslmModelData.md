# Make tslm model data

Build the model frame used internally by \`tslm()\`.

## Usage

``` r
makeTslmModelData(
  meanFormula,
  data,
  timeName = NULL,
  extraVars = NULL,
  subsetExpression = NULL
)
```

## Arguments

- meanFormula:

  formula used for the mean model after removing \`ar()\`.

- data:

  data frame or environment used to evaluate the model formula.

- timeName:

  optional name of the time variable.

- extraVars:

  optional names used by other arguments, such as \`weights\`. Those
  that are not data variables are left out.

- subsetExpression:

  optional unevaluated \`subset\` expression.

## Value

A model frame containing the mean-model variables and, when supplied,
the time variable.
