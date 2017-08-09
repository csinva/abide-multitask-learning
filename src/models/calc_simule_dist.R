simule_dist_params <- function(){
  lams1 = .01*(2:5) #.001-.01
  lams_mid = c(.0025,.004,.005,.007,.008,.0125,.015,.0175)
  lams2 = 10^(-6:0)
  lams_small = .025*(4:12)
  lams = sort(c(lams1,lams2,lams_mid,lams_small))
  #lams = sort(c(lams_mid,lams2))
  epsilons = 1
  return(list(lams,epsilons))
}

calc_graphs_simule_dist <- function(lams1,lams2,cors){
  dists = dists_orig
  print('changing dists...')
  
  # set dists to either labels or networks
  if(grepl('labels', name)){
    dists = matrix(0,160,160)
    for(r in 1:160){
      for(c in 1:160){
        dists[r,c]=labels[r]!=labels[c]
      }  
    }
  } else if(grepl('networks', name)){
    dists = matrix(0,160,160)
    for(r in 1:160){
      for(c in 1:160){
        dists[r,c]=networks[r]!=networks[c]
      }  
    }
  }
  
  # set dists based on dists and dists_orig
  if(name=='simule_dist_2'){
    dists = dists_orig^2
  } else if(name=='simule_dist_3'){
    dists = dists_orig^3
  } else if(name=='simule_dist_4'){
    dists = dists_orig^4
  } else if(name=='simule_dist_6'){
    dists = dists_orig^6
  } else if(name=='simule_dist_exp'){
    dists = exp(dists_orig)
  } else if(name=='simule_dist_labels_1'){
    dists[dists==1]= dists[dists==1] - .1
    dists[dists==0]= dists[dists==0] + .1
  } else if(name=='simule_dist_labels_2'){
    dists[dists==1]= dists[dists==1] - .2
    dists[dists==0]= dists[dists==0] + .2
  } else if(name=='simule_dist_labels_3'){
    dists[dists==1]= dists[dists==1] - .3
    dists[dists==0]= dists[dists==0] + .3
  } else if(name=='simule_dist_networks_1'){
    dists[dists==1]= dists[dists==1] - .1
    dists[dists==0]= dists[dists==0] + .1
  } else if(name=='simule_dist_networks_2'){
    dists[dists==1]= dists[dists==1] - .2
    dists[dists==0]= dists[dists==0] + .2
  } else if(name=='simule_dist_labels_1_dist'){
    dists[dists==1]= dists[dists==1] - .1
    dists[dists==0]= dists[dists==0] + .1
    dists = .5 * dists_orig/max(dists_orig) + .5 * dists
  } else if(name=='simule_dist_labels_2_dist'){
    dists[dists==1]= dists[dists==1] - .2
    dists[dists==0]= dists[dists==0] + .2
    dists = .5 * dists_orig/max(dists_orig) + .5 * dists
  } else if(name=='simule_dist_labels_3_dist'){
    dists[dists==1]= dists[dists==1] - .3
    dists[dists==0]= dists[dists==0] + .3
    dists = .5 * dists_orig/max(dists_orig) + .5 * dists
  } else if(name=='simule_dist_labels_1_dist_2'){
    dists[dists==1]= dists[dists==1] - .1
    dists[dists==0]= dists[dists==0] + .1
    dists = .5 * dists_orig/max(dists_orig) + .5 * dists^2
  } else if(name=='simule_dist_labels_2_dist_2'){
    dists[dists==1]= dists[dists==1] - .2
    dists[dists==0]= dists[dists==0] + .2
    dists = .5 * dists_orig/max(dists_orig) + .5 * dists^2
  } else if(name=='simule_dist_labels_3_dist_2'){
    dists[dists==1]= dists[dists==1] - .3
    dists[dists==0]= dists[dists==0] + .3
    dists = .5 * dists_orig/max(dists_orig) + .5 * dists^2
  }
  
  
  dists_norm = dists/max(dists)
  
  print('calculating simule_dist graphs...')
  for(i in 1:length(lams1)){
    lam = lams1[i]
    for(j in 1:length(lams2)){
      print(paste("simule dist",i,j,sep=","))
      eps = lams2[j]
      graphs <- simule_dist(cors, lambda=lam, epsilon=eps, D=dists_norm, parallel = TRUE)
      write.table(graphs[[1]],file=paste0("control_",lam,"_",eps,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
      write.table(graphs[[2]],file=paste0("autism_",lam,"_",eps,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
      #write.table(graphs[[3]],file=paste0("shared_",lam,"_",eps,'.csv'),sep=",",col.names=FALSE,row.names=FALSE)
    }
  }
}