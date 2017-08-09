simule_params <- function(){
  lams1 = .01*(2:5) #.001-.01
  lams_mid = c(.0025,.004,.005,.007,.008,.0125,.015,.0175,.045,.035,.023,.026)
  lams2 = 10^(-4:0)
  lams_small = .025*(5:12)
  lams = sort(c(lams1,lams2,lams_mid,lams_small))
  #lams = sort(c(lams_mid,lams2))
  epsilons = 1
  return(list(lams,epsilons))
}

calc_graphs_simule <- function(lams1,lams2,cors){
  print('calculating simule graphs...')
  for(i in 1:length(lams1)){
    lam = lams1[i]
    for(j in 1:length(lams2)){
      #print(paste("simule",i,j,sep=","))
      eps = lams2[j]
      graphs <- SIMULE(cors, lambda=lam, epsilon=eps, parallel = TRUE)
      write.table(graphs[[1]],file=paste0("control_",lam,"_",eps,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
      write.table(graphs[[2]],file=paste0("autism_",lam,"_",eps,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
      write.table(graphs[[3]],file=paste0("shared_",lam,"_",eps,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
    }
  }
}