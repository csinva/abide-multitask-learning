# loads all the necessary files and packages for baseline comparison
init <- function(){
  library(R.utils) # for sourceDirectory
  library('pcaPP') # for parallel
  library('lpSolve')
  library('parallel') # for parallel
  library(doMC) # parallel backend
  #library(doParallel)
  library(glmnet) # for regression
  library('AUC') # for calculatin AUC
  library('ggplot2') # for plotting
  library('reshape2') # for plotting
  library(foreach) # for each loop
  
  sourceDirectory(paste0(dir,"src/classification"),envir=parent.frame())
  sourceDirectory(paste0(dir,"src/cors"),envir=parent.frame())
  sourceDirectory(paste0(dir,"src/models"),envir=parent.frame())
  sourceDirectory(paste0(dir,"src/postprocess"),envir=parent.frame())
  sourceDirectory(paste0(dir,"src/preprocess"),envir=parent.frame())
  sourceDirectory(paste0(dir,"src/simule"),envir=parent.frame())
  source(paste0(dir,"src/main/calc_main.R"))
  source(paste0(dir,"src/main/generate_tasks.R"))
}
init()
