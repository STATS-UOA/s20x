# List available case studies

Lists all case study R Markdown files shipped with the package and
prints them as a formatted text table.

## Usage

``` r
listCaseStudies()

listCS()

lcs()
```

## Value

Invisibly returns a character vector of case study identifiers.

## Details

Case studies are expected to live in `inst/case_studies` and to be named
using the pattern `CS<chapter>_<number>.Rmd` (e.g. `CS9_2.Rmd`).

The table has two columns: `File` (the case study identifier) and
`Title` (extracted from the YAML header). Case studies are listed in
numerical order, not alphabetical order.

The function invisibly returns a character vector of case study
identifiers.

## Examples

``` r
if (interactive()) {
  listCaseStudies()
  ids = listCaseStudies()
}
```
