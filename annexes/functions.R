#===========================================================================================
# Libraries
#===========================================================================================
library(shinyjs)
library(dplyr)
library(DT)
library(forestplot)
library(ggfortify)
library(ggplot2)
library(gplots)
library(metafor)
library(stringr)
library(scales)
library(rvest)
library(rmarkdown)

#===========================================================================================
# Lists of the different studies, categories and gene names
#===========================================================================================
list_datasets   <- readRDS("data/annotation/names_datasets.Rds")
list_categories <- readRDS("data/annotation/names_categories.Rds")
list_genes      <- readRDS("data/annotation/names_genes.Rds")


#===========================================================================================
# Function to make meta-analysis table
#===========================================================================================
MetaAnalysis <- function(x){
  validate(need(!is.null(x),   "No studies found - try different selection criteria"))
  #Order by logFC
  x <- x[order(x$logFC, decreasing=T),]
  #if only one row, skip calculation
  if(nrow(x)<2){
    x <- rbind(x[,1:10],
               c(as.numeric(x[,1:4]), rep(NA, 4), sum(x$size, na.rm=T)))
    x$Studies <- c(gsub("logFC_", "", x$Studies[1:(nrow(x)-1)]),
                   "Meta-analysis score")
    return(x)
    
  } else {
    #Calculate metascore
    meta <- rma(m1 = Mean_Ex, m2 = Mean_Ctrl,
                sd1 = Sd_Ex, sd2 = Sd_Ctrl,
                n1 = size, n2 = size,
                method = "REML",
                measure = "MD",
                data = x,
                control=list(maxiter=1000, stepadj=0.5),
                weighted=T, weights=x$size)
    fdr  <- p.adjust(meta$pval, method='BH')
    x <- rbind(x[,1:10],
               c(meta$beta, fdr, meta$ci.lb, meta$ci.ub, rep(NA, 4), sum(x$size, na.rm=T)))
    x$Studies <- c(gsub("logFC_", "", x$Studies[1:(nrow(x)-1)]),
                   "Meta-analysis score")
    return(x)
  }
}


#===========================================================================================
# Function to make forest plot
#===========================================================================================
ModuleForestPlot <- function(metadata, genename, color, title) {
   #Validate selection criteria
   validate(need(!is.na(metadata[1,1]),   "No studies found - try different selection criteria"))
   #Plot the forest plot:
    metadata <- data.frame(metadata)
    max_n <- max(metadata[1:(nrow(metadata)-1),]$size, na.rm=T)+1 #used to plot weights
    tabledata <- cbind(mean = c(NA , metadata[,1]), 
                       lower= c(NA , metadata[,3]),
                       upper= c(NA , metadata[,4]))
    tabletext <- cbind(c(paste(genename, 'in', title, sep=' ') , metadata[,10]),
                       c("logFC" , format(round(metadata[,1], digits=2))), 
                       c("FDR"   , format(metadata[,2],   scientific=T, digits=2)),
                       c("n" , metadata[,9]))
    finalplot <- forestplot(tabletext, grid=T,
                            tabledata, new_page=TRUE,
                            is.summary=c(TRUE,rep(FALSE,(nrow(metadata)-1)),TRUE),
                            xlog=F,  txt_gp = own, xlab="logFC",
                            col=fpColors(box=color,line=color, summary=color),
                            boxsize=c(NA, head(metadata$size, -1)/max_n, 1)) #Make the size of the symbols relative to sample size
    return(finalplot)
}


#===========================================================================================
# URLs for sharing buttons
#===========================================================================================
url_twitter  <- "https://twitter.com/intent/tweet?text=MetaMEx:%20Meta-Analysis%20of%20skeletal%20muscle%20response%20to%20inactivity%20and%20exercise.%20@NicoPillon%20@JuleenRZierath&url=http://www.metamex.eu"
url_linkedin <- "https://www.linkedin.com/shareArticle?mini=true&url=http://www.metamex.eu&title=MetaMEx:%20Meta-Analysis%20of%20skeletal%20muscle%20response%20to%20inactivity%20and%20exercise.%20&summary=MetaMEx&source=LinkedIn"
url_facebook <- "https://www.facebook.com/sharer.php?u=https://www.metamex.eu&title=MetaMEx:%20Meta-Analysis%20of%20skeletal%20muscle%20response%20to%20inactivity%20and%20exercise.%20"


#===========================================================================================
# Graphical parameters
#===========================================================================================
options(shiny.sanitize.errors=F) # sanitize errors

# Forest plot graphical parameters
own <- fpTxtGp()
own$ticks$cex <- 0.9 #tick labels
own$xlab$cex <- 0.9
own$label$cex <- 0.9
own$summary$cex <- 1.2

theme <- theme(plot.title  = element_text(face="bold", color="black", size=11, angle=0),
               axis.text.x = element_text(color="black", size=10, angle=0, hjust = 0.5),
               axis.text.y = element_text(color="black", size=10, angle=0, hjust = 1),
               axis.title  = element_text(face="bold", color="black", size=12, angle=0),
               legend.text   = element_text(color="black", size=10, angle=0),
               legend.title  = element_blank(),
               legend.position="none")




#===========================================================================================
# Function to make hyperlinks
#===========================================================================================
createLink <- function(val) {
  sprintf(paste0('<a href="', URLdecode(val),'" target="_blank">', 
                 gsub("(.*org/)|(.*=)", "", val) ,'</a>'))
  }
