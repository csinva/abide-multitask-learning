# calculate all cor-type matrices (pxp)
calc_all_cors <- function(cors_dir="cors_full", data){     # data should be list of 2 (like data_simule)
  print('calculating cors...')
  setwd(paste0(dir,"data"))
  data_out_path = paste0("cors/",cors_dir)
  dir.create(data_out_path,recursive=T)
  cors_simule = calculate_covs_simule(data)           # covariance
  save(cors_simule,file=paste0("cors/",cors_dir,"/cors_simule.RData"))
  cors_pearson_simule = calculate_cors_simule(data)   # pearson correlation
  save(cors_simule,file=paste0("cors/",cors_dir,"/cors_pearson_simule.RData"))
  cors_simule_i = InterwinedLasso(data,"pearson")     # intertwined pearson
  save(cors_simule_i,file=paste0("cors/",cors_dir,"/cors_simule_i.RData"))
  #cors_simule_p = calculate_cors_poet(data_simule)   # POET
  #save(cors_simule_p,file=paste0("cors/",cors_dir,"/cors_simule_p.RData"))
  cors_nsimule <- calculate_cors_nsimule(data)        # kendall correlation 
  save(cors_nsimule,file=paste0("cors/",cors_dir,"/cors_nsimule.RData"))
  cors_nsimule_i = InterwinedLasso(data,"kendall")    # intertwined kendall
  save(cors_nsimule_i,file=paste0("cors/",cors_dir,"/cors_nsimule_i.RData"))
}

# calculate Kendall correlations
calculate_cors_nsimule <- function(data){
  Cors   = list() # Holds the correlation matrices in a list
  N = length(data)
  for(i in 1:N){ #2 is the number of groups
    start.time <- Sys.time()
    Cors[[i]] <- cor.fk(data[[i]]) # Cor should be p x p
    end.time <- Sys.time()
    time.taken <- end.time - start.time
    time.taken
  }
  return(Cors)
}

# calculate covariances
calculate_covs_simule <- function(X){
  N = length(X)
  covs = list()
  for(i in 1:N){
    covs[[i]] = cov(X[[i]])
  }
  return(covs)
}

# calculate correlations
calculate_cors_simule <- function(X){
  N = length(X)
  covs = list()
  for(i in 1:N){
    covs[[i]] = cor(X[[i]])
  }
  return(covs)
}

# calculate POET correlations
calculate_cors_poet <- function(data_simule){
  X1 = data_simule[[1]]
  X2 = data_simule[[2]]
  print(colMeans(X1))
  X1_d <- sweep(X1, 2, colMeans(X1), "-")
  X2_d <- sweep(X2, 2, colMeans(X2), "-")
  print(colMeans(X1_demeaned))
  library(POET)
  covs = list()
  covs[[1]] = POET(t(X1_d),K=30)
  covs[[2]] = POET(t(X2_d),K=30)
  return(covs)
}