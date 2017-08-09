# flatten list into list of two matrices using N_control and N_autism
flatten_classes <- function(data,N_control,N_autism){
  data_out = list()
  data_out[[1]] = do.call(rbind,data[1:N_control])
  data_out[[2]] = do.call(rbind,data[N_control+1:N_autism])
  return(data_out)
}

# sets N_control, N_autism, y based on dataset
format_data <- function(dataset){
  if(dataset=="nyu"){
    N_control <<- 108
    N_autism <<- 74
  } else if(dataset=="full"){
    N_control <<- 468
    N_autism <<- 403  
  }
  y1 <- matrix(0,N_control,1)
  y2 <- matrix(1,N_autism,1) # 1 is for the autism group
  y <<- as.matrix(rbind(y1,y2))
}

# partitions data based on seed, N_control, N_autism, y
partition_data <- function(seed){ # split into train-test set
  nfolds = 3
  set.seed(seed*703857)
  folds1 <- cut(sample(N_control),breaks=nfolds,labels=FALSE)
  folds2 <- cut(sample(N_autism),breaks=nfolds,labels=FALSE)
  folds <- c(folds1,folds2)
  
  train_idxs <<- which(folds==1,arr.ind=TRUE)
  val_idxs <<- which(folds==2,arr.ind=TRUE)
  test_idxs <<- which(folds==3,arr.ind=TRUE)
  
  n_train <<- length(train_idxs)
  n_val <<- length(val_idxs)
  n_test <<- length(test_idxs)
  y_train <<- y[train_idxs]
  y_val <<- as.matrix(y[val_idxs])
  y_test <<- as.matrix(y[test_idxs])
}