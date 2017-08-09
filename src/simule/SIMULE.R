#A simplex solver for linear programming problem in (N)SIMULE
linprogSPar <- function(i, Sigma, lambda) {
    #num of p * N
    #pTimesN = nrow(Sigma)
    #num of p * (N + 1)
    q = ncol(Sigma)
    p = ncol(Sigma) - nrow(Sigma)
    N = nrow(Sigma) / p
    e = rep(0, p * N)
    for(j in 1:N){
        e[i + (j - 1) * p] = 1    
    }

    f.obj = rep(1, 2 * q)
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

#SIMULE implementation
SIMULE <- function(Cors, lambda, epsilon, parallel = FALSE ){
    if (parallel == TRUE) {
        library("parallel")
    }
    Graphs = list()
    N = length(Cors)
    p = ncol(Cors[[1]])
    xt = matrix(0, (N + 1) * p, p)
    I = diag(1, p, p)
    Z = matrix(0, p, p)
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
    
    f = function(x) linprogSPar(x,A,lambda)
    
    if(parallel == TRUE){
        no_cores = detectCores() - 1
        cl = makeCluster(no_cores)
        clusterExport(cl, list("f", "A","lambda", "linprogSPar","lp"), envir = environment())
        result = parLapply(cl, 1:p, f)
        #print('Done!')
        for (i in 1:p){
            xt[,i] = result[[i]]

        }
        stopCluster(cl)
    }else{
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
        Graphs[[i]] = xt[(1 + (i-1)*p):(i*p),] + 1/(epsilon * N) * xt[(1+N*p):((N+1)*p),] # 2nd part is shared
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
      
    # CHANGE ALL i to N+1
      Graphs[[N+1]] = 1/(epsilon * N) * xt[(1+N*p):((N+1)*p),] # Last arg returned is the shared graph
      for(j in 1:p){
        for(k in j:p){
          if (abs(Graphs[[N+1]][j,k]) < abs(Graphs[[N+1]][k,j])){
            Graphs[[N+1]][j,k] = Graphs[[N+1]][j,k]
            Graphs[[N+1]][k,j] = Graphs[[N+1]][j,k]
          }
          else{
            Graphs[[N+1]][j,k] = Graphs[[N+1]][k,j]
            Graphs[[N+1]][k,j] = Graphs[[N+1]][k,j]                    
          }
        }
      }
    
    return(Graphs)
}



