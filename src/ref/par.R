library(foreach)
library(doMC)
registerDoMC(2)  #change the 2 to your number of CPU cores  

test_1 <- function(arg1,arg2){
    print(paste0("test1",arg1))
    print(arg2)
}


do.call("test_1",args=list("x",c(3,4,5)))

dummy = foreach(i=1:10) %dopar% {
  do.call("test_1",args=list("x",c(i,4,5)))
}