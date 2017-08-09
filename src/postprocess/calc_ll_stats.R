calc_ll_stats <- function(arg1, arg2, cors){
  # calculate stats
  length_args = length(arg1)*length(arg2)
  log_likelihoods = vector(length=length_args)
  bics = vector(length=length_args)
  edges = vector(length=length_args)
  params1 = vector(length=length_args)
  params2 = vector(length=length_args)
  con_idxs_list = list(length=length_args)
  aut_idxs_list = list(length=length_args)
  diff_idxs_list = list(length=length_args)
  count = 1
  for(i in 1:length(arg1)){
    lam = arg1[i]
    for(j in 1:length(arg2)){
      eps = arg2[j]
      graphs <- list()
      #message(paste("reading control_",lam,"_",eps,'.csv',sep=''))
      graphs[[1]] = as.matrix(read.table(file=paste("control_",lam,"_",eps,'.csv',sep=''),sep=",",header=F, check.names=FALSE))
      graphs[[2]] = as.matrix(read.table(file=paste("autism_",lam,"_",eps,'.csv',sep=''),sep=",",header=F, check.names=FALSE))
      #graphs[[3]] = as.matrix(read.table(file=paste("shared_",lam,"_",eps,'.csv',sep=''),sep=",",header=F, check.names=FALSE))
      p = ncol(graphs[[1]])
      
      diff_graph = calc_diff_graph(graphs[[1]],graphs[[2]])
      con_idxs_list[[count]] = which(graphs[[1]]!=0)
      aut_idxs_list[[count]] = which(graphs[[2]]!=0)
      diff_idxs_list[[count]] = which(diff_graph)
      
      edges[count]=sum(graphs[[1]]!=0)+sum(graphs[[2]]!=0)
      likelihoods = BIC(cors,graphs,N_control+N_autism,p)
      log_likelihoods[count]=likelihoods[1]
      bics[count]=likelihoods[2]
      params1[count]=lam
      if(eps=="x"){
        params2[count]=-1  
      } else{
        params2[count]=eps  
      }
      count = count + 1
    }
  }
  stats = rbind(edges,bics,log_likelihoods,params1,params2)
  #message(stats)
  #plot(edges,log_likelihoods)
  write.table(stats, paste("likelihood_",".csv",sep=''), sep="\t",col.names=F) # save out stats
  save(con_idxs_list,file="con_idxs_list.RData")
  save(aut_idxs_list,file="aut_idxs_list.RData")
  save(diff_idxs_list,file="diff_idxs_list.RData")
  #print(paste("likelihood_",output_suff,".csv",sep=''))
  return(stats)
}