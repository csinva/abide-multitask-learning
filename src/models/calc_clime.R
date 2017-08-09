clime_params <- function(){
  lams_orig = 10^(-6:-1)
  lams_mid = c(.0025,.005,.0075,.015,.0175,.02,.0225,.025,.03,.035,.0425,.05,.075)# between .1 and .001
  lams_large = .025*(5:13)
  lams1 = sort(c(lams_orig,lams_mid,lams_large))
  lam2="x"
  return(list(lams1,lam2))
}

calc_graphs_clime <- function(lams1,lam2,cors){
  print('calculating clime graphs...')
  library('clime')
  for(i in 1:length(lams1)){
    lam1 = lams1[i]
    c_results_1 = clime(cors[[1]],lambda=lam1,sigma=TRUE,linsolver='simplex')$Omega[[1]] # actually calculate everything here
    c_results_2 = clime(cors[[2]],lambda=lam1,sigma=TRUE,linsolver='simplex')$Omega[[1]] # actually calculate everything here
    write.table(c_results_1,file=paste0("control_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
    write.table(c_results_2,file=paste0("autism_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
  }
}
