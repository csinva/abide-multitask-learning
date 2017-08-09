jgl_params <- function(){
  #lams_small = c(.2,.35,.5,.8)
  lams1 = sort(c(10^(-7:-5),2*10^(-7:-5)))
  lams2 = sort(c(10^(-8:-5),5e-6))
  return(list(lams1,lams2))
}

calc_graphs_jgl <- function(lams1,lams2,data){
  print('calculating jgl graphs...')
  library('JGL')
  for(i in 1:length(lams1)){
    lam1 = lams1[i]
    for(j in 1:length(lams2)){
      lam2 = lams2[j]
      fgl.results = JGL(data,penalty=suff,lambda1=lam1,lambda2=lam2)
      graphs = fgl.results$theta
      write.table(graphs[[1]],file=paste0("control_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
      write.table(graphs[[2]],file=paste0("autism_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
    }
  }
}