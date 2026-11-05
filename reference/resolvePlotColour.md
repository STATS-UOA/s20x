# Resolve a plotting colour argument

Accepts anything R can draw with, such as a colour name, a hex string or
a palette number. Abbreviated colour names are completed against
\`choices\`.

## Usage

``` r
resolvePlotColour(colour, choices, argumentName)
```

## Arguments

- colour:

  colour supplied by the user.

- choices:

  colour names available for completion.

- argumentName:

  argument name used in the error message.

## Value

The completed colour name, or \`colour\` unchanged.
