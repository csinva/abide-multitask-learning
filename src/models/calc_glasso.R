glasso_params <- function(){
  if(pre=="n"){
    lams1 = sort(c(.0025,.0075,.01,.04,.06,.08,.1,.2))
    lams2 = lams1
  } else{
    lams1 = sort(c(20,60,130,160,200,300,400,800,2500,5000))
    lams2 = lams1
  }
  return(list(lams1,lams2))
}

calc_graphs_glasso <- function(lams1,lams2,cors){
  print('calculating glasso graphs...')
  library('glasso')
  for(i in 1:length(lams1)){
    for(j in 1:length(lams2)){
      #cat("glasso ",i," ",j,"\n")
      lam1 = lams1[i]
      lam2 = lams2[j]
      graph1 = glasso(cors[[1]],lam1)
      graph2= glasso(cors[[2]],lam2)
      write.table(graph1$wi,file=paste0("control_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
      write.table(graph2$wi,file=paste0("autism_",lam1,"_",lam2,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
    }
  }
}