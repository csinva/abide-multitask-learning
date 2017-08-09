calc_diff_graph <- function(graph1, graph2){
  graph_out = (graph2-graph1)!=0
  for(r in 1:nrow(graph_out)){
    for(c in 1:ncol(graph_out)){
      if(graph_out[r,c]&&graph_out[c,r]){
        if(r!=c){
          graph_out[c,r]=FALSE
        }
      }
    }
  }
  diag(graph_out)=FALSE # set diag to 0
  #ggplot(data=melt(graph_out),aes(x=Var1,y=Var2,fill=value))+geom_tile()
  return(graph_out)
}

calc_all_idxs <- function(arg1, arg2){
  # calculate stats
  length_args = length(arg1)*length(arg2)
  con_idxs_list = list(length=length_args)
  aut_idxs_list = list(length=length_args)
  diff_idxs_list = list(length=length_args)
  edges = vector(length=length_args)
  params1 = vector(length=length_args)
  params2 = vector(length=length_args)
  count = 1
  #cat('arg1',arg1)
  #cat('arg2',arg2)
  for(i in 1:length(arg1)){
    lam = arg1[i]
    for(j in 1:length(arg2)){
      eps = arg2[j]
      graphs <- list()
      #message(paste("reading control_",lam,"_",eps,'.csv',sep=''))
      graphs[[1]] = as.matrix(read.table(file=paste("control_",lam,"_",eps,'.csv',sep=''),sep=",",header=F, check.names=FALSE))
      graphs[[2]] = as.matrix(read.table(file=paste("autism_",lam,"_",eps,'.csv',sep=''),sep=",",header=F, check.names=FALSE))
      diff_graph = calc_diff_graph(graphs[[1]],graphs[[2]])
      con_idxs_list[[count]] = which(graphs[[1]]!=0)
      aut_idxs_list[[count]] = which(graphs[[2]]!=0)
      #ggplot(data=melt(diff_graph),aes(x=Var1,y=Var2,fill=value))+geom_tile()
      diff_idxs_list[[count]] = which(diff_graph)
      params1[count]=lam
      if(eps=="x"){
        params2[count]=-1  
      } else{
        params2[count]=eps  
      }
      count = count + 1
    }
  }
  diff_edges = do.call(rbind, lapply(diff_idxs_list, function(x) length(x)))
  write.csv(cbind(params1,params2,diff_edges), file='params.csv')
  save(con_idxs_list,file="con_idxs_list.RData")
  save(aut_idxs_list,file="aut_idxs_list.RData")
  save(diff_idxs_list,file="diff_idxs_list.RData")
  return(list(con_idxs_list, aut_idxs_list, diff_idxs_list))
}
