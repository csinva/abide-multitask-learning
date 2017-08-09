# set task num
task_num = 23
args = commandArgs(trailingOnly=TRUE)
if(length(args)>0){
    task_num = strtoi(args)
}  
cat('task_num ',task_num,'\n')
#dir = '/home/cs3hq/abide_multitask_learning/'
#dir = '/if19/cs3hq/qilab/'
dir = '/Users/chandansingh/drive/research/singh_connectome/'
data_dir = paste0(dir,"data/abide_data/cpac_nofilt_noglobal/")
source(paste0(dir,"src/main/init.R"))
setwd(paste0(dir,"data"))

# set params
dataset = "full" #values: full,nyu - picks what dataset to use
norm = F #not currently being used, has to do with normalizing orig data
seed=1 #seed for how to split training data
calc_graphs=F
calc_idxs=F
calc_acc=T
calc_conn=F
calc_ll=F

# loading all data
dists_orig = as.matrix(read.table(file="dists.csv",sep=",",header=F, check.names=FALSE)) # dists (160x160)
labels = as.matrix(read.table(file="labels.csv",sep=",",header=F, check.names=FALSE)) # labels (160x1, 40 unique)
networks = as.matrix(read.table(file="networks.csv",sep=",",header=F, check.names=FALSE)) # networks (160x1, 6 unique)
if(calc_ll){
    load_ll_data(norm) # load ll data (set cors_nsimule_ll,...,data_ll)
}
data = load_data(dataset) # load data
format_data(dataset) # nyu, full
partition_data(seed)

# need to calc cors_train
data_train = data[train_idxs]
n_control_train = sum(train_idxs<=N_autism)
n_autism_train = length(train_idxs) - n_control_train
data_train_flattened = flatten_classes(data_train,n_control_train,n_autism_train)
# calc_all_cors(paste0("cors_",dataset,"_",seed),data_train_flattened)
# or load cors_train
load_all_cors(paste0("cors_",dataset,"_",seed)) # cors_nyu_1, cors_full

# calc graphs, ll, acc
pres = c("n","")
suffs= c("","_i") # "_p"
train_set = paste0(dataset,'_',seed) # likelihood, classification/nyu_1


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
do.call(task[[1]],args=task[[2]])
