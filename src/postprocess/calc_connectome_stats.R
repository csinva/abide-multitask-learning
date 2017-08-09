test <- function(){
  rm(list=ls())
  dir = '/Users/chandansingh/drive/asdf/research/singh_connectome/'
  setwd(paste0(dir,"data"))
  dists_orig = as.matrix(read.table(file="dists.csv",sep=",",header=F, check.names=FALSE)) # dists (160x160)
  labels = as.matrix(read.table(file="labels.csv",sep=",",header=F, check.names=FALSE))
}

examine_hist <- function(i){
  idxs_dir = "/Users/chandansingh/drive/asdf/research/singh_connectome/data/full_1/nsimule_dist_2"
  setwd(idxs_dir)
  load(paste0(idxs_dir,"/diff_idxs_list.RData"))
  load("aut_idxs_list.RData")
  load("diff_idxs_list.RData")
  row = unique(diff_idxs_list)
  names_to_counts = integer()
  for(name in unique(labels)){
      names_to_counts[name]=0
  }
  distr = list()
  if(length(row)>0){
    for (j in 20:length(row)){
      edge = row[[j]]
      p = 160
      c = ceiling(edge/p) # NOTE THAT R uses column-major order
      r = ((edge-1) %% p)+1
      #distr[[length(distr)+1]]=dists_orig[r,c]
      names_to_counts[labels[r]]=names_to_counts[labels[r]]+1
      names_to_counts[labels[c]]=names_to_counts[labels[c]]+1
    }
  }
  hist_plots(distr)
}
calc_connectome_stats <- function(idxs_list){ # list(con_idxs_list, aut_idxs_list, diff_idxs_list)
  for(idxs_list_num in 1:3){
    # calc stats
    idxs = idxs_list[[idxs_list_num]]
    len = length(idxs)
    means = rep(0,length=len)
    vars = rep(0,length=len)
    num_pts = rep(0,length=len)
    for (i in 1:len){
      row = unique(idxs[[i]])
      distr = list()
      if(length(row)>0){
        for (j in 1:length(row)){
          edge = row[j]
          p = 160
          c = ceiling(edge/p) # NOTE THAT R uses column-major order
          r = ((edge-1) %% p)+1
          distr[[length(distr)+1]]=dists_orig[r,c]
        }
      }
      if(length(distr)>0){
        distr = unlist(distr)
        num_pts[i] = length(distr)
        means[i] = mean(distr)
        vars[i] = var(distr)
      }
    }
    diff_edges = do.call(rbind, lapply(idxs, function(x) length(x)))
    write.csv(cbind(num_pts,means,vars), file=paste0('connectome_stats_',idxs_list_num,'.csv'))
  }
}


hist_plots <- function(distr){
  
  # remember last row/col were removed
  #names_to_counts = integer()
  #for(name in unique(labels)){
  #  names_to_counts[name]=0
  #}
  #names_to_counts[labels[r]]=names_to_counts[labels[r]]+1
  #names_to_counts[labels[c]]=names_to_counts[labels[c]]+1
  #x = as.numeric(unlist(distr))
  #hist(x,xlab="Connection Distance")
  #tot = 0
  tot = sum(names_to_counts)
  for(name in unique(labels)){
    names_to_counts[name]=names_to_counts[name]/tot*100
  }
  
  #names = names(names_to_counts)
  #vals = names_to_counts[names]
  names_to_counts = sort(names_to_counts,decreasing=T)
  barplot(names_to_counts,horiz=T,las=1,cex.names=0.5,xlab="Percentage differing (%)",beside=F)
  #dev.copy(png,'../plots/connectomes/regions_hist.png')
  #dev.off()
}
