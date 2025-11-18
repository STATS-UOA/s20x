#' Open a case study vignette
#'
#' @param name The case study identifier, e.g. "CSH21"
#'
#' @export
casestudy <- function(name) {
  
  if (missing(name)) {
    stop("Please provide a case study name, e.g., casestudy('CSH21')", call. = FALSE)
  }
  
  # Retrieve available vignette names in s20x
  vlist <- vignette(package = "s20x")$results[, "Item"]
  
  # Check if requested vignette exists
  if (!(name %in% vlist)) {
    stop(paste0("Case study '", name, "' not found as a vignette in s20x."), call. = FALSE)
  }
  
  # Open the vignette
  utils::vignette(name, package = "s20x")
}