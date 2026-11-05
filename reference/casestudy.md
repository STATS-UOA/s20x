# Render a case study to HTML

Renders a specified case study R Markdown file shipped with the package
to HTML and optionally opens it in a web browser.

## Usage

``` r
casestudy(
  id,
  output_dir = tempfile("s20x_case_study_"),
  open = interactive(),
  quiet = TRUE,
  ...
)

cs(...)
```

## Arguments

- id:

  A case study identifier. Flexible formats are accepted, including
  `"CS9_2"`, `"CS9.2"`, `"9_2"`, or `"9.2"`.

- output_dir:

  Directory where the rendered HTML file should be written. Defaults to
  a temporary directory. This legacy argument is retained for
  compatibility; new code may use the camelCase `outputDir` alias
  through `...`.

- open:

  Logical; if `TRUE` (default), open the rendered HTML file in the
  default web browser.

- quiet:

  Logical; passed to
  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
  to suppress output.

- ...:

  Additional arguments passed to
  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html).
  Also supports `outputDir`, a camelCase alias for `output_dir`.

## Value

Invisibly returns the path to the rendered HTML file.

## Details

Case studies are expected to live in `inst/case_studies` and to be named
using the pattern `CS<chapter>_<number>.Rmd` (for example, `CS9_2.Rmd`).

The case study is rendered on demand using
[`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html).
Figures and other outputs are generated at render time; users therefore
need any required packages installed for the selected case study.

The rendered HTML file is returned invisibly.

## Examples

``` r
if (interactive()) {
  casestudy("CS9_2")
  casestudy("9.2")
  casestudy("9_2", outputDir = tempdir())
  cs("9_2")
}
```
