test_that("openCaseStudy destination argument resolver keeps legacy and camelCase names", {
  tempPath = tempfile("case-study-destination")

  expect_identical(
    s20x:::resolveCaseStudyDestinationDir(dest_dir = tempPath),
    tempPath
  )
  expect_identical(
    s20x:::resolveCaseStudyDestinationDir(destDir = tempPath),
    tempPath
  )
})

test_that("openCaseStudy destination argument resolver rejects ambiguous or unsupported arguments", {
  expect_error(
    s20x:::resolveCaseStudyDestinationDir(dest_dir = tempfile(), destDir = tempfile()),
    "Use only one of dest_dir or destDir",
    fixed = TRUE
  )
  expect_error(
    s20x:::resolveCaseStudyDestinationDir(destination = tempfile()),
    "Unsupported case study argument",
    fixed = TRUE
  )
  expect_error(
    s20x:::resolveCaseStudyDestinationDir(destDir = ""),
    "`destDir` must be a single, non-empty character string",
    fixed = TRUE
  )
})
