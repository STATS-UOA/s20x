test_that("casestudy output argument resolver keeps legacy and camelCase names", {
  tempPath = tempfile("case-study-output")

  legacyArgs = getS20xInternal("resolveCaseStudyOutputArgs")(
    output_dir = tempPath,
    outputDirWasSupplied = TRUE
  )
  expect_identical(legacyArgs$outputDir, tempPath)
  expect_identical(legacyArgs$renderArgs, list())

  aliasArgs = getS20xInternal("resolveCaseStudyOutputArgs")(
    output_dir = tempfile("case-study-output-default"),
    outputDirWasSupplied = FALSE,
    outputDir = tempPath,
    output_format = "html_document"
  )
  expect_identical(aliasArgs$outputDir, tempPath)
  expect_identical(aliasArgs$renderArgs, list(output_format = "html_document"))
})

test_that("casestudy output argument resolver rejects ambiguous output names", {
  expect_error(
    getS20xInternal("resolveCaseStudyOutputArgs")(
      output_dir = tempfile(),
      outputDirWasSupplied = TRUE,
      outputDir = tempfile()
    ),
    "Use only one of output_dir or outputDir",
    fixed = TRUE
  )
  expect_error(
    getS20xInternal("resolveCaseStudyOutputArgs")(
      output_dir = "",
      outputDirWasSupplied = TRUE
    ),
    "`outputDir` must be a single, non-empty character string",
    fixed = TRUE
  )
})
