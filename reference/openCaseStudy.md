# Open a case study source file in the editor

Opens a case study `.Rmd` file for interactive use. The file shipped
inside the package is copied to `dest_dir` (so it is writable), then
opened in the RStudio editor when available (otherwise the system
editor).

## Usage

``` r
openCaseStudy(id, dest_dir = getwd(), overwrite = FALSE, ...)

opencs(id, dest_dir = getwd(), overwrite = FALSE, ...)

ocs(id, dest_dir = getwd(), overwrite = FALSE, ...)
```

## Arguments

- id:

  Case study identifier. Flexible formats are accepted, including
  `"CS9_2"`, `"CS9.2"`, `"9_2"`, or `"9.2"`.

- dest_dir:

  Directory to copy the case study into. Defaults to the current working
  directory. This legacy argument is retained for compatibility; new
  code may use the camelCase `destDir` alias through `...`.

- overwrite:

  Logical; overwrite an existing file in `dest_dir`.

- ...:

  Additional compatibility arguments. Currently supports `destDir`, a
  camelCase alias for `dest_dir`.

## Value

Invisibly returns the path to the copied file.

## Examples

``` r
if (interactive()) {
  openCaseStudy("2.1")
  openCaseStudy("2.1", destDir = tempdir())
}
```
