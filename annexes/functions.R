#===========================================================================================
# Libraries
#===========================================================================================
library(shinyjs)
library(shinycssloaders)
library(rmarkdown)

library(ggplot2)
library(gplots)
library(ggpubr)
library(ggprism)
library(ggfortify)

library(dplyr)
library(DT)
library(stringr)
library(scales)
library(rvest)
library(feather)

library(forestplot)
library(metafor)





#===========================================================================================
# Lists of the different studies, categories and gene names
#===========================================================================================
names_human_categories <- readRDS("data/annotation/names_human_categories.Rds")
names_human_datasets   <- readRDS("data/annotation/names_human_datasets.Rds")
names_human_genes      <- readRDS("data/annotation/names_human_genes.Rds")

names_mouse_categories <- readRDS("data/annotation/names_mouse_categories.Rds")
names_mouse_datasets   <- readRDS("data/annotation/names_mouse_datasets.Rds")
names_mouse_genes      <- readRDS("data/annotation/names_mouse_genes.Rds")

correlations_categories_human <- readRDS("data/correlations/corr_human_categories.Rds")
correlations_annotation_human <- readRDS("data/correlations/corr_human_entrezid.Rds")

#===========================================================================================
# Function to make dataframe from gene name
#===========================================================================================
DataForGeneName <- function(x){
  colnames(x) <- gsub("AcAe_", "", colnames(x))
  colnames(x) <- gsub("AcRe_", "", colnames(x))
  colnames(x) <- gsub("AcHi_", "", colnames(x))
  colnames(x) <- gsub("TrAe_", "", colnames(x))
  colnames(x) <- gsub("TrCo_", "", colnames(x))
  colnames(x) <- gsub("TrHi_", "", colnames(x))
  colnames(x) <- gsub("TrRe_", "", colnames(x))
  colnames(x) <- gsub("Inac_", "", colnames(x))
  x <- data.frame(
    t(x[grepl('logFC',    colnames(x))]), # M-value (M) is the log2-fold change
    t(x[grepl('adj.P.Val',colnames(x))]), # Benjamini and Hochberg's method to control the false discovery rate
    t(x[grepl('CI.L',     colnames(x))]), # lower limit of the 95% confidence interval
    t(x[grepl('CI.R',     colnames(x))]), # upper limit of the 95% confidence interval
    #t(x[grepl('mean.pre', colnames(x))]), # mean of control condition
    #t(x[grepl('mean.post', colnames(x))]), # mean of exercise condition
    #t(x[grepl('Sd.pre',   colnames(x))]), # standard deviation of control condition
    #t(x[grepl('Sd.post',   colnames(x))]), # standard deviation of exercise condition
    t(x[grepl('size',     colnames(x))]) # number of subjects in the study
    )
  x <- cbind(x, str_split_fixed(rownames(x), "_", 11))
  colnames(x) <- c('logFC', 'adj.P.Val', 
                   'CI.L', 'CI.R',
                   #'Mean_Ctrl', 'Mean_Ex', 'Sd_Ctrl', 'Sd_Ex', 
                   'size',
                   'Studies', 'GEO', 'Exercisetype', 
                   'Muscle', 'Sex', 'Age', 'Training',
                   'Obesity', 'Disease', 'Biopsy', 'Duration')
  x$Studies <- gsub("logFC_","", rownames(x))
  x
}

