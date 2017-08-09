#A simplex solver for linear programming problem in (N)SIMULE
linprogSPar_dist <- function(i, Sigma, D, lambda){
  # num of p * N
  # pTimesN = nrow(Sigma)
  # num of p * (N + 1)
  # Get parameters
  q = ncol(Sigma)
  p = ncol(Sigma) - nrow(Sigma)
  N = nrow(Sigma) / p
  # Generate e_j
  e = rep(0, p * N)
  for(j in 1:N){
    e[i + (j - 1) * p] = 1    
  }
  # linear programming solution
  f.obj = rep(D[i, ], 2 * (N + 1))
  con1 = cbind(-Sigma, +Sigma)
  b1 = lambda - e
  b2 =  lambda + e
  f.con = rbind(-diag(2 * q), con1, -con1)
  f.dir = rep("<=", 4 * q)
  f.rhs = c(rep(0, 2 * q), b1, b2)
  lp.out = lp("min", f.obj, f.con, f.dir, f.rhs)
  beta = lp.out$solution[1:q] - lp.out$solution[(q + 1):(2 * q)]
  if (lp.out$status == 2) warning("No feasible solution!  Try a larger tuning parameter!")
  return(beta)
}

# (N)SIMULE implementation
# add a distance function D for weighted l1 penalty
simule_dist <- function(Cors, lambda, epsilon, D, parallel = FALSE ){
  if (parallel == TRUE) {
    library("parallel")
  }
  # initialize the parameters
  Graphs = list()
  N = length(Cors)
  p = ncol(Cors[[1]])
  xt = matrix(0, (N + 1) * p, p)
  I = diag(1, p, p)
  Z = matrix(0, p, p)
  # generate the condition matrix A
  A = Cors[[1]]
  for(i in 2:N){
    A = cbind(A,Z)
  }
  A = cbind(A,(1/N)*Cors[[1]])
  for(i in 2:N){
    temp = Z
    for(j in 2:N){
      if (j == i){
        temp = cbind(temp,Cors[[i]])
      }
      else{
        temp = cbind(temp,Z)
      }
    }
    temp = cbind(temp, 1/(epsilon * N) * Cors[[i]])
    A = rbind(A, temp)
  }
  # define the function f for parallelization
  f = function(x) linprogSPar_dist(x, A, D, lambda)
  
  if(parallel == TRUE){ # parallel version
    # number of cores to collect, 
    # default number is number cores in your machine - 1,
    # you can set your own number by changing this line.
    no_cores = detectCores() - 1
    cl = makeCluster(no_cores)
    # declare variable and function names to the cluster
    clusterExport(cl, list("f", "A", "D", "lambda", "linprogSPar_dist", "lp"), envir = environment())
    result = parLapply(cl, 1:p, f)
    #print('Done!')
    for (i in 1:p){
      xt[,i] = result[[i]]
    }
    stopCluster(cl)
  }else{ # single machine code
    for (i in 1 : p){
      xt[,i] = f(i)
      if (i %% 10 == 0){
        cat("=")
        if(i %% 100 == 0){
          cat("+")
        }
      }
    }
    print("Done!")
  }
  
  for(i in 1:N){
    # combine the results from each column. (\hat{\Omega}_{tot}^1)
    Graphs[[i]] = xt[(1 + (i-1) * p):(i * p),] + 1/(epsilon * N) * xt[(1 + N * p):((N + 1) * p),]
    # make it be symmetric 
    for(j in 1:p){
      for(k in j:p){
        if (abs(Graphs[[i]][j,k]) < abs(Graphs[[i]][k,j])){
          Graphs[[i]][j,k] = Graphs[[i]][j,k]
          Graphs[[i]][k,j] = Graphs[[i]][j,k]
        }
        else{
          Graphs[[i]][j,k] = Graphs[[i]][k,j]
          Graphs[[i]][k,j] = Graphs[[i]][k,j]                    
        }
      }
    }
  }
  return(Graphs)
}