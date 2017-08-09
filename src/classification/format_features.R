format_features <- function(idxs,data,val_idxs,test_idxs,square){
  ### create matrix of training features ###
  p = 160
  p_new = length(idxs)
  X_val <- matrix(0,n_val,p_new)
  for(i in 1:n_val){
    for(j in 1:p_new){
      idx = idxs[j]
      r = ceiling(idx/p)
      c = idx%%p
      if(c==0)
        c = p
      data_subj = data[[val_idxs[i]]]
      if(square){
        X_val[i,j]= mean(data_subj[,r]*data_subj[,c]) # take features by multiplying cols
      } else{
        X_val[i,j]= mean(data_subj[,r])
      }
    }
  }
  X_test <- matrix(0,n_test,p_new)
  for(i in 1:n_test){
    for(j in 1:p_new){
      # take features by multiplying cols
      idx = idxs[j]
      r = ceiling(idx/p)
      c = idx%%p
      if(c==0)
        c = p
      data_subj = data[[test_idxs[i]]]
      if(square){
        X_test[i,j]= mean(data_subj[,r]*data_subj[,c])
      }
      else{
        X_test[i,j]= mean(data_subj[,r])
      }
    }
  }
  return(list(X_val,X_test))
}