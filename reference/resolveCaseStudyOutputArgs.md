# Resolve case-study output arguments

Normalise legacy and camelCase output-directory arguments for
\`casestudy()\`.

## Usage

``` r
resolveCaseStudyOutputArgs(output_dir, outputDirWasSupplied, ...)
```

## Arguments

- output_dir:

  legacy output directory argument.

- outputDirWasSupplied:

  logical; whether \`output_dir\` was supplied by the caller.

- ...:

  additional rendering arguments.

## Value

A list containing \`outputDir\` and remaining \`renderArgs\`.
