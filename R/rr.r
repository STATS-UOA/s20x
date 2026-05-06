#' Read Data
#'
#' For internal use.
#'
#' @keywords models
#' @export rr
rr = function() {
  read.table(file.choose(), header = TRUE)
}
