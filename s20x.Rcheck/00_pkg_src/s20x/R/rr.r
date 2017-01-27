#' Read Data
#' 
#' For internal use
#' 
#' 
#' @keywords models
#' @export rr
rr <- function() {
    # Shortcut to read in data
    read.table(file.choose(), header = TRUE)
}

