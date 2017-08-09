calc_mns <- function(){
  # MNS - requires subject-by-subject data
  setwd(paste(dir,"data/mns",sep=""))
  lams1 = c(.0035,.001*(4:5),.01*(1:8))
  lams2 = lams1 #.1#100^(-4:-2)
  data_mns = list()
  n_max = min(nrow(data_simule[[1]]),nrow(data_simule[[2]]))
  data_mns[[1]] = data_simule[[1]][1:n_max,]
  data_mns[[2]] = data_simule[[2]][1:n_max,]
  # their data is list of length K (# subjects) 
  # containing n (# observations per subject) x p (# of ROIs)
  # data should be length K (# classes), 
  library('MNS')
  for(i in 1:length(lams1)){
    print('i',i)
    lam1 = lams1[i]
    for(j in 1:length(lams2)){
      print('j',j)
      lam2 = lams2[j]
      mns.results = MNS(data_mns,lambda_pop = lam1, lambda_random = lam2, parallel=TRUE,cores=3)
      graphs = mns.results$theta
      write.table(graphs[[1]],file=paste0("control_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
      write.table(graphs[[2]],file=paste0("autism_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
    }
  }
  setwd(paste0(dir,"data/mns")) # calculate stats
  calc_stats(lams1,lams2) # requires that you are in proper dir
  
  #Error in checkForRemoteErrors(val) : 
  #2 nodes produced errors; first error: cannot allocate vector of size 44.6 Gb
  #Calls: MNS ... clusterApply -> staticClusterApply -> checkForRemoteErrors
  #Execution halted
  #Warning message:
  #  system call failed: Cannot allocate memory 
}
