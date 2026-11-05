#!/usr/bin/env Rscript

# Copy the case studies into vignettes/articles so that pkgdown builds them as
# articles. The copies are generated and git-ignored; inst/case_studies is the
# only source to edit.

articleDir = file.path("vignettes", "articles")
dir.create(articleDir, recursive = TRUE, showWarnings = FALSE)

caseStudies = list.files(file.path("inst", "case_studies"), pattern = "[.]Rmd$", full.names = TRUE)
file.copy(caseStudies, articleDir, overwrite = TRUE)

message("Copied ", length(caseStudies), " case studies to ", articleDir)
