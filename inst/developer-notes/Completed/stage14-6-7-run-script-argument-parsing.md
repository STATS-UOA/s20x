# Stage 14.6.7 run-script argument parsing fix

Stage 14.6.7 is a run-script continuation fix for Stage 14.6.5 and Stage 14.6.6.

The previous continuation script treated its first command-line argument as a change-set zip path. This failed when the shared `scripts/runStage.sh` wrapper passed the `--install-files` flag, because the stage script attempted to unzip the literal string `--install-files`.

This stage updates the run script to parse options before resolving the optional change-set zip. It keeps package code, data, generated documentation, `DESCRIPTION`, `NEWS.md`, and `NAMESPACE` unchanged.
