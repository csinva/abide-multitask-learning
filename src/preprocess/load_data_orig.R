# loads autism/control into list of 2 matrices (one control one autism)
load_autism_and_control <- function(){
  data = load_all_subjects()
  return(flatten_classes(data,N_control,N_autism))
}

load_all_subjects <- function(){
  files <- (Sys.glob(paste0(data_dir,"Control/*.1D"))) # Load all of the 'Control' subject samples into one matrix
  listOfFiles <- lapply(files, function(x) read.delim(x, header = TRUE, sep = "\t")[,1:160])
  control <- lapply(listOfFiles, function(x) as.matrix(x))
  
  files <- (Sys.glob(paste0(data_dir,"Autism/*.1D")))
  listOfFiles <- lapply(files, function(x) read.delim(x, header = TRUE, sep = "\t")[,1:160])
  autism <- lapply(listOfFiles, function(x) as.matrix(x))
  
  data   = list() # Holds the control and autism matrices in a list
  N_control <<- length(control) 
  N_autism <<- length(autism)
  for(i in 1 : N_control){ # 468
    data[[i]] = control[i][[1]]
  }
  for(i in 1:N_autism){ # 403
    data[[N_control+i]] = autism[i][[1]]
  }
  return(data)
}

load_all_subjects_nyu <- function(){
  files <- (Sys.glob(paste0(data_dir,"Control/NYU*.1D"))) # Load all of the 'Control' subject samples into one matrix
  listOfFiles <- lapply(files, function(x) read.delim(x, header = TRUE, sep = "\t")[,1:160])
  control <- lapply(listOfFiles, function(x) as.matrix(x))
  
  files <- (Sys.glob(paste0(data_dir,"Autism/NYU*.1D")))
  listOfFiles <- lapply(files, function(x) read.delim(x, header = TRUE, sep = "\t")[,1:160])
  autism <- lapply(listOfFiles, function(x) as.matrix(x))
  
  data   = list() # Holds the control and autism matrices in a list
  N_control <<- length(control) # 108
  N_autism <<- length(autism)   # 74
  for(i in 1 : N_control){
    data[[i]] = control[i][[1]]
  }
  for(i in 1:N_autism){
    data[[N_control+i]] = autism[i][[1]]
  }
  #data_centered = list()
  #for (i in 1:length(data)){
  #  data_centered[[i]] = scale(data[[i]], center = T, scale = F)
  #}
  return(data)
}