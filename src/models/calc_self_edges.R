calc_self_edges <- function(dataset){
   print('calculating self-edges...')
  # acc setup
  data_out_path = paste0(dir,"data/",dataset,"/self_edges")
  dir.create(data_out_path,recursive=T,showWarnings=F)
  setwd(data_out_path)
  
  # calc acc stats
  print('calculating acc...')
  p = 160
  graph = matrix(F,p,p)
  diag(graph)=T
  idxs_list = list(list(which(graph)))
  acc_stats_list = calc_acc_stats(idxs_list[[1]],square=F)
  #calc_connectome_stats(idxs_list)
  print(paste('finished self_edges'))
  
  print('calculating self-edges squared...')
  # acc setup
  data_out_path = paste0(dir,"data/",dataset,"/self_edges_squared")
  dir.create(data_out_path,recursive=T,showWarnings=F)
  setwd(data_out_path)
  
  # calc acc stats
  print('calculating acc...')
  graph = matrix(F,p,p)
  diag(graph)=T
  idxs_list = list(list(which(graph)))
  acc_stats_list = calc_acc_stats(idxs_list[[1]],square=T)
  #calc_connectome_stats(idxs_list)
 
  print(paste('finished self_edges squared'))
}