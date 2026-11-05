# Print ggplot2 modelcheck plots

Draws multiple ggplot2 modelcheck plots together so the ggplot2 engine
gives a single printed diagnostic display rather than showing list
structure at the console.

## Usage

``` r
# S3 method for class 's20xModelcheck_ggplot2'
print(x, ...)
```

## Arguments

- x:

  an object returned by `modelcheck(..., engine = "ggplot2")` when
  multiple plots are selected.

- ...:

  additional arguments passed to `print.ggplot`.

## Value

Invisibly returns `x`.
