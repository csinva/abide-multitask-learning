##############
#author: Beilun Wang
#input: 
#covs   -- a list of estimated covariance matrices
#graphs -- a list of estimated precision matrices
#n      -- total number of samples
#p      -- number of features
#output:
#bic    -- bic number
##############
BIC <- function(covs, graphs, n, p){
  N = length(covs)
  ll = 0
  #calculate loglikelihood
  for(i in 1:N){
    ll = determinant(graphs[[i]])$modulus[1] - sum(diag(covs[[i]] %*% graphs[[i]])) + ll
  }
  #calculate bic
  bic = -2 * ll + ((p * p - p) / 2 + p) * log(n)
  return(c(ll,bic))
}