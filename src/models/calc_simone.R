simone_params <- function(){
  lams1 = c(.0045,.005,.02*(1:4)) #out of convergence... stopping here for .003
  lams1 = sort(lams1)
  lam2 = "x"
  return(list(lams1,lam2))
}

calc_graphs_simone <- function(lams1,lam2,data){
  data_simone = rbind(data[[1]],data[[2]])
  tasks_simone = factor(c(rep(1,nrow(data[[1]])),rep(2,nrow(data[[2]]))))
  print(paste0('calculating simone graphs...',pre,suff))
  library('simone')
  for(i in 1:length(lams1)){
    lam1 = lams1[i]
    if(suff==""){
      simone_graphs = simone(data_simone, tasks=tasks_simone, control=setOptions(verbose=F,penalties=lam1, penalty.min = 0, penalty.max=1))
    } else if(suff=="_i"){
      simone_graphs = simone(data_simone, tasks=tasks_simone, control=setOptions(verbose=F,penalties=lam1, edges.coupling="intertwined", penalty.min = 0,penalty.max=1))
    }
    graphs = simone_graphs$networks[[1]]
    write.table(graphs[[1]],file=paste0("control_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
    write.table(graphs[[2]],file=paste0("autism_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
  }
}

