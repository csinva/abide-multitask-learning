normalize_data <- function(data){
  library('matrixStats')
  load("data_subjects.RData")
  data_flat = flatten_classes(data,526,403)
  data_tot = rbind(data_flat[[1]],data_flat[[2]])
  N_control = 526
  N_autism = 403
  means = colMeans(data_tot)
  vars = colVars(data_tot)
  for (i in 1:N_control+N_autism){
    data[[i]] = sweep(data[[i]], 2, means, "-")
    data[[i]] = sweep(data[[i]], 2, vars, "/")
  }
  save(data,file=paste0("data_subjects_norm.RData"))
  calc_all_cors(paste0("cors_full_norm"),flatten_classes(data,526,403))
}