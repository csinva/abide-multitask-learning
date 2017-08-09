cd('/Users/chandansingh/drive/asdf/research/singh_connectome/direct_learning')
addpath('minConf')
addpath('minConf/minFunc')
addpath('minConf/minConf')
% main portal for ratio structure learning
seed= 1;
rng(seed)

% load data
data_path = '/Users/chandansingh/drive/asdf/research/qi_lab/SinghU-shared/ModelCode/run_simule/data';
%control = csvread([data_path '/control.csv'],1,1);
%autism = csvread([data_path '/autism.csv'],1,1);

%generate samples
p = 161;
n_test = 300;
n_train = 100;
[x1, adj_nu] = random_sparse_sparse2(seed,p,n_train+n_test,'nu',false); % adj contains the gt
[x2, adj_de] = random_sparse_sparse2(seed,p,n_train+n_test,'de',false); % adj contains the gt
%x1 = control;
%x2 = autism;
idx = randperm(n_train+n_test);
x_nu = x1(idx(1:n_train),:)'; % training for class 1
x_de = x2(idx(1:n_train),:)'; % training for class 2 
x_nu_t = x1(idx(n_train+1:end),:)';
x_de_t = x2(idx(n_train+1:end),:)';

%sample parameters
p = size(x_nu,1);
n = size(x_nu,2)+size(x_de,2);
n_nu = size(x_nu,2);
n_test_nu = size(x_nu_t,2);

%method parameters
lambda_list = logspace(0,-2,8);
b = 6;
lambda_1 = 0.2;
flag = false;
clk = clock;

%masks for univariate and pairwise cliques
mc = cliques12(p);
mc_1 = mc(:,sum(mc,1)==1);
mc_2 = mc(:,sum(mc,1)==2);
mc = [mc_1, mc_2];
mc = logical(mc);
c = size(mc,2);
fprintf('done\n') 

%% run method
theta_init = zeros(b,c);
k = kernelize_poly(x_nu,x_de,[x_nu_t,x_de_t],mc,b);
reg_path = [];
LL = [];
LL_t = [];
theta_path = zeros(b,c,length(lambda_list));
idxs_list = {};
tic
fprintf('done\n') 
%% compute the regularization path
for i_=1:length(lambda_list)
    lambda = lambda_list(i_);
    display(sprintf('%d: lambda2:%f',i_,lambda))
    theta_init = estimate_log_density_ratio(theta_init,k(:,1:n),...
        n_nu,b,p,c,lambda_1,lambda);
    
    theta1 = theta_init(1,:);
    theta1_reshaped = triu(ones(p),1)+eye(p);
    theta1_reshaped(theta1_reshaped==1)=theta1;
    idxs = find(theta1_reshaped);
    idxs_list{i_}=idxs;
end
elapsed_time = toc;
display(sprintf('total elapsed time: %.2f', elapsed_time))

%% save idxs_list
fileID = fopen('idxs_list.txt','w');
for r=1:length(lambda_list)
    idxs = idxs_list{r};
    fprintf(fileID,'%f, %f, ',lambda_1,lambda_list(r));    
    for c=1:length(idxs)
        fprintf(fileID,'%d, ',idxs(c));    
    end
    fprintf(fileID,'\n');
end
fclose(fileID);