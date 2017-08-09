##############
#author: Beilun Wang
#input: 
#X       -- a list of data matrices
#method  -- string vector to decide which method to use, 
#           only can be "pearson" or "kendall"
#output:
#covs    -- a list of intertwined covariance matrices
##############
InterwinedLasso <- function(X, method = "pearson"){
  result = list()
  N = length(X)
  if (method == "pearson"){
    covs = list()
    for(i in 1:N){
      covs[[i]] = cov(X[[i]])
    }
    
    X.whole = X[[1]]
    if (N > 1){
      for (i in 2:N){
        X.whole = rbind(X.whole, X[[i]])
      }
    }
    cov.mean = cov(X.whole)
    for(i in 1:N){
      covs[[i]] = 1/2 * covs[[i]] + 1/2 * cov.mean
    }
    result = covs
  }
  
  if (method == "kendall"){
    library('pcaPP')
    cors = list()
    for(i in 1:N){
      cors[[i]] = cor.fk(X[[i]])
    }
    
    X.whole = X[[1]]
    if (N > 1){
      for (i in 2:N){
        X.whole = rbind(X.whole, X[[i]])
      }
    }
    cor.mean = cor.fk(X.whole)
    for(i in 1:N){
      cors[[i]] = 1/2 * cors[[i]] + 1/2 * cor.mean
    }
    result = cors
  }
  result
} 