generate_tasks <- function(task_num,func_glasso,func_simule,func_simule_dist,func_clime,func_simone,func_jgl,func_self_edges,func_dpm){
  idx=1
  main_funcs = list(func_glasso,func_simule,func_simule_dist,func_clime)
  for(pre in pres){
    for(suff in suffs){
      for(func in main_funcs){
        func[[2]][[2]] = pre
        func[[2]][[3]] = suff
        if(idx==task_num){
          return(func)
        }
        else{
          idx = idx+1
        }
      }
    }
  }
  pre = ""
  for(suff in suffs){
    func = func_simone
    func[[2]][[3]] = suff
    if(idx==task_num){
      return(func)
    }
    else{
      idx = idx+1
    }
  }
  for(suff in c("group","fused")){
    func = func_jgl
    func[[2]][[3]] = suff
    if(idx==task_num){
      return(func)
    }
    else{
      idx = idx+1
    }
  }
  if(idx==task_num){
    return(func_self_edges)
  }
  else{
    idx = idx+1
  }
  if(idx==task_num){
    return(func_dpm)
  }
  else{
    idx = idx+1
  }
  num_list = c('simule_dist_2', 'simule_dist_3', 'simule_dist_4', 'simule_dist_6')
  labs_list = c('simule_dist_labels_1', 'simule_dist_labels_2', 'simule_dist_labels_3', 'simule_dist_networks_1', 'simule_dist_networks_2')
  mix_list = c('simule_dist_labels_1_dist', 'simule_dist_labels_2_dist', 'simule_dist_labels_3_dist', 'simule_dist_labels_1_dist_2', 'simule_dist_labels_2_dist_2', 'simule_dist_labels_3_dist_2')
  for(pre in pres){
    func = func_simule_dist
    func[[2]][[2]] = pre
    func[[2]][[3]] = c("")
    for(j in 1:length(num_list)){
      func[[2]][[6]] = num_list[j]
      if(idx==task_num){
        return(func)
      }
      else{
        idx = idx+1
      }
    }
    for(j in 1:length(labs_list)){
      func[[2]][[6]] = labs_list[j]
      if(idx==task_num){
        return(func)
      }
      else{
        idx = idx+1
      }
    }
    for(j in 1:length(mix_list)){
      func[[2]][[6]] = mix_list[j]
      if(idx==task_num){
        return(func)
      }
      else{
        idx = idx+1
      }
    }
  }
}