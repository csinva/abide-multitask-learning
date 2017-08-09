classify <- function(X_val,y_val,X_test,y_test,alpha_reg){
  ### train & test ###
  set.seed(703858)
  rand = sample.int(n_val)
  lasso_fit <- glmnet(X_val[rand,], y_val[rand], family="gaussian", alpha=alpha_reg)
  cv <- cv.glmnet(X_val[rand,],y_val[rand],alpha=alpha_reg)
  #plot(lasso_fit,xvar="lambda")
  pred_y <- predict(lasso_fit, s=cv$lambda.min,newx=X_test)
  #message("pred_y",pred_y)
  #message("best lambda",cv$lambda.min)
  
  # calculate stats
  accuracy = accuracy(pred_y,factor(y_test))
  prec = specificity(pred_y,factor(y_test))
  recall = sensitivity(pred_y,factor(y_test))
  
  # save stats
  f1 = max(2*prec$measure*recall$measure / (prec$measure+recall$measure))
  au_acc = auc(accuracy)
  au_prec = auc(prec)
  au_recall = auc(recall)
  balanced_acc=0
  acc_max = max(accuracy$measure)
  for(thresh in accuracy$cutoffs){
    pred_thresholded <- as.numeric(pred_y>=thresh)# make it binary
    balanced_acc = max(balanced_acc,.5 * (sum(pred_thresholded==1 & y_test==1)/sum(y_test==1) + sum(pred_thresholded==0 & y_test==0)/sum(y_test==0)))
  }
  #message("\tacc ",acc_max)
  
  return(c(acc_max, balanced_acc, f1, au_acc, au_prec, au_recall))
}