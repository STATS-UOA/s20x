#' Get model residual and fitted-value data
#'
#' Extract residuals and fitted values from a fitted model and validate that the
#' two vectors are aligned for diagnostic plotting.
#'
#' @param object a fitted model object.
#' @param residualType optional residual type passed to [stats::residuals()].
#' @param context character description used in error messages.
#' @return A list with `fitted` and `residuals` components.
#' @keywords internal
#' @importFrom stats fitted residuals
getModelResidualFittedData = function(object, residualType = NULL, context = "model") {
  if (is.null(residualType)) {
    residualValues = residuals(object)
  } else {
    residualValues = residuals(object, type = residualType)
  }

  fittedValues = fitted(object)

  if (length(residualValues) != length(fittedValues)) {
    stop(
      "Could not align residuals and fitted values for this ",
      context,
      ". This is an internal plotting error; please report it with the fitted model.",
      call. = FALSE
    )
  }

  list(
    fitted = fittedValues,
    residuals = residualValues
  )
}
