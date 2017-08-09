dpm_params <- function(){
  num_lams = 30
  lam2 = "x"
  return(list(num_lams,lam2))
}

calc_graphs_dpm <- function(num_lams,data_dpm){
  print('calculating dpm graphs...')
  dpm_dir = paste0(dir,"direct_learning/zhao_2014/")
  dyn.load(paste0(dpm_dir,"dpm.so"));
  source(paste0(dpm_dir,"dpm.R"));
  results <- dpm(data_dpm[[1]],data_dpm[[2]],nlambda=num_lams,tuning="aic")
  for(i in 1:num_lams){
    lam1 = results$lambda[i]
    diff = results$dpm[[i]]
    write.table(diff,file=paste0("diff_",lam1,"_","x",'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
  }
  return(results$dpm)
}

calc_dpm <- function(dataset,data_train_flattened){
  params = dpm_params()
  num_lams = params[[1]]
  data_out_path = paste0(dir,"data/",dataset,"/dpm")
  
  print('calculating dpm...')
  # acc setup
  dir.create(data_out_path,recursive=T,showWarnings=F)
  setwd(data_out_path)
  
  # calc acc stats
  graphs = calc_graphs_dpm(num_lams,data)
  diff_idxs_list = list()
  for(i in 1:length(graphs)){
    diff_idxs_list[[i]] = which(abs(graphs[[i]])>1e-4)
  }
  save(diff_idxs_list,file="diff_idxs_list.RData")
  print('calculating acc...')
  acc_stats_list = calc_acc_stats(diff_idxs_list)
  #calc_connectome_stats(idxs_list)

  print(paste('finished dpm'))
}