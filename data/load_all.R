# set to directory containing the data
setwd('/Users/chandansingh/drive/asdf/research/singh_connectome/data') 

# loads "data"
# data a list of 871 matrices (nix160) where ni varies
# each matrix in data represents observations for one subject
# the first 468 entries are control subjects
# the last 403 entries are autism subjects
load('data_subjects.RData') 

# loads data_list (is same as "data" but in another form)
# data_list is a list of length 2
# each entry is a matrix containing all the observations for one class
# first entry is control, second entry is autism
load('data_list.RData')

# loads (160x160) matrix representing euclidean distances between features
dists = as.matrix(read.table(file="dists.csv",sep=",",header=F, check.names=FALSE))

# loads (160x1) cluster labels (40 unique) for each of the features
labels = as.matrix(read.table(file="labels.csv",sep=",",header=F, check.names=FALSE))

# loads (160x1) higher-level cluster labels (6 unique) for each of the featues
networks = as.matrix(read.table(file="networks.csv",sep=",",header=F, check.names=FALSE))
