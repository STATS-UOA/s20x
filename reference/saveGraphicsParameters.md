# Save graphics parameters for later restoration

Captures a graphics-parameter state and returns a closure that restores
it. This helper centralises the common \`par()\`/\`on.exit()\` pattern
used by diagnostic plotting functions.

## Usage

``` r
saveGraphicsParameters(..., noReadonly = FALSE)
```

## Arguments

- ...:

  Graphics parameters passed to \[graphics::par()\] when \`noReadonly =
  FALSE\`.

- noReadonly:

  Logical; if \`TRUE\`, save all readonly-safe graphics parameters using
  \`par(no.readonly = TRUE)\`.

## Value

A function that restores the saved graphics parameters and invisibly
returns them.
