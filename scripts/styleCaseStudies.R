#!/usr/bin/env Rscript

# Keep the code in the case studies consistently spaced.
#
#   Rscript scripts/styleCaseStudies.R          # rewrite the files
#   Rscript scripts/styleCaseStudies.R --check  # fail if any file needs styling
#
# The scope stops at line breaks because styler's full tidyverse style would
# also change = to <- for assignment.

args = commandArgs(trailingOnly = TRUE)
checkOnly = "--check" %in% args

caseStudies = list.files(file.path("inst", "case_studies"), pattern = "[.]Rmd$", full.names = TRUE)

result = styler::style_file(
  caseStudies,
  transformers = styler::tidyverse_style(scope = "line_breaks"),
  dry = if (checkOnly) "on" else "off"
)

if (anyNA(result$changed)) {
  stop(
    "Could not style: ",
    paste(result$file[is.na(result$changed)], collapse = ", "),
    call. = FALSE
  )
}

needStyling = result$file[result$changed]

if (checkOnly && length(needStyling) > 0) {
  message("These case studies need styling:\n", paste(" ", needStyling, collapse = "\n"))
  message("Run: Rscript scripts/styleCaseStudies.R")
  quit(status = 1)
}

message(
  if (checkOnly) "All case studies are styled." else paste("Styled", length(needStyling), "case studies.")
)
