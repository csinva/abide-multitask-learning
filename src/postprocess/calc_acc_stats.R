calc_acc_stats <- function(idxs_list,square=T){
  ridge_stats = matrix(0,length(idxs_list),7)
  enet_stats = matrix(0,length(idxs_list),7)
  lasso_stats = matrix(0,length(idxs_list),7)
  colnames(ridge_stats) <- c("num_edges","acc_max","acc_balanced","f1","au_auc","au_prec","au_recall")
  colnames(enet_stats) <- c("num_edges","acc_max","acc_balanced","f1","au_auc","au_prec","au_recall")
  colnames(lasso_stats) <- c("num_edges","acc_max","acc_balanced","f1","au_auc","au_prec","au_recall")
  for(i in 1:length(idxs_list)){
    idxs=idxs_list[[i]]
    print(paste(i,length(idxs)))
    if(length(idxs)>1 && (i==1||length(idxs)!=length(idxs_list[[i-1]]))){ 
      #message(i,' formatting...')
      vals_simule = format_features(idxs,data,val_idxs,test_idxs,square) # takes features from idxs, and calculates the means of the products
      X_val = vals_simule[[1]]
      X_test = vals_simule[[2]]
      
      # classify on new features
      ridge_stats[i,1] = length(idxs)
      enet_stats[i,1] = length(idxs)
      lasso_stats[i,1] = length(idxs)
      ridge_stats[i,2:ncol(ridge_stats)] = classify(X_val,y_val,X_test,y_test,0)
      enet_stats[i,2:ncol(enet_stats)] = classify(X_val,y_val,X_test,y_test,.5)
      lasso_stats[i,2:ncol(lasso_stats)] = classify(X_val,y_val,X_test,y_test,1)
    }
  }
  acc_stats_list = list(as.data.frame(ridge_stats),as.data.frame(enet_stats),as.data.frame(lasso_stats))
  write.csv(acc_stats_list[[1]],file='acc_ridge.csv')
  write.csv(acc_stats_list[[2]],file='acc_enet.csv')
  write.csv(acc_stats_list[[3]],file='acc_lasso.csv')
  return(acc_stats_list)
}