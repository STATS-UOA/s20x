# Internal model-diagnostic data helpers.

getModelResidualFittedData = function(object, residualType = NULL, context = "model") {
  if (is.null(residualType)) {
    residualValues = stats::residuals(object)
  } else {
    residualValues = stats::residuals(object, type = residualType)
  }

  fittedValues = stats::fitted(object)

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
