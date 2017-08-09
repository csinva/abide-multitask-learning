init_and_load <- function(){
  data = load_all_subjects()
  save(data,file="data_subjects.RData")
  data_flat = flatten_classes(data,N_control,N_autism)
  calc_all_cors(paste0("cors_full"),data_flat)
}