DataForGeneNameMouse <- function(x){
  colnames(x) <- gsub("_Ac", "_", colnames(x))
  colnames(x) <- gsub("_Tr", "_", colnames(x))
  colnames(x) <- gsub("_In", "_", colnames(x))
  x <- data.frame(
    t(x[grepl('logFC',    colnames(x))]), # M-value (M) is the log2-fold change
    t(x[grepl('adj.P.Val',colnames(x))]), # Benjamini and Hochberg's method to control the false discovery rate
    t(x[grepl('CI.L',     colnames(x))]), # lower limit of the 95% confidence interval
    t(x[grepl('CI.R',     colnames(x))]), # upper limit of the 95% confidence interval
    #t(x[grepl('mean.pre', colnames(x))]), # mean of control condition
    #t(x[grepl('mean.post', colnames(x))]), # mean of exercise condition
    #t(x[grepl('Sd.pre',   colnames(x))]), # standard deviation of control condition
    #t(x[grepl('Sd.post',   colnames(x))]), # standard deviation of exercise condition
    t(x[grepl('^n.pre', colnames(x))]) + t(x[grepl('^n.post', colnames(x))]) # number of animals in the study
    ) 
  x <- cbind(x, str_split_fixed(rownames(x), "_", 8))
  colnames(x) <- c('logFC', 'adj.P.Val', 
                   'CI.L', 'CI.R',
                   #'Mean_Ctrl', 'Mean_Ex', 'Sd_Ctrl', 'Sd_Ex', 
                   'size',
                   'Studies', 'GEO', 'Protocol', 
                   'Muscle', 'Sex', 'Age', 'Condition', "Duration")
  x$Studies <- gsub("logFC_","", rownames(x))
  return(x)
}


#===========================================================================================
# Function to transform human into mouse genename
#===========================================================================================
firstup <- function(x) {
  x <- tolower(x)
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}


#===========================================================================================
# Function to make meta-analysis table
#===========================================================================================
MetaAnalysis <- function(x, nrow){
  validate(need(!is.null(x),   "No studies found - try different selection criteria"))
  
  #Order by logFC
  x <- x[order(x$logFC, decreasing=T),]

  # Remove invalid studies
  x <- x[which(!(is.na(x$logFC))), ]
  x <- x[which(!(is.infinite(x$logFC))), ]
  
  #if only one row, skip calculation
  if(nrow(x) < 2){
    #Remake the table with desired columns, rbind the calculations for the one study
    x <- rbind(x[,c('logFC', 'adj.P.Val', 'CI.L', 'CI.R', 'size', 'Studies')],
               c(as.numeric(x[,1:4]), sum(x$size, na.rm=T), NA))
    #Add a proper name to the meta-analysis line
    x$Studies <- c(gsub("logFC_", "", x$Studies[1:(nrow(x)-1)]),
                   "Meta-analysis score")
    return(x)
    
  } else {
    #Calculate metascore using logFC and CI
    meta <- rma(yi = logFC,
                sei = (CI.R - CI.L) / 3.92,
                method = "REML",
                measure = "MD",
                data = x,
                control=list(maxiter=1000, stepadj=0.5),
                weighted=T, weights=x$size)
    #Calculate FDR with bonferroni based on number of genes in dataset
    fdr  <- p.adjust(meta$pval, method='bonferroni', n=nrow)
    #Remake the table with desired columns, rbind the meta-analysis calculations
    x <- rbind(x[,c('logFC', 'adj.P.Val', 'CI.L', 'CI.R', 'size', 'Studies')],
               rep(NA, 6),
               c(meta$beta, fdr, meta$ci.lb, meta$ci.ub, sum(meta$weights, na.rm=T), NA))
    #Add a proper name to the meta-analysis line
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
    tabledata <- cbind(mean = c(NA , metadata[,"logFC"]), 
                       lower= c(NA , metadata[,"CI.L"]),
                       upper= c(NA , metadata[,"CI.R"]))
    tabletext <- cbind(c(paste(genename, 'in', title, sep=' ') , metadata[,"Studies"]),
                       c("logFC" , format(round(metadata[,"logFC"], digits=2))), 
                       c("adj.P.Val"   , format(metadata[,"adj.P.Val"],   scientific=T, digits=2)),
                       c("n" , metadata[,"size"]))
    #replace NA with blanks
    tabletext[,2] <- gsub("NA", " ", tabletext[,2])
    tabletext[,3] <- gsub("NA", " ", tabletext[,3])
    #Make nicer file name
    tabletext[,1] <- gsub("_", ", ", tabletext[,1])
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
own$summary$cex <- 1.1

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


