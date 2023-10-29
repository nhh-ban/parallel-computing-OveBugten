# Assignment 1:  
library(tweedie) 
library(ggplot2)
library(tictoc)

simTweedieTest <-  
  function(N){ 
    t.test( 
      rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 

# Assignment 2:  
MTweedieTests <-  
  function(N,M,sig){ 
    sum(replicate(M,simTweedieTest(N)) < sig)/M 
  } 


# Assignment 3:  
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 

#Rewritten lines 29-35
# Register the number of available cores for parallel processing
# Determine the maximum number of cores you'd like to use
maxcores <- 8
Cores <- min(parallel::detectCores(), maxcores)

# Instantiate the cores:
cl <- makeCluster(Cores)

# Register the cluster for parallel processing
registerDoParallel(cl)

results <- foreach(i=1:nrow(df), .combine = "c", .packages = c('tweedie')) %dopar% 
  {MTweedieTests(N=df$N[i], M=df$M[i], sig=.05)}

# Assign results to df column
df$share_reject <- results

# Stop the cluster after computation
stopCluster(cl)

