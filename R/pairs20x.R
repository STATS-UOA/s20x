#' Pairwise Scatter Plots with Histograms and Correlations
#' 
#' Plots pairwise scatter plots with histograms and correlations for the data
#' frame.
#' 
#' 
#' @param x a data frame.
#' @param na.rm if TRUE then only complete cases will be displayed
#' @param \dots optional argumments which are passed to the generic pairs
#' function.
#' @return Returns the plots.
#' @seealso \code{'pairs', 'panel.smooth', 'panel.cor', 'panel.hist'}
#' @keywords hplot
#' @examples
#' 
#' ##peruvian indians
#' data(peru.df)
#' pairs20x(peru.df)
#' 
#' @export pairs20x
pairs20x = function(x, na.rm = TRUE, ...) {
    panel.hist = function(x, ...) {
        usr = par("usr")
        on.exit(par(usr = usr))
        
        par(usr = c(usr[1:2], 0, 1.5))
        h = hist(x, plot = FALSE)
        breaks = h$breaks
        nB = length(breaks)
        y = h$counts
        y = y/max(y)
        rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
    }
    
    panel.cor = function(x, y, digits = 2, prefix = "", cex.cor) {
        usr = par("usr")
        on.exit(par(usr = usr))
        par(usr = c(0, 1, 0, 1))
        r = abs(cor(x, y))
        txt = format(c(r, 0.123456789), digits = digits)[1]
        txt = paste(prefix, txt, sep = "")
        if (missing(cex.cor)) 
            cex.cor = 0.8/strwidth(txt)
        text(0.5, 0.5, txt, cex = cex.cor * r)
    }
    
    if(na.rm){
      x = x[complete.cases(x), ]
    }
    
    pairs(x, upper.panel = panel.smooth, lower.panel = panel.cor, diag.panel = panel.hist, ...)
}

