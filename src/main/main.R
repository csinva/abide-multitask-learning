# set params (if you are unsure just set everything to true)
task_num = 23  # sets the model to run (see cluster_run_main.sh for specifications)
calc_graphs=F  # run the model?
calc_idxs=T  # calculate the idxs from the graphs produced by the model?
calc_acc=T  # calculate accuracy statistis?
calc_conn=T  # calculate connectome stats?
calc_ll=T  # calculate log-likelihood stats?
calc_cors=T # calculate the correlations (most of these are actually covariances) and save them (must do this at least once)?
dir = '/Users/chandansingh/drive/research/singh_connectome/' # points to directory of repo
# dir = '/home/cs3hq/abide_multitask_learning/'
dataset = "full" #values: full,nyu - picks what dataset to use
seed=1 #seed for how to split training data (need to rerun with different seeds for different folds)

# initialize
args = commandArgs(trailingOnly=TRUE)
if(length(args)>0){
    task_num = strtoi(args)
}  
cat('task_num ',task_num,'\n')
source(paste0(dir,"src/main/init.R"))
setwd(paste0(dir,"data"))

# loading data (data_subjects.RData should be in data folder)
dists_orig = as.matrix(read.table(file="dists.csv",sep=",",header=F, check.names=FALSE)) # dists (160x160)
labels = as.matrix(read.table(file="labels.csv",sep=",",header=F, check.names=FALSE)) # labels (160x1, 40 unique)
networks = as.matrix(read.table(file="networks.csv",sep=",",header=F, check.names=FALSE)) # networks (160x1, 6 unique)
data = load_data(dataset) # load data
format_data(dataset) # nyu, full
partition_data(seed) # calculates train_idxs, val_idxs, test_idxs
data_train = data[train_idxs]
n_control_train = sum(train_idxs<=N_autism)
n_autism_train = length(train_idxs) - n_control_train
data_train_flattened = flatten_classes(data_train,n_control_train,n_autism_train)

data_test = data[test_idxs]
n_control_test = sum(test_idxs<=N_autism)
n_autism_test = length(test_idxs) - n_control_test
data_test_flattened = flatten_classes(data_test,n_control_test,n_autism_test)

# calculate or load corr matrices
if(calc_cors){
  calc_all_cors(paste0("cors_",dataset,"_",seed),data_train_flattened)
  calc_all_cors(paste0("cors_ll_",dataset,"_",seed),data_test_flattened)
} else{
  if(calc_ll){
    load_ll_data(paste0("cors_ll_",dataset,"_",seed)) # load ll data (set cors_nsimule_ll,...,data_ll)
  }
  load_all_cors(paste0("cors_",dataset,"_",seed)) # cors_nyu_1, cors_full
}

# set up functions with args
pres = c("n","")
suffs= c("","_i") # "_p"
train_set = paste0(dataset,'_',seed)
func_glasso = list("calc_main",list(train_set,pres,suffs, calc_graphs_glasso, glasso_params,"glasso"))
func_simule = list("calc_main",list(train_set,pres,suffs,calc_graphs_simule, simule_params, "simule"))
func_simule_dist = list("calc_main",list(train_set,pres,suffs,calc_graphs_simule_dist, simule_params, "simule_dist")) # simule_dist_4, simule_dist_exp,...
func_clime =  list("calc_main",list(train_set,pres,suffs,calc_graphs_clime,clime_params,"clime"))
func_simone = list("calc_main",list(train_set,c(""),suffs,calc_graphs_simone,simone_params,"simone",data_train_flattened))
func_jgl =    list("calc_main",list(train_set,c(""),c("group","fused"), calc_graphs_jgl, jgl_params, "jgl", data_train_flattened))
func_self_edges = list("calc_self_edges",list(train_set))
func_dpm = list("calc_dpm",list(train_set,data_train_flattened))
task = generate_tasks(task_num,func_glasso,func_simule,func_simule_dist,func_clime,func_simone,func_jgl,func_self_edges,func_dpm)
rm(func_glasso,func_simule,func_simule_dist,func_clime,func_simone,func_jgl,func_self_edges,func_dpm)

# run
do.call(task[[1]],args=task[[2]])
