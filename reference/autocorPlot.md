# Autocorrelation Plot

Plots current vs lagged residuals along with quadrants dividing these
residuals about the value zero.

## Usage

``` r
autocorPlot(fit, main = "Current vs Lagged residuals", ...)
```

## Arguments

- fit:

  output from the function 'lm()'.

- main:

  the plot title.

- ...:

  extra parameters to be passed to the `plot` function.

## Value

Plots current vs lagged residuals along with quadrants dividing these
residuals about the value zero.

## Note

Deprecated in s20x 3.4.0. Use `acf(residuals(fit))` instead.

`autocor.plot` is deprecated and no longer exported. Use `autocorPlot()`
in new code.

## Examples

``` r

data(airpass.df)
time = 1:144
airpass.fit = lm(passengers ~ time, data = airpass.df)
autocorPlot(airpass.fit)
#> Warning: autocorPlot() is deprecated; use acf(residuals(fit)) instead.

```
