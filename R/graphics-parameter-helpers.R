#' Save graphics parameters for later restoration
#'
#' Captures a graphics-parameter state and returns a closure that restores it.
#' This helper centralises the common `par()`/`on.exit()` pattern used by
#' diagnostic plotting functions.
#'
#' @param ... Graphics parameters passed to [graphics::par()] when
#'   `noReadonly = FALSE`.
#' @param noReadonly Logical; if `TRUE`, save all readonly-safe graphics
#'   parameters using `par(no.readonly = TRUE)`.
#' @return A function that restores the saved graphics parameters and invisibly
#'   returns them.
#' @keywords internal
#' @importFrom graphics par
saveGraphicsParameters = function(..., noReadonly = FALSE) {
  if (noReadonly) {
    savedParameters = par(no.readonly = TRUE)
  } else {
    savedParameters = par(...)
  }

  restoreGraphicsParameters = function() {
    par(savedParameters)
    invisible(savedParameters)
  }

  restoreGraphicsParameters
}

#' Resolve a plotting colour argument
#'
#' Accepts anything R can draw with, such as a colour name, a hex string or a
#' palette number. Abbreviated colour names are completed against `choices`.
#'
#' @param colour colour supplied by the user.
#' @param choices colour names available for completion.
#' @param argumentName argument name used in the error message.
#' @return The completed colour name, or `colour` unchanged.
#' @keywords internal
#' @importFrom grDevices col2rgb
resolvePlotColour = function(colour, choices, argumentName) {
  if (is.character(colour) && length(colour) == 1) {
    matchedColour = pmatch(colour, choices)
    if (!is.na(matchedColour)) {
      return(choices[matchedColour])
    }
  }

  tryCatch(
    col2rgb(colour),
    error = function(e) {
      stop("'", argumentName, "' is not a valid colour", call. = FALSE)
    }
  )

  colour
}
