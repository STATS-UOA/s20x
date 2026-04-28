#!/usr/bin/env Rscript

# Create a compact ChatGPT bundle for staged WMFM development.
#
# Run from the package root, for example:
#   Rscript scripts/makeChatgptBundle.R --stage 10.1
#   Rscript scripts/makeChatgptBundle.R --stage 10.1 --base master
#   Rscript scripts/makeChatgptBundle.R --stage 10.1 --include-tests

readArgs = function(args) {
    out = list(
        stage = NULL,
        base = "HEAD",
        outputDir = "chatgpt-bundles",
        includeTests = FALSE,
        includeAllChangedFiles = TRUE
    )

    i = 1
    while (i <= length(args)) {
        arg = args[[i]]

        if (arg == "--stage") {
            i = i + 1
            out$stage = args[[i]]
        } else if (arg == "--base") {
            i = i + 1
            out$base = args[[i]]
        } else if (arg == "--output-dir") {
            i = i + 1
            out$outputDir = args[[i]]
        } else if (arg == "--include-tests") {
            out$includeTests = TRUE
        } else if (arg == "--changed-files-only") {
            out$includeAllChangedFiles = TRUE
        } else if (arg %in% c("--help", "-h")) {
            printUsage()
            quit(status = 0)
        } else {
            stop("Unknown argument: ", arg, call. = FALSE)
        }

        i = i + 1
    }

    if (is.null(out$stage) || !nzchar(out$stage)) {
        stop("Please provide a stage label with --stage, for example --stage 10.1", call. = FALSE)
    }

    out
}

printUsage = function() {
    cat(
        paste(
            "Usage:",
            "  Rscript scripts/makeChatgptBundle.R --stage STAGE [options]",
            "",
            "Options:",
            "  --stage STAGE            Stage label, for example 10.1",
            "  --base REF               Git ref to diff against; default: HEAD",
            "  --output-dir DIR         Output directory; default: chatgpt-bundles",
            "  --include-tests          Include tests/testthat if present",
            "  --help, -h               Show this help",
            "",
            "Examples:",
            "  Rscript scripts/makeChatgptBundle.R --stage 10.1",
            "  Rscript scripts/makeChatgptBundle.R --stage 10.1 --base stage9_completed",
            sep = "\n"
        ),
        "\n"
    )
}

runCommand = function(command, args = character(), allowFailure = FALSE) {
    result = tryCatch(
        system2(command, args = args, stdout = TRUE, stderr = TRUE),
        warning = function(w) {
            structure(conditionMessage(w), status = 1)
        },
        error = function(e) {
            structure(conditionMessage(e), status = 1)
        }
    )

    status = attr(result, "status")
    if (is.null(status)) {
        status = 0
    }

    if (!allowFailure && !identical(status, 0)) {
        stop(
            "Command failed: ",
            paste(c(command, args), collapse = " "),
            "\n",
            paste(result, collapse = "\n"),
            call. = FALSE
        )
    }

    paste(result, collapse = "\n")
}

safeStageName = function(stage) {
    gsub("[^A-Za-z0-9._-]+", "_", stage)
}

checkProjectRoot = function() {
    if (!file.exists("DESCRIPTION")) {
        stop("DESCRIPTION was not found. Please run this script from the package root.", call. = FALSE)
    }

    insideGit = runCommand("git", c("rev-parse", "--is-inside-work-tree"), allowFailure = TRUE)
    if (!identical(trimws(insideGit), "true")) {
        stop("This directory does not appear to be inside a git work tree.", call. = FALSE)
    }
}

getChangedFiles = function(baseRef) {
    diffFiles = runCommand(
        "git",
        c("diff", "--name-only", paste0(baseRef, "...HEAD")),
        allowFailure = TRUE
    )

    workingFiles = runCommand(
        "git",
        c("diff", "--name-only"),
        allowFailure = TRUE
    )

    stagedFiles = runCommand(
        "git",
        c("diff", "--cached", "--name-only"),
        allowFailure = TRUE
    )

    untrackedFiles = runCommand(
        "git",
        c("ls-files", "--others", "--exclude-standard"),
        allowFailure = TRUE
    )

    files = unique(c(
        strsplit(diffFiles, "\n", fixed = TRUE)[[1]],
        strsplit(workingFiles, "\n", fixed = TRUE)[[1]],
        strsplit(stagedFiles, "\n", fixed = TRUE)[[1]],
        strsplit(untrackedFiles, "\n", fixed = TRUE)[[1]]
    ))

    files = files[nzchar(files)]
    files[file.exists(files) & !dir.exists(files)]
}

copyIfExists = function(path, bundleRoot) {
    if (!file.exists(path)) {
        return(invisible(FALSE))
    }

    destination = file.path(bundleRoot, "project-files", path)
    dir.create(dirname(destination), recursive = TRUE, showWarnings = FALSE)
    file.copy(path, destination, overwrite = TRUE)
    invisible(TRUE)
}

