# Match a plotting engine argument

Applies the standard plotting engine argument matching used by exported
plotting functions. Keeping this in one place makes engine-dispatch
cleanup stages less repetitive without changing the accepted engine
values.

## Usage

``` r
matchPlottingEngine(engine, choices = c("base", "ggplot2"))
```

## Arguments

- engine:

  character plotting engine argument.

- choices:

  character vector of accepted plotting engines.

## Value

The matched plotting engine.
