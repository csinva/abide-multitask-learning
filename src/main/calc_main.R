# based on boolean parameters, calculate graphs, calculate accuracies, log-likelihoods
calc_main <- function(dataset, pre, suff, graph_func, param_func, name, data_train_flattened=NULL){
  pre <<- pre
  suff <<- suff
  name <<- name
  print(paste('starting',pre,name,suff))
  params_list = param_func()
  lams1 = params_list[[1]]
  lams2 = params_list[[2]]
  
  # acc
  try({
    ### acc setup
    cors = set_cors_baselines(pre,suff)
    data_out_path = paste0(dir,"data/",dataset,"/",pre,name,suff)
    dir.create(data_out_path,recursive=T,showWarnings=F)
    setwd(data_out_path)
    
    ### acc graphs
    if(calc_graphs){
      print('calculating acc graphs...')
      if(is.null(data_train_flattened)){ 
        graph_func(lams1,lams2,cors)
      } else{
        graph_func(lams1,lams2,data_train_flattened)
      }
    }
    
    ### calc idxs
    if(calc_idxs){
      print('calculate acc idxs')
      idxs_list = calc_all_idxs(lams1,lams2) #   list(con_idxs_list, aut_idxs_list, diff_idxs_list)
    } else{
      load("con_idxs_list.RData")
      load("aut_idxs_list.RData")
      load("diff_idxs_list.RData")
      idxs_list = list(con_idxs_list, aut_idxs_list, diff_idxs_list)
    }
    
    ### calc acc
    if(calc_acc){
      print('calculate acc stats')
      acc_stats_list = calc_acc_stats(idxs_list[[3]])
    }
    
    ### connectome stats
    if(calc_conn){
      print('calculate acc conn stats')
      calc_connectome_stats(idxs_list)
    }
  })
  
  # ll
  try({
  if(calc_ll){
    ### ll setup
    cors = set_cors_baselines(pre,suff,F) # choose which cors to use to make graphs, here set ll=F
    data_out_path_ll = paste0(data_out_path,"/ll")
    dir.create(data_out_path_ll,recursive=T,showWarnings=F)
    setwd(data_out_path_ll)
    
    ### ll graphs
    if(calc_graphs){
      print('calculate ll graphs')
      if(is.null(data_train_flattened)){ 
        graph_func(lams1,lams2,cors)
      } else{
        graph_func(lams1,lams2,data_ll)
      }
    }
    
    cors = set_cors_baselines(pre,suff,T) # choose which cors to use to make graphs, here set ll=T to evaluate on test cors
    ### ll stats
    if(calc_ll){
      print('calculate ll stats')
      stats = calc_ll_stats(lams1,lams2,cors)
    }
    
    ### calc_idxs
    if(calc_idxs){
      print('calculate ll idxs')
      idxs_list = calc_all_idxs(lams1,lams2) #   list(con_idxs_list, aut_idxs_list, diff_idxs_list)
    } else{
      load("con_idxs_list.RData")
      load("aut_idxs_list.RData")
      load("diff_idxs_list.RData")
      idxs_list = list(con_idxs_list, aut_idxs_list, diff_idxs_list)
    }
    
    ### connectome stats
    if(calc_conn){
      print('calculate ll conn stats')
      calc_connectome_stats(idxs_list)
    }
  }
  })
  
  print(paste('finished',pre,name,suff))
  
}