copyDirectoryIfExists = function(path, bundleRoot) {
    if (!dir.exists(path)) {
        return(invisible(FALSE))
    }

    files = list.files(path, recursive = TRUE, all.files = TRUE, no.. = TRUE, full.names = TRUE)
    files = files[!dir.exists(files)]

    for (file in files) {
        copyIfExists(file, bundleRoot)
    }

    invisible(TRUE)
}

writeTextFile = function(path, text) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    writeLines(text, path, useBytes = TRUE)
}

makeContextMarkdown = function(stage, baseRef, changedFiles) {
    changedList = if (length(changedFiles) > 0) {
        paste0("- ", changedFiles, collapse = "\n")
    } else {
        "- No changed files detected"
    }

    paste(
        "# ChatGPT stage bundle",
        "",
        paste0("Stage: ", stage),
        paste0("Base ref: ", baseRef),
        paste0("Created: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
        "",
        "## Intended use",
        "",
        "This bundle is intended to give ChatGPT compact project context for the current WMFM stage.",
        "It includes git status, git diffs, selected project metadata, and changed files.",
        "",
        "## Suggested prompt",
        "",
        paste0(
            "I am working on Stage ", stage,
            " of the What is my fitted model App. Treat this bundle as the current project context. ",
            "Please use my R development style and staged workflow conventions."
        ),
        "",
        "## Changed files included",
        "",
        changedList,
        "",
        "## Notes for this stage",
        "",
        "- Add manual notes here before uploading if needed.",
        "- Mention any tests that failed or any behaviour you want reviewed.",
        sep = "\n"
    )
}

createBundle = function(options) {
    checkProjectRoot()

    stageName = safeStageName(options$stage)
    timestamp = format(Sys.time(), "%Y%m%d-%H%M%S")
    bundleName = paste0("stage", stageName, "_chatgpt_bundle_", timestamp)
    bundleRoot = file.path(options$outputDir, bundleName)

    dir.create(bundleRoot, recursive = TRUE, showWarnings = FALSE)
    dir.create(file.path(bundleRoot, "git"), recursive = TRUE, showWarnings = FALSE)
    dir.create(file.path(bundleRoot, "project-files"), recursive = TRUE, showWarnings = FALSE)

    changedFiles = getChangedFiles(options$base)

    writeTextFile(
        file.path(bundleRoot, "stage-context.md"),
        makeContextMarkdown(options$stage, options$base, changedFiles)
    )

    writeTextFile(
        file.path(bundleRoot, "git", "status.txt"),
        runCommand("git", c("status", "--short", "--branch"), allowFailure = TRUE)
    )

    writeTextFile(
        file.path(bundleRoot, "git", "diff-from-base.patch"),
        runCommand("git", c("diff", paste0(options$base, "...HEAD")), allowFailure = TRUE)
    )

    writeTextFile(
        file.path(bundleRoot, "git", "diff-working-tree.patch"),
        runCommand("git", c("diff"), allowFailure = TRUE)
    )

    writeTextFile(
        file.path(bundleRoot, "git", "diff-staged.patch"),
        runCommand("git", c("diff", "--cached"), allowFailure = TRUE)
    )

    writeTextFile(
        file.path(bundleRoot, "git", "recent-log.txt"),
        runCommand("git", c("log", "--oneline", "--decorate", "-20"), allowFailure = TRUE)
    )

    alwaysInclude = c(
        "DESCRIPTION",
        "NAMESPACE",
        ".Rbuildignore",
        "README.md",
        "NEWS.md"
    )

    for (path in alwaysInclude) {
        copyIfExists(path, bundleRoot)
    }

    for (path in changedFiles) {
        copyIfExists(path, bundleRoot)
    }

    if (isTRUE(options$includeTests)) {
        copyDirectoryIfExists("tests/testthat", bundleRoot)
    }

    outputDirAbs = normalizePath(options$outputDir, winslash = "/", mustWork = TRUE)

    oldWd = getwd()
    on.exit(setwd(oldWd), add = TRUE)
    setwd(outputDirAbs)

    zipFile = paste0(bundleName, ".zip")
    zipPath = file.path(outputDirAbs, zipFile)

    if (file.exists(zipPath)) {
        unlink(zipPath)
    }

    zipStatus = utils::zip(zipfile = zipFile, files = bundleName)
    if (!identical(zipStatus, 0L)) {
        stop("Failed to create zip file: ", zipPath, call. = FALSE)
    }

    unlink(file.path(outputDirAbs, bundleName), recursive = TRUE, force = TRUE)

    normalizePath(zipPath, winslash = "/", mustWork = TRUE)
}

main = function() {
    options = readArgs(commandArgs(trailingOnly = TRUE))
    zipPath = createBundle(options)

    cat("Created ChatGPT bundle:\n")
    cat(zipPath, "\n", sep = "")
}

main()
