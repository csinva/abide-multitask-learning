# return data based on dataset
load_data <- function(dataset){
  if(dataset=="full"){
    load("data_subjects.RData")
    data = data
  } else if(dataset=="nyu"){
    load("data_nyu.RData")
    data = data_nyu
  } else if(dataset=="full_norm"){
    load("data_subjects_norm.RData")
    data = data
  }
  return(data)
}

# load cors_nsimule, cors_simule_i,... based on dir
load_all_cors <- function(dir="cors_full_1"){
  load(paste0("cors/",dir,"/cors_simule.RData"),envir = parent.frame())
  load(paste0("cors/",dir,"/cors_pearson_simule.RData"),envir = parent.frame())
  load(paste0("cors/",dir,"/cors_simule_i.RData"),envir = parent.frame())       
  #load("cors/cors_simule_p.RData",envir = parent.frame())       
  load(paste0("cors/",dir,"/cors_nsimule.RData"),envir = parent.frame())        
  load(paste0("cors/",dir,"/cors_nsimule_i.RData"),envir = parent.frame())       
}

# set cors_ll_nsimule, cors_ll_nsimule_i,...,data_ll based on boolean norm
load_ll_data <- function(dir){
    load_all_cors(dir)
    cors_ll_nsimule<<-cors_nsimule
    cors_ll_nsimule_i<<-cors_nsimule_i
    cors_ll_simule<<-cors_simule
    cors_ll_simule_i<<-cors_simule_i
    load("data_subjects.RData")
    data_ll<<-data
}