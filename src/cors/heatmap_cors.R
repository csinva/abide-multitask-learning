calc_heatmaps <- function(){
  # initial load
  dir = '/Users/chandansingh/drive/asdf/research/qi_lab/SinghU-shared/ModelCode/' 
  #dir = '/if19/cs3hq/qilab/'
  source(paste0(dir,"src/main/init.R"))
  setwd(paste0(dir,"data"))
  load_all_cors()
  
  library(ggplot2)
  library(reshape2)
  
  # covariance
  melted_cormat <- melt(cors_simule[[1]])
  pdf('../plots/cov/cov.pdf')
  ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + geom_tile() +  theme_minimal()+ ggtitle("Covariance Matrix")
  dev.off()
  
  # kendall correlation
  melted_cormat_k <- melt(cors_nsimule[[1]])
  pdf('../plots/cov/kcor.pdf')
  ggplot(data = melted_cormat_k, aes(x=Var1, y=Var2, fill=value)) + geom_tile() +  theme_minimal()+ ggtitle("Kendall Correlation Matrix")
  dev.off()
  
  # pearson correlation
  melted_cormat_p <- melt(cors_pearson_simule[[1]])
  pdf('../plots/cov/pcor.pdf')
  ggplot(data = melted_cormat_p, aes(x=Var1, y=Var2, fill=value)) + geom_tile() +  theme_minimal()+ ggtitle("Pearson Correlation Matrix")
  dev.off()
  
  # diff pearson-kendall correlation
  melted_cormat_p <- melt(cors_pearson_simule[[1]]-cors_nsimule[[1]])
  pdf('../plots/cov/diff.pdf')
  ggplot(data = melted_cormat_p, aes(x=Var1, y=Var2, fill=value)) + geom_tile() +  theme_minimal()+ ggtitle("Pearson-Kendall Correlation Matrix")
  dev.off()
}