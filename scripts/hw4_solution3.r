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
MTweedieTestsMaxCores <- function(N, M, sig) {
  # Get the maximum number of available CPU cores
  num_cores <- detectCores()
  
  # Create a cluster with all available cores
  cl <- makeCluster(num_cores)
  
  # Split the total number of simulations (M) across cores
  simulations_per_core <- ceiling(M / num_cores)
  
  # Use foreach to perform simulations in parallel
  results <- foreach(i = 1:num_cores, .combine = "c") %dopar%
    replicate(simulations_per_core, simTweedieTest(N) < sig)
  
  # Close the cluster
  stopCluster(cl)
  
  # Combine the results from all cores and calculate the proportion
  proportion <- mean(unlist(results))
  
  return(proportion)
}

# Assignment 3:  
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 

for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
} 

